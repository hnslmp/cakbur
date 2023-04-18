//
//  MyApp.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI

@main
struct MyApp: App {
    init() {
            CustomFont.registerFonts()
        }
    
    var body: some Scene {
        WindowGroup {
            GameView()
//            OnboardingView()
        }
    }
}
