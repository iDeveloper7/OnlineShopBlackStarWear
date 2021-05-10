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
    
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        backButtonOutlet.setTitle("", for: .normal)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        backButtonOutlet.isHidden = true
        backButtonOutlet.isEnabled = false
        subCategoryes.removeAll()
        tableIndex = 0
        tableView.reloadData()
    }
}

extension CategoryVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !subCategoryes.isEmpty{
            return subCategoryes.count
        } else {
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoryCell
        
        if tableIndex == 0{
            navigationItem.title = "Каталог"
            if !self.categories[indexPath.row].image.isEmpty,
               let url = URL(string: "\(Urls.url())\(self.categories[indexPath.row].image)"),
               let data = try? Data(contentsOf: url){
                cell.imageMain.image = UIImage(data: data)
            } else if self.categories[indexPath.row].image.isEmpty{
                cell.imageMain.image = UIImage(named: "EmptyImage")
            }
            cell.nameLabel.text = "\(categories[indexPath.row].name)"
            return cell
        } else{
            if !subCategoryes[indexPath.row].iconImage.isEmpty,
               let url = URL(string: "\(Urls.url())\(subCategoryes[indexPath.row].iconImage)"),
                let data = try? Data(contentsOf: url){
                cell.imageMain.image = UIImage(data: data)
            } else if subCategoryes[indexPath.row].iconImage.isEmpty{
                cell.imageMain.image = UIImage(named: "EmptyImage")
            }
            cell.nameLabel.text = subCategoryes[indexPath.row].name
            return cell
        }
    }
    
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
            vc.productId = Int(categoriesId[indexPath.row])!
            vc.nameProduct = categories[indexPath.row].name
            navigationController?.pushViewController(vc, animated: true)
            print("переход на продукты без подкатегорий")
        } else{
            let vc = storyboard?.instantiateViewController(identifier: "ProductVC") as! ProductVC
            vc.nameProduct = subCategoryes[indexPath.row].name
            vc.productId = subCategoryes[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
            print("переход на продукты")
        }
    }
}
