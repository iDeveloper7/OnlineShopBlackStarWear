//
//  ProductCardVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 03.04.2021.
//

import UIKit

class ProductCardVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataProduct: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        scrollPictureView.contentSize = CGSize(width: view.frame.size.width * 2, height: imageView.frame.size.height)
    }
    
    func createBackButton(){
        let backButton = UIButton(type: .roundedRect)
        backButton.frame = CGRect(x: 10, y: 30, width: 20, height: 20)
        backButton.setBackgroundImage(UIImage(named: "backImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backActionButton), for: .touchUpInside)
        view.addSubview(backButton)
    }
    @objc func backActionButton(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}

extension ProductCardVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProduct.productImages.isEmpty ? 0 : dataProduct.productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCardCell", for: indexPath) as! ProductCardCell
        
        if let url = URL(string: "\(Urls.url())\(dataProduct.productImages[indexPath.row].imageURL)"),
           let data = try? Data(contentsOf: url){
            cell.productCardImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
