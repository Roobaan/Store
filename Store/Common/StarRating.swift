//
//  StarRating.swift
//  Store
//
//  Created by SCT on 27/05/24.
//

import UIKit

class StarRatingStack: UIStackView {
    
    // MARK: - Properties
    
    var rating: Double = 0.0 {
        didSet {
            updateRating()
        }
    }
    
    var starCount: Int = 5 {
        didSet {
            setupStars()
        }
    }
    
    private var starImageViews = [UIImageView]()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStars()
    }
    
    // MARK: - Private Methods
    
    private func setupStars() {
        // Clear any existing arranged subviews and reset the array
//        spacing = 3
        alignment = .leading
        distribution = .fillEqually
        contentMode = .center
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        starImageViews.removeAll()
        
        // Add star image views
        for _ in 0..<starCount {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(starImageView)
            starImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
            starImageViews.append(starImageView)
        }
        
        updateRating()
    }
    
    private func updateRating() {
        guard rating >= 0 && rating <= Double(starCount) else {
            fatalError("Invalid rating value: \(rating). Rating must be between 0 and \(starCount)")
        }
        
        let fullStarImage = UIImage(systemName: "star.fill")
        let halfStarImage = UIImage(systemName: "star.leadinghalf.fill")
        let emptyStarImage = UIImage(systemName: "star")
        
        for (index, starView) in starImageViews.enumerated() {
            starView.image = fullStarImage
            starView.tintColor = index < Int(rating) ? .tangelo : .quaternary
                }
        
    }
}
