//
//  PMAFontSize.swift
//  pcaf-mbl-prmg
//
//  Created by tamilarasan_v on 09/10/24.
//

import SwiftUI
import UIKit

extension Font {
    public struct PMA {
        public static func regular(size: PMAFontSize) -> Font {
            .custom("SFProtext-Regular", size: size.rawValue)
        }

        public static func light(size: PMAFontSize) -> Font {
            .custom("SFProText-Light", size: size.rawValue)
        }
        public static func normal(size: PMAFontSize) -> Font {
            .custom("SFProtext-Normal", size: size.rawValue)
        }
        public static func medium(size: PMAFontSize) -> Font {
            .custom("SFProText-Medium", size: size.rawValue)
        }
        public static func bold(size: PMAFontSize) -> Font {
            .custom("SFProText-Bold", size: size.rawValue)
        }
        public static func displayRegular(size: PMAFontSize) -> Font {
            .custom("SFProDisplay-Regular", size: size.rawValue)
        }
        public static func displayBold(size: PMAFontSize) -> Font {
            .custom("SFProDisplay-Bold", size: size.rawValue)
        }
        public static func displayMedium(size: PMAFontSize) -> Font {
            .custom("SFProDisplay-Medium", size: size.rawValue)
        }
        public static func displaySemiBold(size: PMAFontSize) -> Font {
            .custom("SFProDisplay-Semibold", size: size.rawValue)
        }
        public static func semiBold(size: PMAFontSize) -> Font {
            .custom("SFProText-Semibold", size: size.rawValue)
        }
        public static func proMedium(size: PMAFontSize) -> Font {
            .custom("SFPro-Medium", size: size.rawValue)
        }
    }
    
   public enum PMAFontSize: CGFloat {
        case ten = 10.0
        case eleven = 11.0
        case twelve = 12.0
        case thirteen = 13.0
        case fourteen = 14.0
        case fifteen = 15.0
        case sixteen = 16.0
        case seventeen = 17.0
        case eighteen = 18.0
        case nineteen = 19.0
        case twenty = 20.0
        case twentyOne = 21.0
        case twentyTwo = 22.0
        case twentyThree = 23.0
        case twentyFour = 24.0
        case twentyFive = 25.0
        case twentySix = 26.0
        case twentySeven = 27.0
        case twentyEight = 28.0
        case twentyNine = 29.0
        case thirty = 30.0
    }
}

extension UIFont {
    public struct PMA {
        public static func bold(size: PMAFontSize) -> UIFont {
            return UIFont(name: "SFProText-Bold", size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
        }

        public static func regular(size: PMAFontSize) -> UIFont {
            return UIFont(name: "SFProtext-Regular", size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
        }
        public static func semiBold(size: PMAFontSize) -> UIFont {
            return UIFont(name: "SFProText-Semibold", size: size.rawValue) ?? UIFont.systemFont(ofSize: size.rawValue)
        }
    }
    
   public enum PMAFontSize: CGFloat {
        case ten = 10.0
        case eleven = 11.0
        case twelve = 12.0
        case thirteen = 13.0
        case fourteen = 14.0
        case fifteen = 15.0
        case sixteen = 16.0
        case seventeen = 17.0
        case eighteen = 18.0
        case nineteen = 19.0
        case twenty = 20.0
        case twentyOne = 21.0
        case twentyTwo = 22.0
        case twentyThree = 23.0
        case twentyFour = 24.0
        case twentyFive = 25.0
        case twentySix = 26.0
        case twentySeven = 27.0
        case twentyEight = 28.0
        case twentyNine = 29.0
        case thirty = 30.0
    }
}
