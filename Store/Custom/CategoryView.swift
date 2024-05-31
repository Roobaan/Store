import UIKit


class CategoryView: UIView {

    private let subCategory: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    var category: [Category]? = [] {
        didSet {
            updateCollectionViewHeight()
        }
    }
    
    var selectedCategory: Category?

    var delegate: SelectionProtocol?
    
    var searchCount: String?  {
        didSet {
        searchCount = searchCount != nil ? " (\( searchCount ?? ""))" : ""
            subCategory.reloadData()
        }
    }

    private var subCategoryHeightConstraint: NSLayoutConstraint?

    init(category: [Category]? = nil) {
        super.init(frame: .zero)
        self.category = category
        setupUI()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        subCategory.register(SubCategoryCell.self, forCellWithReuseIdentifier: SubCategoryCell.identifier)
        subCategory.delegate = self
        subCategory.dataSource = self
                
        addSubview(subCategory)
    }

    private func setupConstraints() {
        subCategoryHeightConstraint = subCategory.heightAnchor.constraint(equalToConstant: 0)
        subCategoryHeightConstraint?.isActive = true
        subCategory.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        subCategory.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subCategory.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subCategory.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subCategory.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
    }

    private func updateCollectionViewHeight() {
        DispatchQueue.main.async {
            self.subCategory.reloadData()
            self.subCategory.layoutIfNeeded()
            let height = self.subCategory.collectionViewLayout.collectionViewContentSize.height
            self.subCategoryHeightConstraint?.constant = height
//            self.onHeightChange?()

            self.layoutIfNeeded()
        }
    }
}

extension CategoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let labelAdd = UILabel()
            labelAdd.text = (category?[indexPath.row].name ?? "") + ( selectedCategory?.id == category?[indexPath.row].id ? (searchCount ?? "") : "")
            labelAdd.font = UIFont.systemFont(ofSize: 14)
            labelAdd.numberOfLines = 0
            labelAdd.lineBreakMode = .byWordWrapping
            labelAdd.sizeToFit()
            return CGSize(width: labelAdd.frame.size.width + 20, height: labelAdd.frame.size.height + 20)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubCategoryCell.identifier, for: indexPath) as! SubCategoryCell
            guard let title = category?[indexPath.row].name
            else {return UICollectionViewCell()}
            cell.title.text = title +  ( selectedCategory?.id == category?[indexPath.row].id ? ( searchCount ?? "") : "")
//            cell.isSelected = selectedCategory?.id == category?[indexPath.row].id
            cell.contentView.layer.borderColor = selectedCategory?.id == category?[indexPath.row].id ? UIColor.tangelo.cgColor : UIColor.borderColor.cgColor
            cell.title.textColor = selectedCategory?.id == category?[indexPath.row].id ? .tangelo : .secondaryColor
            cell.contentView.backgroundColor = selectedCategory?.id == category?[indexPath.row].id ? .tangeloShade4 : .white
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == subCategory {
        selectedCategory = selectedCategory?.id == category?[indexPath.row].id ? nil : category?[indexPath.row]
        subCategory.reloadData()
        print(selectedCategory?.name)
        delegate?.onSelection(selectedItem: .category)
//        } else {
//            // Handle card offers selection
//        }
    }
}
