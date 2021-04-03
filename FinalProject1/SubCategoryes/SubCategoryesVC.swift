//
//  SubCategoryesVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 21.03.2021.
//

import UIKit

class SubCategoryesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var subCategoryes = [Subcategory]()
    
    var nameCategory = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = nameCategory
    }
}

extension SubCategoryesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        subCategoryes.isEmpty ? 0 : subCategoryes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubCategCell") as! SubCategoryCell

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "ShowProduct", sender: cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProduct",
           let destination = segue.destination as? ProductVC,
           let cell = sender as? SubCategoryCell,
           let indexPath = tableView.indexPath(for: cell){
            destination.productId = subCategoryes[indexPath.row].id
            destination.nameProduct = subCategoryes[indexPath.row].name
        }
    }
}
