//
//  OnboardingView.swift
//  cakbur
//
//  Created by Hansel Matthew on 18/04/23.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            PageView(title: "title", subtitle: "subtitle", imageName: "sample-screenshot")
            
            PageView(title: "title", subtitle: "subtitle", imageName: "sample-screenshot")
            
            PageView(title: "title", subtitle: "subtitle", imageName: "sample-screenshot")
            
            PageView(title: "title", subtitle: "subtitle", imageName: "sample-screenshot")
        }.tabViewStyle(PageTabViewStyle())
            .background(Color.cakburBlack)
    }
}

struct PageView: View {
    
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 500)
                .padding()

            Text(title)
                .font(.system(size: 48))
                .padding()
                .foregroundColor(.cakburYellow)
            
            Text(subtitle)
                .font(.system(size: 32))
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.cakburYellow)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
