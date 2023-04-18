//
//  GameView.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    
    @StateObject var scene = GameScene()
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .edgesIgnoringSafeArea(.all)
            
            Text("\(scene.activeAttackerIndex)")
        }
    }
}
