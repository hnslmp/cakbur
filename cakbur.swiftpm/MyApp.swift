//
//  MyApp.swift
//  cakbur
//
//  Created by Hansel Matthew on 15/04/23.
//

import SwiftUI
import AVKit

@main
struct MyApp: App {
    
    var audioPlayer: AVAudioPlayer?
    
    init() {
        CustomFont.registerFonts()
                
        if let audioURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "wav") {
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOf: audioURL)
                self.audioPlayer?.numberOfLoops = -1
                self.audioPlayer?.play()
            } catch {
                print("Couldn't play audio. Error: \(error)")
            }
        } else {
            print("No audio file found")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            GameView()
                .background(Color.cakburBlack)
        }
    }
}
