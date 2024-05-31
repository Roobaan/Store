//
//  UIFont + Extension.swift
//  Store
//
//  Created by SCT on 26/05/24.
//

import UIKit

extension UIFont {
    
    static func sfProRegular(size : CGFloat) ->UIFont {

        guard let font = UIFont(name: "SFProText-Regular", size: size - MetaDataConstants.fontSizeDiff) else{
                return UIFont()
            }
            return font
        }
    
    static func sfProSemibold(size : CGFloat) ->UIFont {
        guard let font = UIFont(name: "SFProText-Semibold", size: size - MetaDataConstants.fontSizeDiff) else{
                return UIFont()
            }
            return font
        }
    
    static func sfProBold(size : CGFloat) ->UIFont {
        guard let font = UIFont(name: "SFProText-Bold", size: size - MetaDataConstants.fontSizeDiff) else{
                return UIFont()
            }
            return font
        }
    
    static func sfProMedium(size : CGFloat) ->UIFont {
        guard let font = UIFont(name: "SFProText-Medium", size: size - MetaDataConstants.fontSizeDiff) else{
                return UIFont()
            }
            return font
        }
}
