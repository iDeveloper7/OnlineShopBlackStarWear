//
//  CartVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 24.04.2021.
//

import UIKit
import RealmSwift

class CartVC: UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var arrayItem = Persistence.shared.getItems()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalPrice()
    }
    @IBAction func actionCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    //считаем сумму корзины
    private func totalPrice(){
        var sum = 0
        for i in arrayItem{
            let price = i.price
            sum += price
        }
        totalPriceLabel.text = "\(sum) руб."
    }
    //кнопка "Оформить заказ"
    @IBAction func placeAnOrderButton(_ sender: UIButton) {
        let ac = UIAlertController(title: "Спасибо!", message: "Ваш заказ успешно оформлен", preferredStyle: .alert)
        let action = UIAlertAction(title: "Вернуться на главный экран", style: .default) { (action) in
            guard let sb = self.storyboard?.instantiateViewController(identifier: "CategoryVC") else { return }
            self.navigationController?.pushViewController(sb, animated: true)
            Persistence.shared.removeAll()
        }
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
}

extension CartVC: UITableViewDataSource, UITableViewDelegate{
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItem.isEmpty ? 0 : arrayItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        let url = URL(string: arrayItem[indexPath.row].image) 
        if url != nil{
            cell.imageMain.loadImage(from: url!)
        }
        cell.nameLabel.text = arrayItem[indexPath.row].name
        cell.sizeLabel.text = "Размер: \(arrayItem[indexPath.row].size)"
        cell.colorLabel.text = "Цвет: \(arrayItem[indexPath.row].color)"
        cell.priceLabel.text = "\(arrayItem[indexPath.row].price) ₽"
        
        return cell
    }
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
