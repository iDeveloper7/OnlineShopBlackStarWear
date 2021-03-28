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
        let webSite = "http://blackstarshop.ru/"

        if !subCategoryes[indexPath.row].iconImage.isEmpty,
            let url = URL(string: "\(webSite)\(subCategoryes[indexPath.row].iconImage)"),
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
    }
}
