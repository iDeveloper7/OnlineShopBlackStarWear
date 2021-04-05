//
//  ProductVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 29.03.2021.
//

import UIKit

class ProductVC: UIViewController {
    
    var nameProduct = ""
    var productId = 0
    var product = [Product]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = nameProduct
        ProductLoader().loadProducts(url: Urls.urlProducts(id: productId), completion: { (product) in
            self.product = product
            self.collectionView.reloadData()
        })
    }
}
extension ProductVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let widthCell = UIScreen.main.bounds.width / 2 - 20
        return CGSize(width: widthCell, height: widthCell * 1.864)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product.isEmpty ? 0 : product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        if let url = URL(string: "\(Urls.url())\(product[indexPath.row].mainImage)"),
           let data = try? Data(contentsOf: url){
            cell.imageView.image = UIImage(data: data)
        }
        cell.nameLabel.text = product[indexPath.row].name
        cell.priceLabel.text = "\(Int(product[indexPath.row].price)) ₽"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "ShowProductCard", sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProductCard",
           let destination = segue.destination as? ProductCardVC,
           let item = sender as? ProductCell,
           let indexPath = collectionView.indexPath(for: item){
            destination.dataProduct = product[indexPath.item]
        }
    }
}
