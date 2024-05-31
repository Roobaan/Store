//
//  LinkLabel.swift
//  Store
//
//  Created by SCT on 30/05/24.
//

import UIKit

class LinkLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapOnLabel(_ sender: UITapGestureRecognizer) {
        guard let attributedText = self.attributedText else { return }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: bounds.size)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = sender.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (bounds.width - textBoundingBox.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (bounds.height - textBoundingBox.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                            in: textContainer,
                                                            fractionOfDistanceBetweenInsertionPoints: nil)
        
        if indexOfCharacter < attributedText.length {
            if let url = attributedText.attribute(.link, at: indexOfCharacter, effectiveRange: nil) as? String {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}
