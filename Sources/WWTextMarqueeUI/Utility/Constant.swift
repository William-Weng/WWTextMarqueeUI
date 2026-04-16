//
//  Constant.swift
//  WWTextMarqueeUI
//
//  Created by William.Weng on 2026/4/16.
//

import UIKit
import WWTextRasterizer

// MARK: - 預設值
public extension WWTextMarqueeUI {
    
    static let defaultConfiguration: Configuration = .init(font: .systemFont(ofSize: 16), targetHeight: 36, threshold: 110, horizontalPadding: 5, trimHorizontalEmptySpace: true, characterGap: 2)
    static let defaultLEDColorSetting: LEDColorSetting = (on: .green, off: .green.withAlphaComponent(0.12), background: .black)
    static let defaultDotSetting: DotSetting = (size: 4, spacing: 3, type: .square(0.22))
    static let defaultGlowSetting: GlowSetting = (opacity: 0.16, insetRatio: 0.18, offset: .zero)
}

// MARK: - typealias
public extension WWTextMarqueeUI {
    
    typealias Configuration = WWTextRasterizer.Configuration
    typealias LEDColorSetting = WWTextRasterizer.LEDColorSetting
    typealias DotSetting = WWTextRasterizer.DotSetting
    typealias GlowSetting = WWTextRasterizer.GlowSetting
}

// MARK: - enum
public extension WWTextMarqueeUI {
    
    /// 垂直對準類型 - 上 / 中 / 下
    enum VerticalAlignmentMode : Sendable{
        
        public static let top = Self.top()
        public static let center = Self.center()
        public static let bottom = Self.bottom()
        
        case top(_ offsetY: CGFloat = 0)
        case center(_ offsetY: CGFloat = 0)
        case bottom(_ offsetY: CGFloat = 0)
        
        /// 計算出校準後的值
        /// - Parameters:
        ///   - panelHeight: 面板高度
        ///   - textHeight: 文字高度
        /// - Returns: CGFloat
        func originY(by panelHeight: CGFloat, textHeight: CGFloat) -> CGFloat {
            switch self {
            case .top(let offset): return offset
            case .center(let offset): return (panelHeight - textHeight) * 0.5 + offset
            case .bottom(let offset): return panelHeight - textHeight + offset
            }
        }
    }
}
