//
//  ProductCardVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 03.04.2021.
//

import UIKit
import BadgeSwift

protocol CountBadgeDelegate {
    func countBadge(count: Int)
}

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
    let backButton = UIButton(type: .roundedRect) //кнопка "вернуться назад"
    let cartButton = UIButton(type: .roundedRect) //кнопка "перейти в корзину"
    let badge = BadgeSwift()
    var countItemInCart = 0 //кол-во товаров в корзине для badge
    var countDelegate: CountBadgeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        addToCardButtonOutlet.layer.cornerRadius = addToCardButtonOutlet.frame.height / 2.5
        myPageControl.numberOfPages = dataProduct.productImages.count
        tableViewSettings()
        createCartButton()
        createBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        badge.text = "\(countItemInCart)"
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
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200)
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SizeAndColorTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    //MARK: - create back button Создаем кнопку возврата в предыдущее меню
    func createBackButton(){
        backButton.setBackgroundImage(UIImage(named: "backImage"), for: .normal)
        backButton.addTarget(self, action: #selector(backActionButton), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 7),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    @objc func backActionButton(sender: UIButton){
        dismiss(animated: true, completion: nil)
        countDelegate?.countBadge(count: countItemInCart)
    }
    
    //MARK: - create button cart Создаем кнопку "Корзина"
    func createCartButton(){
        cartButton.setBackgroundImage(UIImage(named: "cart"), for: .normal)
        cartButton.addTarget(self, action: #selector(actionCartButton), for: .touchUpInside)
        view.addSubview(cartButton)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -17),
            cartButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 28),
            cartButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    @objc func actionCartButton(){
        performSegue(withIdentifier: "segueCart", sender: nil)
    }
    
    //MARK: - create badge
    func createBadge(){
        //считаем кол-во товаров в корзине
        for i in Persistence.shared.getItems(){
            countItemInCart += i.count
        }
        //configuration badge
        badge.text = "\(countItemInCart)"
        if badge.text == "0"{
            badge.isHidden = true
        } else {
            badge.isHidden = false
        }
        badge.badgeColor = .systemRed
        badge.textColor = .white
        badge.textAlignment = .center
        badge.clipsToBounds = true
        badge.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        view.addSubview(badge)
        //position badge
        constraintsToBadge()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCart", let destination = segue.destination as? CartVC{
            destination.countItemDelegate = self
            destination.countItemZeroDelegate = self
        }
    }
}
extension ProductCardVC: CountItemBadgeInZero, CountItemBadgeDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate{
    //MARK: - CountItemBadgeInZero (при покупке товаров в корзине)
    func countItemBadgeInZero(count: Int) {
        self.countItemInCart = count
        badge.isHidden = true
    }
    
    //MARK: - CountItemBadgeDelegate
    func countItemBadgeDelegate(count: Int) {
        self.countItemInCart = count
        if count == 0{
            badge.isHidden = true
        } else {
            badge.isHidden = false
        }
    }
    
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
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! SizeAndColorTableViewCell
        cell.imageCheck.image = UIImage(named: "check")
        onClickTransparentView() //убираем таблицу c выбором размеров
        
        let item = ProductData()
        item.image = "\(Urls.url())\(dataProduct.mainImage)"
        item.name = dataProduct.name
        item.size = dataProduct.offers[indexPath.row].size
        item.color = dataProduct.colorName
        item.price = Int(dataProduct.price)
        
        //сохраняем данные в реалм
        Persistence.shared.save(item: item)
        
        //меняем цифру товаров в badge при нажатии на ячейкку таблицы с выбором размера и цвета
        countItemInCart += 1
        badge.isHidden = false
        constraintsToBadge()
        badge.text = "\(countItemInCart)"
    }
    
    //констреинты и размеры для badge
    private func constraintsToBadge(){
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.insets = CGSize(width: 1.5, height: 1.5)
        NSLayoutConstraint.activate([
            badge.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -10),
            badge.rightAnchor.constraint(equalTo: cartButton.rightAnchor, constant: 10)
        ])
    }
    
    //MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProduct.productImages.isEmpty ? 0 : dataProduct.productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCardCell", for: indexPath) as! ProductCardCell
        
        if let url = URL(string: "\(Urls.url())\(dataProduct.productImages[indexPath.item].imageURL)"){
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
