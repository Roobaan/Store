//
//  OffersCell.swift
//  Store
//
//  Created by SCT on 26/05/24.
//

import UIKit

class OffersCell : UICollectionViewCell {
    
    static let identifier = "OfferCell"
    
    let innerView = UIView()
    
    let title = UILabel()
    
    let offerDescription = UILabel()
    
    let discount = UILabel()
    
    let imageOffer = UIImageView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
     private func setupUI(){
         
         innerView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width - 10, height: contentView.frame.height)
         innerView.layer.cornerRadius = 20
//         innerView.backgroundColor = gradientColor(innerView.bounds)
         
         contentView.addSubview(innerView)
         
         title.numberOfLines = 1
         title.font = .sfProMedium(size: 16)
         title.textColor = .white
         title.translatesAutoresizingMaskIntoConstraints = false
         innerView.addSubview(title)
         
         offerDescription.numberOfLines = 2
         offerDescription.font = .sfProRegular(size: 15)
         offerDescription.textColor = .white
         offerDescription.translatesAutoresizingMaskIntoConstraints = false
          innerView.addSubview(offerDescription)
         
         discount.numberOfLines = 1
         discount.font = .sfProSemibold(size: 20)
         discount.textColor = .white
         discount.translatesAutoresizingMaskIntoConstraints = false
          innerView.addSubview(discount)
         
         imageOffer.backgroundColor = .green
         imageOffer.contentMode = .scaleToFill
         imageOffer.clipsToBounds = true
         imageOffer.layer.cornerRadius = 15
         imageOffer.translatesAutoresizingMaskIntoConstraints = false
         innerView.addSubview(imageOffer)
         
         title.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 10).isActive = true
         title.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10).isActive = true
         title.trailingAnchor.constraint(equalTo: imageOffer.leadingAnchor, constant: -10).isActive = true
         
         offerDescription.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
         offerDescription.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
         offerDescription.trailingAnchor.constraint(equalTo: title.trailingAnchor).isActive = true
         offerDescription.bottomAnchor.constraint(greaterThanOrEqualTo: offerDescription.bottomAnchor, constant: 10).isActive = true

         
         discount.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
         discount.trailingAnchor.constraint(equalTo: innerView.trailingAnchor).isActive = true
         discount.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -15).isActive = true
         
         imageOffer.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 10).isActive = true
         imageOffer.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -20).isActive = true
         imageOffer.addConstraint(NSLayoutConstraint(item: imageOffer,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: imageOffer,
                                                     attribute: .width,
                                                     multiplier: 1,
                                                     constant: 0))
         imageOffer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
}
