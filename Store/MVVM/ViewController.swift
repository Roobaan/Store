//
//  ViewController.swift
//  Store
//
//  Created by SCT on 25/05/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout

enum DiscountType {
    case upto, flat
}

enum LayoutTypeEnum: String {
    case linear = "linear", waterfall = "waterfall", none
}

enum FilterBy: String {
    case search, offers, category, rating = "Rating", price = "Price"
}

protocol SelectionProtocol{
    func onSelection(selectedItem : FilterBy)
    
    func selectedOffer(selectedOffer: Card_offers?)
}
extension SelectionProtocol {
    func selectedOffer(selectedOffer: Card_offers?){}
}


class ViewController: BaseViewController {
    
    private lazy var productWaterfall : UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ProductWaterfallCell.self, forCellWithReuseIdentifier: ProductWaterfallCell.identifier)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let productTableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.allowsSelection = false
        table.bounces = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.register(ProductListViewCell.self, forCellReuseIdentifier: ProductListViewCell.identifier)

        return table
    }()
    
    private let floatingActionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .tangelo
        button.layer.cornerRadius = 25
        button.tintColor = .white
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.setImage(UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
        return button
    }()
    
    let productTableViewHeader = ProductTableViewHeader()
    
    lazy var searchController = UISearchController()
    
    var filterMenuView: FilterMenuView?
    
    private var dimmedBackgroundView: UIView!
    
    var subCategoryCollectionViewHeight : NSLayoutConstraint!
    
    let viewModel = DashboardViewModel()
    
    var offerFilter : [Products]?
    
    var filteredProduct : [Products]?
    
    var categoryFilter : [Products]?
    
    var searchFilter : [Products]?
    
    var selectedOffer: Card_offers?
    
    var searchedText: String = ""
    
    var selectedFilterMenu = FilterBy.rating
    
    var layOutToshow = LayoutTypeEnum.linear
    
    let categoryView = CategoryView()
    
    var favourites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setNavigationBar()
        setupConstraints()
        setupDimmedBackgroundView()
        loadApi()
        
    }
    
    func loadApi() {
        if let dashboardModel = CoreDataHandler.shared.fetchDashboardModel() {
            viewModel.dashboardModel = dashboardModel
            categoryView.category = viewModel.dashboardModel?.category
            productTableViewHeader.cardOffers = viewModel.dashboardModel?.card_offers
            categoryView.selectedCategory = viewModel.dashboardModel?.category?[0]
            getfilteredProduct(filterBy: .category)
            reloadView()
        }
        if viewModel.dashboardModel != nil {
            displayActivityIndicator(onView: self.view)
        }
     
            viewModel.fetchDBData()  { [weak self] error in
                self?.removeActivityIndicator()
                guard error == nil else{
                    print("Error")
                    return
                }
                self?.categoryView.category = self?.viewModel.dashboardModel?.category
                self?.categoryView.selectedCategory = self?.viewModel.dashboardModel?.category?[0]
                self?.productTableViewHeader.cardOffers = self?.viewModel.dashboardModel?.card_offers
                self?.getfilteredProduct(filterBy: .category)
                self?.categoryFilter = self?.viewModel.dashboardModel?.products
                self?.reloadView()
            }
        
        
    }
    
    func setupUI() { 
        categoryView.delegate = self
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryView)
        
        productTableViewHeader.delegate = self
        productTableViewHeader.translatesAutoresizingMaskIntoConstraints = false
        
        productTableView.dataSource = self
        productTableView.delegate = self
        view.addSubview(productTableView)
        
        floatingActionButton.frame = CGRect(x: view.frame.width - 70, y: view.frame.height - 90, width: 50, height: 50)
        floatingActionButton.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        view.addSubview(floatingActionButton)
        
        productWaterfall.delegate = self
        productWaterfall.dataSource = self
        productWaterfall.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productWaterfall)
    }
    
    func setupConstraints() {
        
        categoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true

        productTableView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true
        productTableView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true
        productTableView.topAnchor.constraint(equalTo: categoryView.bottomAnchor).isActive = true
        productTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        productTableViewHeader.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        productWaterfall.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true
        productWaterfall.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true
        productWaterfall.topAnchor.constraint(equalTo: categoryView.bottomAnchor).isActive = true
        productWaterfall.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    // MARK: - Navigation bar UI with search box
    func setNavigationBar() {
        
        // Left bar button in navigation bar
        let customView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width * 0.7, height: 44.0))
        let label  = UILabel(frame: customView.bounds)
        label.text = "Zstore"
        label.font = .sfProBold(size: 30)
        label.textColor = .black
        customView.addSubview(label)
        let leftButton = UIBarButtonItem(customView: customView)
        navigationItem.leftBarButtonItem = leftButton
        
        // Right bar button in navigation bar
        let searchImage = UIImage(systemName: "text.magnifyingglass")
        let rightBarButton = UIBarButtonItem(
            image: searchImage,
            style: .plain,
            target: self,
            action: #selector(showHideSearchBar))
        rightBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
        
        
        // Search bar UI setup
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.leftView = UIImageView(image: searchImage)
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        searchController.searchBar.searchTextField.rightView?.tintColor = .gray
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.borderColor.cgColor
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.cornerRadius = 20
        //        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        
        searchController.searchBar.delegate = self
        
        navigationController?.navigationBar.tintColor = .tangelo
    }
    
    // MARK: - Filter actions
    func getfilteredProduct(filterBy: FilterBy) {
        
        switch filterBy {
        case .offers:
            if selectedOffer == nil {
                offerFilter = nil
                filteredProduct = (categoryFilter ?? viewModel.dashboardModel?.products)
            } else {
                offerFilter = viewModel.dashboardModel?.products?.filter{
                    $0.card_offer_ids?.contains(selectedOffer?.id ?? "") ?? false
                }
                if categoryView.selectedCategory == nil {
                    
                    filteredProduct = offerFilter
                }else {
                    filteredProduct = categoryFilter?.filter{
                        $0.card_offer_ids?.contains(selectedOffer?.id ?? "") ?? false
                    }
                }
            }
            
        case .search:
            if searchedText == "" {
                searchFilter = nil
                categoryView.searchCount = nil
            }else{
                searchFilter = (filteredProduct ?? categoryFilter ?? viewModel.dashboardModel?.products)?.filter{
                    $0.name?.lowercased().contains(searchedText.lowercased()) ?? false
                }
                categoryView.searchCount = "\(searchFilter?.count ?? 0)"
            }
            
        case .category:
            if categoryView.selectedCategory == nil {
                layOutToshow = .none
                categoryFilter = nil
                filteredProduct = (offerFilter ?? viewModel.dashboardModel?.products)
            } else {
                layOutToshow = categoryView.selectedCategory?.layout == LayoutTypeEnum.linear.rawValue ? .linear : .waterfall
                
                if layOutToshow == .waterfall {
                    productTableViewHeader.selectedOffer = nil
                    offerFilter = nil
                }
                
                categoryFilter = viewModel.dashboardModel?.products?.filter{
                    $0.category_id == categoryView.selectedCategory?.id
                }
                if offerFilter == nil {
                    
                    filteredProduct = categoryFilter
                }else {
                    filteredProduct = categoryFilter?.filter{
                        $0.card_offer_ids?.contains(selectedOffer?.id ?? "") ?? false
                    }
                }
                
            }
            if searchedText != ""{
                searchFilter = (filteredProduct ?? viewModel.dashboardModel?.products)?.filter{
                    $0.name?.lowercased().contains(searchedText.lowercased()) ?? false
                }
                categoryView.searchCount = "\(searchFilter?.count ?? 0)"
            }
        case .rating:
            selectedFilterMenu = .rating
//            dismissFilterMenu()
            return
        case .price:
            selectedFilterMenu = .price
//            dismissFilterMenu()
            return
        }
        
        reloadView()
    }
    
    private func reloadView(){
        DispatchQueue.main.async { [weak self] in
            if self?.layOutToshow == .waterfall {
                self?.productWaterfall.isHidden = false
                self?.productWaterfall.reloadData()
            }else {
                self?.productWaterfall.isHidden = true
                self?.productTableView.reloadData()
            }
            
        }
    }
    
    private func setupDimmedBackgroundView() {
            dimmedBackgroundView = UIView(frame: view.bounds)
        dimmedBackgroundView.backgroundColor = .modal.withAlphaComponent(0.6)
            dimmedBackgroundView.alpha = 0
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFilterMenu))
            dimmedBackgroundView.addGestureRecognizer(tapGesture)
        }

        private func showFilterMenu() {
            if filterMenuView == nil {
                filterMenuView = FilterMenuView(frame: CGRect(x: floatingActionButton.frame.maxX - (view.frame.width * 0.6) , y: (floatingActionButton.frame.minY - 130) / 1.2, width: view.frame.width * 0.6, height: 130))
                filterMenuView?.delegate = self
                filterMenuView?.selectedFilter = selectedFilterMenu
                view.addSubview(filterMenuView!)
            }
            
            view.addSubview(dimmedBackgroundView)
            view.bringSubviewToFront(filterMenuView!)

            UIView.animate(withDuration: 0.3) {
                self.dimmedBackgroundView.alpha = 1
                self.filterMenuView?.frame.origin.y = self.floatingActionButton.frame.minY - 140
            }
        }
        
    @objc private func floatingButtonTapped() {
        showFilterMenu()
    }
        @objc private func dismissFilterMenu() {
            self.productTableView.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self.dimmedBackgroundView.alpha = 0
                self.filterMenuView?.frame.origin.y = self.view.frame.height
            }, completion: { _ in
                self.dimmedBackgroundView.removeFromSuperview()
                self.filterMenuView?.removeFromSuperview()
                self.filterMenuView = nil
            })
        }
    
    
    @objc func showHideSearchBar(_ sender: UIBarButtonItem) {
        
        searchController.isActive = true
        navigationItem.searchController = searchController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.searchController.searchBar.becomeFirstResponder()
            self?.productTableView.reloadData()
        }
    }
    
    @objc func clearAppliedOffer(_ sender: UITapGestureRecognizer) {
        selectedOffer = nil
        getfilteredProduct(filterBy: .offers)
    }
    
    private func calculateHeightForItem(at indexPath: IndexPath, width: CGFloat) -> CGFloat {
        // Create a dummy cell
        let dummyCell = ProductWaterfallCell(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        let product = searchFilter ?? filteredProduct ?? viewModel.dashboardModel?.products
        
        dummyCell.title.text = product?[indexPath.row].name
        
        
        if let rating = product?[indexPath.row].rating, let ratingCount =  product?[indexPath.row].review_count{
            dummyCell.rating.text = String(rating)
            dummyCell.reviewCount.text = "(\(String(ratingCount)))"
        }
        dummyCell.descriptionProduct.attributedText =  createAttributedString(from: product?[indexPath.row].description ?? "")
        
        let maxDiscount = getMaxDiscount(selectedOffer?.max_discount ?? "")
        if let price = product?[indexPath.row].price,
           let cardOffers = product?[indexPath.row].card_offer_ids,
           let percentage = selectedOffer?.percentage,
           let _ = maxDiscount.type,
           let discountAmount = Double(maxDiscount.amount ?? "")
        {
            
                    let savingPrice = (percentage / 100.0 ) * price
            dummyCell.price.text = "₹\(formatDouble(price - (savingPrice < discountAmount ? savingPrice : discountAmount)))"
            dummyCell.originalPrice.text = "₹\(formatDouble(price))"
            dummyCell.savedPrice.text = "Save ₹\(formatDouble(savingPrice < discountAmount ? savingPrice : discountAmount))"
            dummyCell.savedPrice.isHidden = false
            
        } else {
            dummyCell.price.text = "₹\(formatDouble(product?[indexPath.row].price ?? 0))"
            dummyCell.originalPrice.text = ""
            dummyCell.savedPrice.text = ""
        }
        
        dummyCell.setNeedsLayout()
        dummyCell.layoutIfNeeded()
        
        // Calculate the height
        let size = dummyCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size.height
    }
    
    
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchText
        getfilteredProduct(filterBy: .search)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    
        searchedText = ""
        getfilteredProduct(filterBy: .search)
        searchController.isActive = false

        navigationItem.searchController = nil
        categoryView.searchCount = nil
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = (collectionView.bounds.width - 30) / 2 // Adjust for 2 columns and spacing
            return CGSize(width: width, height: calculateHeightForItem(at: indexPath, width: width))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return searchFilter?.count ?? filteredProduct?.count ?? viewModel.dashboardModel?.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductWaterfallCell.identifier, for: indexPath) as! ProductWaterfallCell
            let product = searchFilter ?? filteredProduct ?? viewModel.dashboardModel?.products
        cell.delegate = self
        cell.id = product?[indexPath.row].id
        cell.isFavourite = favourites.contains(product?[indexPath.row].id ?? "")
            cell.title.text = product?[indexPath.row].name
            loadImage(url: product?[indexPath.row].image_url) { image  in
                guard let image = image else {return}
                DispatchQueue.main.async {
                    cell.imageProduct.image = image
                }
            }
            
            if let rating = product?[indexPath.row].rating, let ratingCount =  product?[indexPath.row].review_count{
                cell.rating.text = String(rating)
                cell.reviewCount.text = "(\(String(ratingCount)))"
            }
            //            cell.ratingView.rating = product?[indexPath.row].rating ?? 0.0
            cell.descriptionProduct.attributedText =  createAttributedString(from: product?[indexPath.row].description ?? "")
            
            let maxDiscount = getMaxDiscount(selectedOffer?.max_discount ?? "")
            if let price = product?[indexPath.row].price,
               let cardOffers = product?[indexPath.row].card_offer_ids,
               let percentage = selectedOffer?.percentage,
               let _ = maxDiscount.type,
               let discountAmount = Double(maxDiscount.amount ?? "")
            {
                
                
                //            if type == .upto {
                let savingPrice = (percentage / 100.0 ) * price
                cell.price.text = "₹\(formatDouble(price - (savingPrice < discountAmount ? savingPrice : discountAmount)))"
                cell.originalPrice.text = "₹\(formatDouble(price))"
                cell.savedPrice.text = "Save ₹\(formatDouble(savingPrice < discountAmount ? savingPrice : discountAmount))"
                cell.savedPrice.isHidden = false
               
            } else {
                cell.price.text = "₹\(formatDouble(product?[indexPath.row].price ?? 0))"
                cell.originalPrice.text = ""
                cell.savedPrice.text = ""
            }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("favourite")
    }
        
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return !searchController.searchBar.isFirstResponder ? productTableViewHeader : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let product = searchFilter?.count ?? filteredProduct?.count ?? viewModel.dashboardModel?.products?.count ?? 0
//        print(product)
        return product
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListViewCell.identifier, for: indexPath)  as! ProductListViewCell
        let product = (searchFilter ?? filteredProduct ?? viewModel.dashboardModel?.products)?
            .sorted(by:
                    (selectedFilterMenu == .rating
                    ? { $0.rating ?? 0.0 < $1.rating ?? 0.0 }
                         : { $0.price ?? 0.0 > $1.price ?? 0.0 }))
        
        cell.title.text = product?[indexPath.row].name
        loadImage(url: product?[indexPath.row].image_url) { image  in
            guard let image = image else {return}
            DispatchQueue.main.async {
                cell.imageProduct.image = image
            }
        }
        
        cell.colorsAvailable = product?[indexPath.row].colorsAvailable ?? []
        if let rating = product?[indexPath.row].rating, let ratingCount =  product?[indexPath.row].review_count{
            cell.rating.text = String(rating)
            cell.reviewCount.text = "(\(String(ratingCount)))"
        }
        cell.ratingView.rating = product?[indexPath.row].rating ?? 0.0
        cell.descriptionProduct.attributedText =  createAttributedString(from: product?[indexPath.row].description ?? "")
        
        let maxDiscount = getMaxDiscount(selectedOffer?.max_discount ?? "")
        if let price = product?[indexPath.row].price,
           let cardOffers = product?[indexPath.row].card_offer_ids,
           let percentage = selectedOffer?.percentage,
           let _ = maxDiscount.type,
           let discountAmount = Double(maxDiscount.amount ?? "")
        {
            
            let savingPrice = (percentage / 100.0 ) * price
            cell.price.text = "₹\(formatDouble(price - (savingPrice < discountAmount ? savingPrice : discountAmount)))"
            cell.originalPrice.text = "₹\(formatDouble(price))"
            cell.savedPrice.text = "Save ₹\(formatDouble(savingPrice < discountAmount ? savingPrice : discountAmount))"
            cell.savedPrice.isHidden = false
        } else {
            cell.price.text = "₹\(formatDouble(product?[indexPath.row].price ?? 0))"
            cell.originalPrice.text = ""
            cell.savedPrice.text = ""
        }
        return cell
    }
    
    func getMaxDiscount(_ text: String) -> (amount: String?,type: DiscountType?){
        
        // Define the regular expression pattern to match an amount prefixed by ₹
        let pattern = "₹([0-9,]+)"
        
        // Create the regular expression object
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // Search for the pattern in the input string
        if let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            // Extract the matched range
            if let range = Range(match.range(at: 1), in: text) {
                let amountString = text[range]
                //                print("Extracted amount: \(amountString)")
                return ("\(amountString)", text.components(separatedBy: " ").first == "Flat" ? DiscountType.flat : DiscountType.upto)
            }
        } else {
            //            print("No amount found")
        }
        
        return (nil, nil)
    }
    
}

extension ViewController: SelectionProtocol {
    func onSelection(selectedItem: FilterBy) {
        getfilteredProduct(filterBy: selectedItem)
    }
    func selectedOffer(selectedOffer: Card_offers?) {
        self.selectedOffer = selectedOffer
    }
}

extension ViewController: CollectionCellActionProtocol {
    func didTaponFavButton(id: String?) {
        reloadView()
        if let index = favourites.firstIndex(of: id ?? "") {
            favourites.remove(at: index)
        } else {
            favourites.append(id ?? "")
        }
    }
}
