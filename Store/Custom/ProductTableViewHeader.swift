//
//  ProductTableViewHeader.swift
//  Store
//
//  Created by SCT on 31/05/24.
//

import UIKit

class ProductTableViewHeader: UIView {
    
    private let offers : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OffersCell.self, forCellWithReuseIdentifier: OffersCell.identifier)
        return collectionView
    }()
    
    private let offerStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        stack.spacing = 15
        stack.contentMode = .left
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let appliedOfferButton : UIButton = {
        var button = UIButton()
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "xmark")
//            config.title = " "
            config.imagePadding = 10
            config.imagePlacement = .trailing
            button.configuration = config
        } else {
            button = UIButton(type: .system)
            button.setImage(UIImage(systemName: "xmark"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            button.contentHorizontalAlignment = .trailing
        }
        button.layer.borderColor = UIColor.appliedOfferColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.tintColor = .appliedOfferColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let offersTitle : UIButton = {
        let button = UIButton()
        //        button.titleLabel?.textColor = .tangelo
        button.titleLabel?.font = .sfProSemibold(size: 18)
        button.tintColor = .tangelo
        button.setTitleColor(.tangelo, for: .normal)
        button.setTitle(" Offers", for: .normal)
        button.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var cardOffers: [Card_offers]? = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.offers.reloadData()
            }
           
        }
    }
    
    var selectedOffer: Card_offers? = nil {
        didSet {
            if selectedOffer == nil {
                DispatchQueue.main.async { [weak self] in
                    self?.appliedOfferButton.removeFromSuperview()
                }
               
            }
            
            delegate?.selectedOffer(selectedOffer: selectedOffer)
            delegate?.onSelection(selectedItem: .offers)
        }
    }
    
    var delegate: SelectionProtocol?
    
    init(cardOffer: [Card_offers]? = nil) {
        super.init(frame: .zero)
        self.cardOffers = cardOffer
        setupUI()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        
//        axis = .vertical
//        distribution = .fill
//        alignment = .leading
//        spacing = 15
//        contentMode = .left
//        translatesAutoresizingMaskIntoConstraints = false
//
        backgroundColor = .white
        
        offers.delegate = self
        offers.dataSource = self
        
        appliedOfferButton.addTarget(self, action: #selector(clearAppliedOffer), for: .touchUpInside)
        
            offerStack.addArrangedSubview(offersTitle)
        offerStack.addArrangedSubview(offers)
        
        addSubview(offerStack)
    }
    
    private func setupConstraints() {
        
        offerStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        offerStack.bottomAnchor.constraint(equalTo: bottomAnchor ,constant: -20).isActive = true
        offerStack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        offerStack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        offers.heightAnchor.constraint(equalToConstant: 120).isActive = true
        offers.widthAnchor.constraint(equalTo: offerStack.widthAnchor).isActive = true
    }
    
    @objc func clearAppliedOffer(_ sender: UITapGestureRecognizer) {
        
        appliedOfferButton.removeFromSuperview()
        selectedOffer = nil
        
    }
    
}

extension ProductTableViewHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            
        return  CGSize(width: frame.width * 0.85 > 380 ? 380 : frame.width * 0.85, height: offers.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return cardOffers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OffersCell.identifier, for: indexPath) as! OffersCell
            cell.title.text = cardOffers?[indexPath.row].card_name
            cell.offerDescription.text = cardOffers?[indexPath.row].offer_desc
            cell.discount.text = cardOffers?[indexPath.row].max_discount
        cell.innerView.backgroundColor = gradientColor(cell.innerView.bounds, color: gradientColors[indexPath.row])
            loadImage(url: cardOffers?[indexPath.row].image_url, completion: { image in
                guard let image = image else {return}
                DispatchQueue.main.async {
                    cell.imageOffer.image = image
                }
                
            })
            return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        offerStack.addArrangedSubview(appliedOfferButton)
            selectedOffer = cardOffers?[indexPath.row]
        
            let str  = "Applied: " + (cardOffers?[indexPath.row].card_name ?? "")
            
            let attributedText = NSMutableAttributedString(string: str)
            let range = (str as NSString).range(of: " ")
            attributedText.addAttribute(.font, value: UIFont.sfProBold(size: 16), range: NSRange(location: range.location, length: str.count - range.location))
            attributedText.addAttribute(.foregroundColor, value: UIColor.secondaryColor, range: NSRange(location: 0, length: range.location))
            appliedOfferButton.setAttributedTitle(attributedText, for: .normal)
        }
}
