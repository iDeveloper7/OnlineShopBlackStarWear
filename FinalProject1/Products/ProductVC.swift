//
//  ProductVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 29.03.2021.
//

import UIKit

protocol CountBadgeProductVCDelegate{
    func countBadgeProductVCDelegate(count: Int)
}

class ProductVC: UIViewController {
    
    var nameProduct = ""
    var productId = 0
    var product = [Product]()
    var countBadge = 0 //значение (число) badge
    var badgeCount = UILabel()
    var countProductVCDelegate: CountBadgeProductVCDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        badgeLabel()
        print(productId)
        ProductLoader().loadProducts(url: Urls.urlProducts(id: productId), completion: { (product) in
            self.product = product
            self.collectionView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        badgeCount.text = "\(countBadge)"
    }
    
    private func setupNavBar(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: cartButton))
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.title = nameProduct
    }
    
    //при нажатии на кнопку "назад на предыдущий экран" мы передаем значение через делегат
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            countProductVCDelegate?.countBadgeProductVCDelegate(count: countBadge)
        }
    }

    //MARK: - create badge
    private func badgeLabel(){
        badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        badgeCount.layer.cornerRadius = badgeCount.frame.size.width / 2
        badgeCount.layer.masksToBounds = true
        badgeCount.backgroundColor = .systemRed
        badgeCount.textColor = .white
        badgeCount.textAlignment = .center
        badgeCount.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        for i in Persistence.shared.getItems(){
            countBadge += i.count
        }
        if countBadge == 0{
            badgeCount.isHidden = true
        } else {
            badgeCount.isHidden = false
        }
        badgeCount.text = "\(countBadge)"
        badgeCount.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addSubview(badgeCount)
        NSLayoutConstraint.activate([
            badgeCount.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -7),
            badgeCount.rightAnchor.constraint(equalTo: cartButton.rightAnchor, constant: 7),
            badgeCount.widthAnchor.constraint(equalToConstant: 20),
            badgeCount.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    //переход на экран корзины
    @IBAction func goToCart(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "CartVC") as! CartVC
        vc.countItemDelegate = self
        vc.countItemZeroDelegate = self
        present(vc, animated: true, completion: nil)
    }
}
extension ProductVC: CountItemBadgeInZero, CountItemBadgeDelegate, CountBadgeDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    //MARK: - CountItemBadgeInZero (при покупке товаров в корзине)
    func countItemBadgeInZero(count: Int) {
        self.countBadge = count
        badgeCount.isHidden = true
    }
    
    //MARK: - count badge delegate
    func countBadge(count: Int) {
        self.countBadge = count
        if count == 0{
            badgeCount.isHidden = true
        } else {
            badgeCount.isHidden = false
        }
    }
    //MARK: - CountItemBadgeDelegate (делегат из корзины)
    func countItemBadgeDelegate(count: Int) {
        self.countBadge = count
        if count == 0{
            badgeCount.isHidden = true
        } else {
            badgeCount.isHidden = false
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let widthCell = UIScreen.main.bounds.width / 2 - 20
        return CGSize(width: widthCell, height: widthCell * 1.864)
    }
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product.isEmpty ? 0 : product.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        if let url = URL(string: "\(Urls.url())\(product[indexPath.row].mainImage)"){
            cell.imageView.loadImage(from: url)
        }
        cell.nameLabel.text = product[indexPath.row].name
        cell.priceLabel.text = "\(Int(product[indexPath.row].price)) ₽"
        return cell
    }
    //MARK: - UICollectionViewDelegate
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
            destination.countDelegate = self
        }
    }
}
