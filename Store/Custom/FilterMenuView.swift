//
//  FilterMenuView.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import Foundation
import UIKit


class FilterMenuView: UIView {

    var rating: UIView!
    
    var price: UIView!
    
    var isRatingSelectedImage = UIImageView()
    
    var isPriceSelectedImage = UIImageView()
    
    var selectedFilter = FilterBy.rating

    var delegate: SelectionProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
                
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 10

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .tertiary
        let line1 = UIView()
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.backgroundColor = .tertiary
        isRatingSelectedImage.image = UIImage(systemName: "checkmark.circle.fill")
        isPriceSelectedImage.image = UIImage(systemName:"circle")
        rating = createButton(type: .rating, leftImage: UIImage(systemName: "star")!, rightImage: isRatingSelectedImage ,action: #selector(ratingButtonTapped))
        price = createButton(type: .price, leftImage: UIImage(systemName: "dollarsign.circle")!, rightImage: isPriceSelectedImage , action: #selector(priceButtonTapped))
        
        let text = UILabel()
        text.text = "Filter order: From Top to Bottom"
        text.numberOfLines = 2
        text.textAlignment = .center
        text.textColor = .tertiary
        text.font = .sfProMedium(size: 13)
//        text.backgroundColor = .lightGrey
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clipsToBounds = true
        
        addSubview(text)
        addSubview(line)
        addSubview(line1)
        addSubview(rating)
        addSubview(price)
        
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: topAnchor),
            text.centerXAnchor.constraint(equalTo: centerXAnchor),
            text.leadingAnchor.constraint(equalTo: leadingAnchor),
            text.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            line.topAnchor.constraint(equalTo: text.bottomAnchor),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 0.5),

            rating.topAnchor.constraint(equalTo: line.bottomAnchor),
            rating.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            rating.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            line1.topAnchor.constraint(equalTo: rating.bottomAnchor),
            line1.leadingAnchor.constraint(equalTo: line.leadingAnchor),
            line1.trailingAnchor.constraint(equalTo: line.trailingAnchor),
            line1.heightAnchor.constraint(equalTo: line.heightAnchor),
            
            price.topAnchor.constraint(equalTo: line1.bottomAnchor),
            price.leadingAnchor.constraint(equalTo: rating.leadingAnchor),
            price.trailingAnchor.constraint(equalTo: rating.trailingAnchor),
            price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
        
    }
    
    private func createButton(type: FilterBy,leftImage image: UIImage, rightImage: UIImageView,  action: Selector) -> UIView {
        
        let view = UIView()
        let leftImage = UIImageView()
        let text = UILabel()
//        let rightImage = UIImageView()
        
        leftImage.image = image
        rightImage.image = UIImage(systemName: selectedFilter.rawValue == type.rawValue ? "checkmark.circle.fill" : "circle")
        text.text = type.rawValue
        
        text.numberOfLines = 1
        text.textColor = .black
        text.font = .sfProMedium(size: 13)
        
        leftImage.tintColor = .tangelo
        rightImage.tintColor = .tangelo
        leftImage.tag = 0
        rightImage.tag = 1
        
        leftImage.layer.cornerRadius = 10
        leftImage.layer.borderWidth = 1
        leftImage.layer.borderColor = UIColor.borderColor.cgColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        rightImage.translatesAutoresizingMaskIntoConstraints = false

        let tap = UITapGestureRecognizer(target: self, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        view.addSubview(leftImage)
        view.addSubview(text)
        view.addSubview(rightImage)
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        leftImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        leftImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        leftImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        leftImage.widthAnchor.constraint(equalTo: leftImage.heightAnchor).isActive = true
        
        text.leadingAnchor.constraint(equalTo: leftImage.trailingAnchor, constant: 10).isActive = true
        text.centerYAnchor.constraint(equalTo: leftImage.centerYAnchor).isActive = true

        rightImage.leadingAnchor.constraint(equalTo: text.trailingAnchor, constant: 10).isActive = true
        rightImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        rightImage.centerYAnchor.constraint(equalTo: leftImage.centerYAnchor).isActive = true
        rightImage.heightAnchor.constraint(equalTo: leftImage.heightAnchor).isActive = true
        rightImage.widthAnchor.constraint(equalTo: rightImage.heightAnchor).isActive = true
        
        return view
    }
    
    func setupConstraints(){
        

    }
    
    @objc private func ratingButtonTapped() {
        selectedFilter = .rating
        isRatingSelectedImage.image = UIImage(systemName: "checkmark.circle.fill")
        isPriceSelectedImage.image = UIImage(systemName:"circle")
        
        delegate?.onSelection(selectedItem: selectedFilter)
        
    }
    
    @objc private func priceButtonTapped() {
        selectedFilter = .price
        isPriceSelectedImage.image = UIImage(systemName: "checkmark.circle.fill")
        isRatingSelectedImage.image = UIImage(systemName:"circle")
        delegate?.onSelection(selectedItem: selectedFilter)
    }
}
