//
//  CatalogVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 18.03.2021.
//

import UIKit

class CategoryVC: UIViewController {
    var categories = [Category]()
    var subCategoryes = [Subcategory]()
    var categoriesId = [String]()
    var tableIndex = 0
    var countBadge = 0 //значение (число) badge
    var badgeCount = UILabel()
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cartButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        badgeLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        CategoriesLoader().loadCategories { (categories, categoriesId) in
            self.categories = categories
            self.tableView.reloadData()
            self.categoriesId = categoriesId
        }
        if tableIndex == 0{
            backButtonOutlet.isHidden = true
            backButtonOutlet.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.badgeCount.text = "\(countBadge)"
    }
    
    //settings navigation bar
    private func setupNavBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: cartButton))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .darkGray
    }
    //переход на экран корзины
    @IBAction func goToCart(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "CartVC") as! CartVC
        vc.countItemDelegate = self
        vc.countItemZeroDelegate = self
        present(vc, animated: true, completion: nil)
    }
    
    //вернуться назад
    @IBAction func backButtonAction(_ sender: UIButton) {
        backButtonOutlet.isHidden = true
        backButtonOutlet.isEnabled = false
        subCategoryes.removeAll()
        tableIndex = 0
        tableView.reloadData()
    }
}

extension CategoryVC: CountItemBadgeInZero, CountBadgeProductVCDelegate, CountItemBadgeDelegate, UITableViewDataSource, UITableViewDelegate{
    //MARK: - CountItemBadgeInZero (при покупке товаров в корзине)
    func countItemBadgeInZero(count: Int) {
        self.countBadge = count
        badgeCount.isHidden = true
    }
    
    //MARK: - CountBadgeProductVCDelegate (делегат из productVC)
    func countBadgeProductVCDelegate(count: Int) {
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
        print("count item categoryVC \(count)")
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !subCategoryes.isEmpty ? subCategoryes.count : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        
        if tableIndex == 0{
            navigationItem.title = "Каталог"
            if !self.categories[indexPath.row].image.isEmpty,
               let url = URL(string: "\(Urls.url())\(self.categories[indexPath.row].image)"){
                cell.imageMain.loadImage(from: url)
                cell.nameLabel.text = categories[indexPath.row].name
                return cell
            } else if self.categories[indexPath.row].image.isEmpty{
                cell.imageMain.image = UIImage(named: "EmptyImage")
            }
            cell.nameLabel.text = "\(categories[indexPath.row].name)"
            return cell
        } else{
            if !subCategoryes[indexPath.row].iconImage.isEmpty,
               let url = URL(string: "\(Urls.url())\(subCategoryes[indexPath.row].iconImage)"){
                cell.imageMain.loadImage(from: url)
            } else if subCategoryes[indexPath.row].iconImage.isEmpty{
                cell.imageMain.image = UIImage(named: "EmptyImage")
            }
            cell.nameLabel.text = subCategoryes[indexPath.row].name
            return cell
        }
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableIndex == 0 && !categories[indexPath.row].subcategories.isEmpty{
            tableIndex = 1
            navigationItem.title = "\(categories[indexPath.row].name)"
            subCategoryes = categories[indexPath.row].subcategories
            backButtonOutlet.isHidden = false
            backButtonOutlet.isEnabled = true
            tableView.reloadData()
            print("Переход на подкатегории")
        } else if tableIndex == 0 && categories[indexPath.row].subcategories.isEmpty{
            let vc = storyboard?.instantiateViewController(identifier: "ProductVC") as! ProductVC
            vc.countProductVCDelegate = self
            vc.productId = Int(categoriesId[indexPath.row])!
            vc.nameProduct = categories[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
            print("переход на продукты без подкатегорий")
        } else{
            let vc = storyboard?.instantiateViewController(identifier: "ProductVC") as! ProductVC
            vc.countProductVCDelegate = self
            vc.nameProduct = subCategoryes[indexPath.row].name
            vc.productId = subCategoryes[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
            print("переход на продукты")
        }
    }
    //Для возвращения в данный VC из корзины
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {}
}
