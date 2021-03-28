//
//  CatalogVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 18.03.2021.
//

import UIKit

class CategoryVC: UIViewController {
    var categories = [Category]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
            CategoriesLoader().loadCategories { (categories) in
                self.categories = categories
                self.tableView.reloadData()
            }
    }
}

extension CategoryVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.isEmpty ? 0 : categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CategoryCell
        let webSite = "http://blackstarshop.ru/"
        
        if !self.categories[indexPath.row].image.isEmpty,
            let url = URL(string: "\(webSite)\(self.categories[indexPath.row].image)"),
            let data = try? Data(contentsOf: url){
            cell.imageMain.image = UIImage(data: data)
        } else if self.categories[indexPath.row].image.isEmpty{
            cell.imageMain.image = UIImage(named: "EmptyImage")
        }
        cell.nameLabel.text = "\(categories[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "ShowSubCategory", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSubCategory",
           let destination = segue.destination as? SubCategoryesVC,
           let cell = sender as? CategoryCell,
           let indexPath = tableView.indexPath(for: cell){
            destination.subCategoryes = categories[indexPath.row].subcategories.sorted(by: {$0.sortOrder < $1.sortOrder})
            destination.nameCategory = categories[indexPath.row].name
        }
    }
}
