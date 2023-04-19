//
//  Extension.swift
//  cakbur
//
//  Created by Hansel Matthew on 18/04/23.
//

import UIKit
import SwiftUI

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    
    static let cakburBlack = UIColor(rgb: 0x020406)
    static let cakburBlue = UIColor(rgb: 0x0F1B5A)
    static let cakburPaleBlue = UIColor(rgb: 0x3B4483)
    static let cakburDarkBlue = UIColor(rgb: 0x0D0026)
    static let cakburYellow = UIColor(rgb: 0xF4CE4A)
    static let cakburDarkYellow = UIColor(rgb: 0x3F3717)
    static let cakburBackgroundBlue = UIColor(rgb: 0x050A1B)
    
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        scanner.scanHexInt64(&hexNumber)
        
        let red = Double((hexNumber & 0xff0000) >> 16) / 255.0
        let green = Double((hexNumber & 0x00ff00) >> 8) / 255.0
        let blue = Double(hexNumber & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    static let cakburBlack = Color(hex: "020406")
    static let cakburBlue = Color(hex: "0F1B5A")
    static let cakburPaleBlue = Color(hex: "3B4483")
    static let cakburDarkBlue = Color(hex: "0D0026")
    static let cakburYellow = Color(hex: "F4CE4A")
}

