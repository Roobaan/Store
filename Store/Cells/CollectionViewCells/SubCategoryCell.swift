//
//  SubCategoryCell.swift
//  Store
//
//  Created by SCT on 26/05/24.
//

import UIKit

class SubCategoryCell : UICollectionViewCell {
    
    static let identifier = "SubCategoryCell"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
        
     private func setupUI(){
        title.frame = contentView.bounds
        title.textAlignment = .center
//         title.clipsToBounds = true
//         layer.borderColor = UIColor.borderColor.cgColor
         contentView.layer.borderWidth = 1
         contentView.layer.cornerRadius = 16
         title.font = .sfProMedium(size: 15)

        contentView.addSubview(title)
    }
}
