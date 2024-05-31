//
//  PaddingLabel.swift
//  Store
//
//  Created by SCT on 27/05/24.
//

import UIKit

class UILabelPadding: UILabel {

    var padding = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

}
