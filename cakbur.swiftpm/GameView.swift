//
//  GameView.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
//    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding = true
    @State var shouldShowOnboarding = false

    @ObservedObject var scene = GameScene()
    
    var body: some View {
        if !shouldShowOnboarding {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
        } else if scene.score == 1{
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        }
    }
}
