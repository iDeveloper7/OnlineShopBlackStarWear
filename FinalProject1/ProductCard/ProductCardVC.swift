//
//  ProductCardVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 03.04.2021.
//

import UIKit

class ProductCardVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCardButtonOutlet: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var myPageControl: UIPageControl!
        
    var dataProduct: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        addToCardButtonOutlet.layer.cornerRadius = addToCardButtonOutlet.frame.height / 2.5
        myPageControl.numberOfPages = dataProduct.productImages.count
    }
    
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        
    }
    //MARK: - create back button
    func createBackButton(){
        let backButton = UIButton(type: .roundedRect)
        backButton.frame = CGRect(x: 10, y: 40, width: 20, height: 20)
        backButton.setBackgroundImage(UIImage(named: "backImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backActionButton), for: .touchUpInside)
        view.addSubview(backButton)
    }
    @objc func backActionButton(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    //MARK: - create 
}

extension ProductCardVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK: - collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProduct.productImages.isEmpty ? 0 : dataProduct.productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCardCell", for: indexPath) as! ProductCardCell
        
        if let url = URL(string: "\(Urls.url())\(dataProduct.productImages[indexPath.row].imageURL)"),
           let data = try? Data(contentsOf: url){
            cell.productCardImageView.image = UIImage(data: data)
        }
        nameLabel.text = dataProduct.name
        priceLabel.text = "\(Int(dataProduct.price)) ₽"
        descriptionLabel.text = dataProduct.description.replacingOccurrences(of: "&nbsp;", with: " ")
        
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //when the scrolling movement stops, we update the page control
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        myPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
