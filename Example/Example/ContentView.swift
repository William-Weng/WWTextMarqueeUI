//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/4/16.
//

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
