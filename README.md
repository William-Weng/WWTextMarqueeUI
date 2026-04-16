# [WWTextMarqueeUI](https://swiftpackageindex.com/William-Weng)
![SwiftUI](https://img.shields.io/badge/SwiftUI-524520?logo=swift) [![Swift-6.1](https://img.shields.io/badge/Swift-6.1-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-17.0](https://img.shields.io/badge/iOS-17.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![TAG](https://img.shields.io/github/v/tag/William-Weng/WWTextMarqueeUI) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## 🎉 [相關說明](https://developer.apple.com/documentation/coretext/ctline)

- `WWTextMarqueeUI` is a SwiftUI wrapper for rendering LED-style marquee text using `WWTextRasterizer`.
- 一個用 SwiftUI 封裝的 LED 跑馬燈文字元件，內部使用 `WWTextRasterizer` 將文字轉成點矩陣影像，呈現出 LED 標示牌的跑馬燈效果。

---

## 📷 [效果預覽](https://peterpanswift.github.io/iphone-bezels/)

![](https://github.com/user-attachments/assets/4e6bb961-c7f2-40ff-a51b-724ea9668387)

https://github.com/user-attachments/assets/b9c72fec-0f4f-4461-b95a-e5410f251dd8

<div align="center">

**⭐ 覺得好用就給個 Star 吧！**

</div>

---

## ✨ [特性](https://github.com/William-Weng/WWTextRasterizer)

- 純 SwiftUI API，可以直接嵌入 SwiftUI 畫面。
- 底層依賴 `WWTextRasterizer` 處理文字光柵化與 LED 點陣渲染。
- 可設定面板的欄數（`columns`）、列數（`rows`）。
- 可自訂字型、字高、亮度門檻值、字間距等 `Configuration`。
- 可調整跑馬燈速度 `speed`，也能暫停 / 恢復播放。
- 支援垂直對齊 `verticalAlignment`：上、中、下。
- 可自訂 LED 顏色、點大小、點間距、發光效果 `glow`。
- 用 `TimelineView(.animation)` 跑動畫，維持較輕量的更新方式。

---

## 🍄 [設計思路](https://william-weng.github.io/)

`WWTextMarqueeUI` 把畫面分成兩層：

1. 一個「靜態底圖」，用 `WWTextRasterizer.renderLEDMatrixBase(...)` 產生。
2. 一個「文字影像」，把文字轉成點陣圖，用 `WWTextRasterizer` 的 `renderLEDMatrixText(...)` 渲染出來。

動畫本身只會在 `TimelineView(.animation)` 裡，根據 `startDate` 與 `speed`，重新計算 `textImage` 的 X 座標，讓文字由右往左跑；而「重新產生光柵化圖片」只會在 `text` 或樣式改變時觸發，平常播放時只做位移，所以比較輕量。

---

## 💿 [安裝方式](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b )

使用 **Swift Package Manager (SPM)**：

```swift
dependencies: [
    .package(url: "https://github.com/William-Weng/WWTextMarqueeUI", .upToNextMinor(from: "1.0.0"))
]
```

---

## 🧲 內部參數

| 參數名稱 | 說明 |
|-----------|------|
| `text` | 要顯示的文字內容。 |
| `columns` / `rows` | LED 顯示面板的欄數與列數。 |
| `config` | `WWTextRasterizer.Configuration`，負責字型、字高、亮度門檻等設定。 |
| `speed` | 跑馬燈速度，單位為 point / second。 |
| `verticalAlignment` | 文字在面板中的垂直對齊方式（`.top`、`.center`、`.bottom`）。 |
| `ledColor` | LED 亮燈、暗燈與背景顏色。 |
| `dot` | LED 點的大小、間距與形狀。 |
| `glow` | 發光效果，包含透明度、內縮比例與偏移。 |

---

## ⚡ 用法

基本上使用者只需要提供文字、點矩陣大小、字型設定與 LED 樣式，就可以直接使用 `WWTextMarqueeUI`。

```swift
import SwiftUI
import WWTextMarqueeUI

struct ContentView: View {
    
    var body: some View {
        WWTextMarqueeUI(
            text: "安安你好嗎？",
            columns: 128,
        )
        .background(Color.black)
    }
}
```
