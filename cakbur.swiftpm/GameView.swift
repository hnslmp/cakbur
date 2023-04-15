//
//  GameView.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
        
    }
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
