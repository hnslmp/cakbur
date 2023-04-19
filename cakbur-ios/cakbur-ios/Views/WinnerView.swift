//
//  WinnerView.swift
//  Cakbur
//
//  Created by Hansel Matthew on 18/04/23.
//

import SwiftUI

struct WinnerView: View {
    
    @Binding var score: Int
            
    var body: some View {
        VStack {
            Text("YOU WIN!")
                .font(.custom("PressStart2P", size: 72))
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 100)
                .padding(.vertical, 30)
                .foregroundColor(.cakburYellow)
            
            Text("Fun fact of the day:\nThis game has many names such as Gobak Sodor, Galah Asin, Galasin, Gobag, Galah Panjang and finally Cakbur!")
                .font(.custom("PressStart2P", size: 20))
                .lineSpacing(8)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 100)
                .padding(.vertical, 30)
                .foregroundColor(.white)
            
            Button {
                withAnimation {
                    score = 0
                }
            } label: {
                ZStack {
                    Image("button-background-blue")
                        .frame(width: 300,height: 50)
                    Text("Play Again")
                        .font(.custom("PressStart2P", size: 20))
                        .foregroundColor(Color.white)
                        .frame(width: 300,height: 50)
                }
            }.padding(.vertical, 30)
            
//            Spacer()
        }.frame(maxWidth: .infinity,
                maxHeight: .infinity)
    }
}
