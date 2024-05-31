//
//  ColorsCell.swift
//  Store
//
//  Created by SCT on 30/05/24.
//

import UIKit

class ColorsCell : UICollectionViewCell {
    
    static let identifier = "ColorsCell"
    
//    let title = UILabel()
    
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
         contentView.layer.cornerRadius = frame.height / 2

    }
}
