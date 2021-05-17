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
    @IBOutlet weak var transparentView: UIView!
    
    var tableView = UITableView()
    var dataProduct: Product!
    let cartButton = UIButton(type: .roundedRect)
    var numberOfProducts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        addToCardButtonOutlet.layer.cornerRadius = addToCardButtonOutlet.frame.height / 2.5
        myPageControl.numberOfPages = dataProduct.productImages.count
        tableViewSettings()
        createCartButton()
    }
    
    //MARK: - create button add to cart  кнопка "Добавить в корзину"
    @IBAction func addToCartButtonAction(_ sender: UIButton) {
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        //добалвяем всплывающее окно с размерами одежды
        view.addSubview(tableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        }, completion: nil)
    }
    //скрываем всплывающее окно с размерами одежды
    @objc func onClickTransparentView(){
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200)
        }, completion: nil)
    }
    //Настройки table view всплывающего окна с размерами
    func tableViewSettings(){
        tableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200)
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SizeAndColorTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: - create back button Создаем кнопку возврата в предыдущее меню
    func createBackButton(){
        let backButton = UIButton(type: .roundedRect)
        backButton.frame = CGRect(x: 5, y: 30, width: 20, height: 20)
        backButton.setBackgroundImage(UIImage(named: "backImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backActionButton), for: .touchUpInside)
        view.addSubview(backButton)
    }
    @objc func backActionButton(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - create button cart Создаем кнопку "Корзина" (по дефолту)
    func createCartButton(){
        cartButton.frame = CGRect(x: UIScreen.main.bounds.width - 35, y: 28, width: 25, height: 25)
        cartButton.setBackgroundImage(UIImage(named: "shopping-cart"), for: .normal)
        view.addSubview(cartButton)
        cartButton.addTarget(self, action: #selector(actionCartButton), for: .touchUpInside)
    }
    
    @objc func actionCartButton(){
        performSegue(withIdentifier: "CartVC", sender: nil)
    }
}
extension ProductCardVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate{
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataProduct.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SizeAndColorTableViewCell
        cell.colorLabel.text = dataProduct.colorName
        let euSize = dataProduct.offers[indexPath.row].size
        let rusSize = SizeConverter[euSize]
        if let size = rusSize{
            cell.sizeLabel.text = "\(size) RUS \(euSize)"
        } else{
            cell.sizeLabel.text = euSize
        }
        return cell
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SizeAndColorTableViewCell
        cell.imageCheck.image = UIImage(named: "check")
        onClickTransparentView() //убираем таблицу c выбором размеров
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProduct.productImages.isEmpty ? 0 : dataProduct.productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCardCell", for: indexPath) as! ProductCardCell
        
        if let url = URL(string: "\(Urls.url())\(dataProduct.productImages[indexPath.row].imageURL)"){
            cell.productCardImageView.loadImage(from: url)
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
    //когда движение прокрутки картинки останавливается, мы обновляем (перелистываем) pageControl
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        myPageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
