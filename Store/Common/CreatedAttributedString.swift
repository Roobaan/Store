//
//  CreatedAttributedString.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import UIKit

func createAttributedString(from string: String) -> NSAttributedString {
    let finalAttributedString = NSMutableAttributedString(string: string)
    
    // Handle bold text
    let boldPattern = "\\*\\*(.*?)\\*\\*"
    let boldRegex = try! NSRegularExpression(pattern: boldPattern, options: [])
    let boldMatches = boldRegex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    
    for match in boldMatches.reversed() {
        if match.numberOfRanges == 2,
           let range = Range(match.range(at: 1), in: string) {
            let boldRange = NSRange(range, in: string)
            finalAttributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 14), range: boldRange)
            finalAttributedString.mutableString.replaceOccurrences(of: "**", with: "", options: [], range: match.range)
        }
    }
    
    // Handle links
    let linkPattern = "\\[(.*?)\\]\\((.*?)\\)"
    let linkRegex = try! NSRegularExpression(pattern: linkPattern, options: [])
    let linkMatches = linkRegex.matches(in: finalAttributedString.string, options: [], range: NSRange(location: 0, length: finalAttributedString.length))
    
    for match in linkMatches.reversed() {
        if match.numberOfRanges == 3,
           let textRange = Range(match.range(at: 1), in: finalAttributedString.string),
           let urlRange = Range(match.range(at: 2), in: finalAttributedString.string) {
            let linkText = String(finalAttributedString.string[textRange])
            let linkURL = String(finalAttributedString.string[urlRange])
            let linkTextRange = NSRange(textRange, in: finalAttributedString.string)
            finalAttributedString.mutableString.replaceOccurrences(of: "[\(linkText)](\(linkURL))", with: linkText, options: [], range: match.range)
            finalAttributedString.addAttribute(.link, value: linkURL, range: NSRange(location: linkTextRange.location - 1, length: linkTextRange.length))
        }
    }
    
    return finalAttributedString
}

