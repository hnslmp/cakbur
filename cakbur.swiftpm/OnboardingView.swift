//
//  OnboardingView.swift
//  cakbur
//
//  Created by Hansel Matthew on 18/04/23.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        TabView {
            PageView(title: "Welcome to\nCakbur the iPad Game",
                     subtitle: "Cakbur is a traditional game in Indonesia. This game is known by various names such as Gobak Sodor, Galah Asin, Galasin, or Gobag.",
                     imageName: "sample-screenshot",
                     showSwipeIndicator: true,
                     shouldShowOnboarding: $shouldShowOnboarding
            )
            
            PageView(title: "How to play",
                     subtitle: "This game is played by 2 teams, the attacking team and the defending team. Each team can have 3 to 5 members. The playing area is a rectangular shape divided into 6 squares.",
                     imageName: "sample-screenshot",
                     shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(title: "The Defending Team",
                     subtitle: "The defending team is in charge of guarding the line and blocking the attacking team from reaching the finish area. Defenders can only move within the line of the track they are guarding and may not cross or exit the line.",
                     imageName: "sample-screenshot",
                     shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(title: "The Attacking Team",
                     subtitle: "The attacking team's job is to make all members of the attacking team reach the finish line without being hit by any of the defender team member. In this game, you will be the attack team.",
                     imageName: "sample-screenshot",
                     showDismissButton: true,
                     shouldShowOnboarding: $shouldShowOnboarding)
            
        }.tabViewStyle(PageTabViewStyle())
            .background(Color.cakburBlack)
    }
}

struct PageView: View {
    
    let title: String
    let subtitle: String
    let imageName: String
    var showDismissButton: Bool = false
    var showSwipeIndicator: Bool = false
    
    @Binding var shouldShowOnboarding: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500)
                .padding(.horizontal, 100)
                .padding(.vertical, 80)
            
            Text(title)
                .font(.custom("PressStart2P", size: 30))
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 100)
                .padding(.vertical, 30)
                .foregroundColor(.cakburYellow)
            
            Text(subtitle)
                .font(.custom("PressStart2P", size: 20))
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 100)
                .padding(.vertical, 30)
                .foregroundColor(.white)
            
            if showDismissButton {
                Button {
                    withAnimation {
                        shouldShowOnboarding = false
                    }
                } label: {
                    ZStack {
                        Image("button-background-blue")
                            .frame(width: 300,height: 50)
                        Text("Press to begin")
                            .font(.custom("PressStart2P", size: 20))
                            .foregroundColor(Color.white)
                            .frame(width: 300,height: 50)
                    }
                }.padding(.vertical, 30)

            }
            
            if showSwipeIndicator {
                Text("Swipe to continue")
                    .font(.custom("PressStart2P", size: 14))
                    .lineSpacing(8)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 30)
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
}
