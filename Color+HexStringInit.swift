//
//  Color+HexStringInit.swift
//  quick questionnaire composer
//
//  Created by Nahid Islam on 19/02/2023.
//

import SwiftUI

extension Color {
    init?(hex: String, colorSpace: RGBColorSpace = .sRGB) {
        let input =  hex.trimmingCharacters(in: .whitespaces)
        guard input.first == "#" && input.count == 7 else { return nil }
        
        func hexi(section: Int) -> String {
            let eq = section * 2
            
            let lower = input.index(input.startIndex, offsetBy: eq - 1)
            let upper = input.index(input.startIndex, offsetBy: eq + 1)
            
            return String(input[lower..<upper])
        }
        
        func floatThe(string value: String) -> CGFloat {
            let val = Int(value, radix: 16)!
            let max: Double = 255
            
            return Double(val) / max
        }
        
        let rHex = hexi(section: 1)
        let gHex = hexi(section: 2)
        let bHex = hexi(section: 3)
        
        let rValue = floatThe(string: rHex)
        let gValue = floatThe(string: gHex)
        let bValue = floatThe(string: bHex)
        
        self.init(colorSpace, red: rValue, green: gValue, blue: bValue)
    }
    
    init?(scheme: ColorScheme, dark: String, light: String) {
        switch scheme {
        case .dark:
            guard let darkColor = Color(hex: dark, colorSpace: .displayP3) else { return nil }
            self = darkColor
        case .light:
            guard let lightColor = Color(hex: light, colorSpace: .displayP3) else { return nil }
            self = lightColor
        @unknown default:
            fatalError("new color dropped")
        }
    }
    
    var hexValue: String? {
        guard let colorComp = self.cgColor?.components else { return nil }
        
        let colorR = Int(colorComp[0] * 255)
        let colorG = Int(colorComp[1] * 255)
        let colorB = Int(colorComp[2] * 255)
        
        return String(format:"#%02x%02x%02x", colorR, colorG, colorB)
    }
}
