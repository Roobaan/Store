//
//  ProductListViewCell.swift
//  Store
//
//  Created by SCT on 27/05/24.
//

import Foundation
import UIKit

class ProductListViewCell : UITableViewCell {
    
    static let identifier = "ProductListViewCell"
    
    let imageProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let stack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3
        stack.contentMode = .left
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .sfProSemibold(size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 5
        stack.contentMode = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let rating: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .sfProSemibold(size: 13)
        label.textColor = .tangelo
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingView: StarRatingStack = {
        let stack = StarRatingStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let reviewCount: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .sfProRegular(size: 13)
        label.textColor = .quaternary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 5
        stack.contentMode = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .sfProSemibold(size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var originalPrice: UILabel = {
        let label = LinkLabel()
        label.textAlignment = .left
        label.font = .sfProMedium(size: 13)
        label.textColor = .tertiary
        return label
    }()
    
    private let lineStrike : UIView = {
        let view = UIView()
        view.backgroundColor = .tertiary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let savedPrice: UILabelPadding = {
        let label = UILabelPadding()
        label.padding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        label.isHidden = true
        label.clipsToBounds = true
        label.numberOfLines = 1
        label.layer.cornerRadius = 10
        label.backgroundColor = .capsicum
        label.font = .sfProMedium(size: 13)
        label.textColor = .white
        return label
    }()
    
    let descriptionProduct: LinkLabel = {
        let label = LinkLabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .sfProMedium(size: 13)
        label.textColor = .tertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colors : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var colorsAvailable: [String] = [] {
        didSet {
            if colorsAvailable != [] {
                stack.addArrangedSubview(colors)
                colors.reloadData()
            } else {
                colors.removeFromSuperview()
            }
            setupConstraints()
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
//        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupUI(){

        contentView.addSubview(title)

        contentView.addSubview(imageProduct)
        contentView.addSubview(stack)
        
        colors.register(ColorsCell.self, forCellWithReuseIdentifier: ColorsCell.identifier)
        colors.delegate = self
        colors.dataSource = self
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(ratingStack)
        stack.addArrangedSubview(priceStack)
        stack.addArrangedSubview(descriptionProduct)
        
        ratingStack.addArrangedSubview(rating)
        ratingStack.addArrangedSubview(ratingView)
        ratingStack.addArrangedSubview(reviewCount)
        
        originalPrice.addSubview(lineStrike)
        
        priceStack.addArrangedSubview(price)
        priceStack.addArrangedSubview(originalPrice)
        priceStack.addArrangedSubview(savedPrice)
//        contentView.addSubview(rating)
//        contentView.addSubview(ratingView)
//        contentView.addSubview(reviewCount)
        
    }
    
    private func setupConstraints() {
        imageProduct.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageProduct.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageProduct.heightAnchor.constraint(equalToConstant: 90).isActive = true
        imageProduct.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20).isActive = true
        imageProduct.addConstraint(
            NSLayoutConstraint(
                item: imageProduct,
                attribute: .height,
                relatedBy: .equal,
                toItem: imageProduct,
                attribute: .width,
                multiplier: 1,
                constant: 0
            )
        )
        
        stack.leadingAnchor.constraint(equalTo: imageProduct.trailingAnchor, constant: 10).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: imageProduct.topAnchor).isActive = true
        stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20).isActive = true
        
        lineStrike.leadingAnchor.constraint(equalTo: originalPrice.leadingAnchor).isActive = true
        lineStrike.trailingAnchor.constraint(equalTo: originalPrice.trailingAnchor).isActive = true
        lineStrike.centerYAnchor.constraint(equalTo: originalPrice.centerYAnchor).isActive = true
        lineStrike.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        colors.heightAnchor.constraint(equalToConstant: 24).isActive = colorsAvailable != []
//        colors.widthAnchor.constraint(equalToConstant: 100).isActive = true
        colors.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = colorsAvailable != []
        colors.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = colorsAvailable != []
        
//        title.topAnchor.constraint(equalTo: imageProduct.topAnchor).isActive = true
//        title.leadingAnchor.constraint(equalTo: imageProduct.trailingAnchor, constant: 5).isActive = true
//        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        
//        rating.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
//        rating.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
//        
//        ratingView.leadingAnchor.constraint(equalTo: rating.trailingAnchor, constant: 5).isActive = true
//        ratingView.heightAnchor.constraint(equalToConstant: 18).isActive = true
//        ratingView.centerYAnchor.constraint(equalTo: rating.centerYAnchor).isActive = true
//
//        reviewCount.leadingAnchor.constraint(equalTo: ratingView.trailingAnchor,constant: 5).isActive = true
//        reviewCount.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor).isActive = true
    }

    private func getColor(_ color: String) -> UIColor{
        switch color {
        case "black":
            return .black
        case "white":
            return .white
        case "gray":
            return .gray
        case "silver":
            return .silver
        case "maroon":
            return .maron
        case "purple":
            return .purple
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "blue":
            return .blue
        case "teal":
            return .teal
        default:
            return .white
        }
    }
   
}


extension ProductListViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: colors.frame.height, height: colors.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colorsAvailable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorsCell.identifier, for: indexPath) as! ColorsCell
        let bgColor = getColor(colorsAvailable[indexPath.row])
        cell.contentView.backgroundColor = bgColor
        cell.contentView.layer.borderColor = bgColor == .white ? UIColor.borderColor.cgColor : UIColor.clear.cgColor
        cell.contentView.layer.borderWidth = bgColor == .white ? 1 : 0
        return cell
    }
    
    
}


