//
//  CustomFont.swift
//  Cakbur
//
//  Created by Hansel Matthew on 18/04/23.
//

import SwiftUI

public struct CustomFont {
    public static func registerFonts() {
        registerFont(bundle: Bundle.main , fontName: "PressStart2P", fontExtension: ".ttf")
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
