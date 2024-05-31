//
//  FormatDouble.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import Foundation

func formatDouble(_ number: Double) -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let number = Int(number)
    return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
}
