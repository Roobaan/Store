//
//  ProductWaterfallCell.swift
//  Store
//
//  Created by SCT on 30/05/24.
//

import UIKit

protocol CollectionCellActionProtocol {
    func didTaponFavButton(id : String?)
}

class ProductWaterfallCell : UICollectionViewCell {
    
    static let identifier = "ProductWaterfallCell"
    
    let label : UILabel = {
        let label = UILabel()
        return label
    }()
    
    let imageProduct: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        label.numberOfLines = 4
        label.font = .sfProSemibold(size: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 3
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
    
    private let ratingView: StarRatingStack = {
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
    
    lazy var favouriteButton : UIButton = {
        var button = UIButton()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "heart")
            config.imagePadding = 10
            config.imagePlacement = .leading
            button.configuration = config
        } else {
            button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.contentHorizontalAlignment = .leading
        }
        button.tintColor = .secondaryColor
        button.setTitle("Add to fav", for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.borderColor.cgColor
        button.setTitleColor(.secondaryColor, for: .normal)
        return button
    }()
    
    var isFavourite: Bool = false {
        didSet {
            favouriteView.isHidden = !isFavourite
            favImage.isHidden = !isFavourite
            if isFavourite {
                favouriteButton.removeFromSuperview()
            } else {
                stack.addArrangedSubview(favouriteButton)

            }
        }
    }
    
    let favouriteView : FavouriteCustomView = {
        let view = FavouriteCustomView()
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let favImage : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "heart.fill")
        image.tintColor = .white
        return image
    }()
    
    var delegate: CollectionCellActionProtocol?
    
    var id : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.borderColor.cgColor
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(title)
        
        contentView.addSubview(imageProduct)
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(ratingStack)
        stack.addArrangedSubview(priceStack)
        stack.addArrangedSubview(descriptionProduct)
        stack.addArrangedSubview(favouriteButton)
        
        ratingStack.addArrangedSubview(rating)
        ratingStack.addArrangedSubview(ratingView)
        ratingStack.addArrangedSubview(reviewCount)
        
        originalPrice.addSubview(lineStrike)
        
        priceStack.addArrangedSubview(price)
        priceStack.addArrangedSubview(originalPrice)
        priceStack.addArrangedSubview(savedPrice)
        
        addSubview(favouriteView)
        addSubview(favImage)
        
        favouriteButton.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(favouriteAction))
        favouriteView.addGestureRecognizer(tap)
    }
    
    private func setupConstraints() {
       
        NSLayoutConstraint.activate([
            priceStack.heightAnchor.constraint(equalToConstant: 20),
            
            imageProduct.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageProduct.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageProduct.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageProduct.heightAnchor.constraint(equalTo: imageProduct.widthAnchor),
            
            stack.topAnchor.constraint(equalTo: imageProduct.bottomAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            ratingView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            lineStrike.leadingAnchor.constraint(equalTo: originalPrice.leadingAnchor),
            lineStrike.trailingAnchor.constraint(equalTo: originalPrice.trailingAnchor),
            lineStrike.centerYAnchor.constraint(equalTo: originalPrice.centerYAnchor),
            lineStrike.heightAnchor.constraint(equalToConstant: 1),
            favouriteView.topAnchor.constraint(equalTo: topAnchor),
            favouriteView.trailingAnchor.constraint(equalTo: trailingAnchor),
            favouriteView.heightAnchor.constraint(equalToConstant: 50),
            favouriteView.heightAnchor.constraint(equalTo: favouriteView.widthAnchor)
            
        ])
        
        favImage.heightAnchor.constraint(equalTo: favouriteView.heightAnchor, multiplier: 0.6).isActive = true
        favImage.widthAnchor.constraint(equalTo: favImage.heightAnchor).isActive = true
        favImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        favImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        
        
        
    }
    
    @objc private func favouriteAction() {
        isFavourite.toggle()
        delegate?.didTaponFavButton(id: id)
    }
}





