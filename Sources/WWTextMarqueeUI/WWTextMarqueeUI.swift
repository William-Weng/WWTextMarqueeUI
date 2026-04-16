//
//  WWTextMarqueeUI.swift
//  WWTextMarqueeUI
//
//  Created by William.Weng on 2026/4/16.
//

import SwiftUI
import WWTextRasterizer

// MARK: - 文字跑馬燈
public struct WWTextMarqueeUI: View {
        
    @State private var baseImage: UIImage?
    @State private var textImage: UIImage?
    @State private var startDate = Date()
    
    private let text: String
    private let columns: Int
    private let rows: Int
    private let speed: CGFloat
    private let config: Configuration
    private let verticalAlignment: VerticalAlignmentMode
    private let ledColor: LEDColorSetting
    private let dot: DotSetting
    private let glow: GlowSetting
    private let scale: CGFloat
    private let opaque: Bool
    private let isPlaying: Bool
    
    /// 建立一個 LED 跑馬燈文字元件。此元件會使用 `WWTextRasterizer` 將文字轉成點矩陣影像，並在固定大小的 LED 面板上由右往左播放跑馬燈效果。
    /// - Parameters:
    ///   - text: 要顯示的文字內容。
    ///   - columns: LED 面板的欄數。
    ///   - rows: LED 面板的列數，預設值為 `64`。
    ///   - speed: 跑馬燈捲動速度，單位為 point / second，預設值為 `120`。
    ///   - config: `WWTextRasterizer` 的文字光柵化設定。
    ///   - verticalAlignment: 文字影像在面板中的垂直對齊方式。
    ///   - ledColor: LED 的亮燈、暗燈與背景色設定。
    ///   - dot: LED 點的大小、間距與形狀設定。
    ///   - glow: 亮燈時的發光效果設定。
    ///   - scale: 產生 LED 點陣影像時使用的縮放倍率。
    ///   - opaque: 產生底圖時是否使用不透明背景。
    ///   - isPlaying: 是否播放跑馬燈動畫。
    public init(text: String, columns: Int, rows: Int = 64, speed: CGFloat = 120, config: Configuration = Self.defaultConfiguration, verticalAlignment: VerticalAlignmentMode = .center, ledColor: LEDColorSetting = Self.defaultLEDColorSetting, dot: DotSetting = Self.defaultDotSetting, glow: GlowSetting = Self.defaultGlowSetting, scale: CGFloat = 1, opaque: Bool = true, isPlaying: Bool = true) {
        self.text = text
        self.config = config
        self.columns = columns
        self.rows = rows
        self.speed = speed
        self.verticalAlignment = verticalAlignment
        self.ledColor = ledColor
        self.dot = dot
        self.glow = glow
        self.scale = scale
        self.opaque = opaque
        self.isPlaying = isPlaying
    }
    
    public var body: some View {
        
        let panelSize = baseImage?.size ?? .zero
        let panelWidth = panelSize.width
        let panelHeight = panelSize.height
        
        let textSize = textImage?.size ?? .zero
        let textWidth = textSize.width
        let textHeight = textSize.height
        
        TimelineView(.animation) { timeline in
            
            let originX = marqueeOriginX(at: timeline.date, panelWidth: panelWidth, textWidth: textWidth)
            
            let originY = verticalAlignment.originY(by: panelHeight, textHeight: textHeight)
            
            ZStack(alignment: .topLeading) {
                
                if let baseImage {
                    Image(uiImage: baseImage)
                        .interpolation(.none)
                }
                
                if let textImage {
                    Image(uiImage: textImage)
                        .interpolation(.none)
                        .position(x: originX + textWidth * 0.5, y: originY + textHeight * 0.5)
                }
            }
            .frame(width: panelWidth, height: panelHeight, alignment: .topLeading)
            .clipped()
        }
        .frame(width: panelWidth, height: panelHeight)
        .clipped()
        .onAppear {
            redrawImage()
        }
        .onChange(of: text, initial: false) { _, _ in
            redrawImage()
            startDate = .now
        }
    }
}

// MARK: - 主功能
private extension WWTextMarqueeUI {
    
    /// 計算跑馬燈文字在當前時間下，水平起始座標（X）的位置。用 `truncatingRemainder` 取餘數，讓距離在 [0, totalDistance) 之間循環
    /// - Parameters:
    ///   - date: 當前時間，來自 `TimelineView(.animation)` 的 `timeline.date`。
    ///   - panelWidth: LED 面板的寬度（點矩陣影像的畫布寬度）。
    ///   - textWidth: 轉換成點矩陣後，文字圖片的寬度。
    /// - Returns: 文字圖片左邊緣在面板中的 X 座標，該值會在 `0` 至 `panelWidth` 之間循環。
    func marqueeOriginX(at date: Date, panelWidth: CGFloat, textWidth: CGFloat) -> CGFloat {
        
        guard isPlaying,
              panelWidth > 0,
              textWidth > 0
        else {
            return panelWidth
        }

        let elapsed = date.timeIntervalSince(startDate)
        let totalDistance = panelWidth + textWidth
        let traveled = CGFloat(elapsed) * speed
        let wrapped = traveled.truncatingRemainder(dividingBy: totalDistance)

        return panelWidth - wrapped
    }
}

// MARK: - 小工具
private extension WWTextMarqueeUI {
    
    /// 重新產生跑馬燈所需的全部影像資源，並重設動畫起始時間。完成後會將 `startDate` 更新為目前時間，讓跑馬燈動畫從初始位置重新開始播放。
    func redrawImage() {
        redrawBaseImage()
        redrawTextImage()
        startDate = .now
    }

    /// 重新產生 LED 面板的底圖。此底圖只包含「未點亮」的 LED 點陣背景，例如暗燈顏色、點大小、點間距與面板列欄數等資訊。
    func redrawBaseImage() {
        
        baseImage = WWTextRasterizer.renderLEDMatrixBase(
            columns: columns,
            rows: rows,
            ledColor: ledColor.off,
            dot: dot,
            scale: scale,
            opaque: opaque
        )
    }
    
    /// 重新產生文字的 LED 點陣影像。此方法會先使用 `WWTextRasterizer` 將文字轉成點矩陣資料，再根據亮燈顏色、發光效果與 LED 點樣式，將矩陣資料渲染成可顯示的文字影像。
    func redrawTextImage() {
        
        let rasterizer = WWTextRasterizer(config: config)
        let result = rasterizer.convert(text)
        
        textImage = result.matrix.renderLEDMatrixText(
            columns: result.matrix.width,
            rows: result.matrix.height,
            offsetX: 0,
            offsetY: 0,
            ledColor: ledColor.on,
            dot: dot,
            glow: glow,
            scale: scale
        )
    }
}
