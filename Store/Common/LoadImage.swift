//
//  LoadImage.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import UIKit
 
func loadImage(url: String?, completion: @escaping (UIImage?) -> Void) {
    guard let url = url, let imageUrl = URL(string: url) else {
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
        if let error = error {
            print("Error loading image: \(error)")
            completion(nil)
            return
        }
        
        if let data = data, let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }
    
    task.resume()
}

