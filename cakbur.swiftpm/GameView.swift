//
//  GameView.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    
    @StateObject var scene: GameScene = {
        let scene = GameScene()
        return scene
    }()
    
    var body: some View {
        Group {
            if scene.score == 5 {
                WinnerView(score: $scene.score)
            } else if !shouldShowOnboarding {
                SpriteView(scene: scene)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
            } else {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
            }
        }
    }
}
