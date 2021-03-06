//
//  UIColor+Adjust.swift
//  Dewey
//
//  Created by Jessica Huynh on 2020-05-03.
//  Copyright © 2020 Jessica Huynh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func lighten(by percentage: CGFloat = 30.0) -> UIColor {
         return self.adjust(by: abs(percentage) )
     }

     func darken(by percentage: CGFloat = 30.0) -> UIColor {
         return self.adjust(by: -1 * abs(percentage) )
     }

     func adjust(by percentage: CGFloat = 30.0) -> UIColor {
         var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
         if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
             return UIColor(red: min(red + percentage/100, 1.0),
                            green: min(green + percentage/100, 1.0),
                            blue: min(blue + percentage/100, 1.0),
                            alpha: alpha)
         } else {
             return self
         }
     }
    
    func isLight(threshold: Float = 0.5) -> Bool? {
        let RGBCGColor = self.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(),
                                                intent: .defaultIntent,
                                                options: nil)
        guard let components = RGBCGColor?.components else { return nil }
        guard components.count >= 3 else { return nil }

        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return brightness > threshold
    }
}
