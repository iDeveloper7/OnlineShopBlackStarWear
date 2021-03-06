//
//  CartVC.swift
//  FinalProject1
//
//  Created by Vladimir Karsakov on 24.04.2021.
//

import UIKit

protocol DeleteItem: NSObjectProtocol {
    func deleteItem(indexPath: IndexPath)
}

protocol CountItemBadgeDelegate{
    func countItemBadgeDelegate(count: Int)
}

protocol CountItemBadgeInZero{
    func countItemBadgeInZero(count: Int)
}

class CartVC: UIViewController {
    
    @IBOutlet weak var placeAnOrderButtonOutlet: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cartLabel: UILabel!
    
    var arrayItem = Persistence.shared.getItems()
    var delegate: DeleteItem?
    var indexPath: IndexPath?
    var countItemDelegate: CountItemBadgeDelegate?
    var countItemZeroDelegate: CountItemBadgeInZero?
    let backButton = UIButton(type: .roundedRect)
    
    //MARK: - create back button
    func createBackButton(){
        backButton.setBackgroundImage(UIImage(named: "cancel"), for: .normal)
        backButton.addTarget(self, action: #selector(actionCancelButton), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 11),
            backButton.centerYAnchor.constraint(equalTo: cartLabel.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc func actionCancelButton(){
        func countBadge() -> Int{
           var count = 0
           for i in Persistence.shared.getItems(){
               count += i.count
           }
           return count
       }
        countItemDelegate?.countItemBadgeDelegate(count: countBadge())
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackButton()
        settingsTransparentView()
        tableView.tableFooterView = UIView.init(frame: .zero)
        settingPlaceButton()
        totalPrice()
    }
    
    private func settingsTransparentView(){
        transparentView.center = view.center
        transparentView.bounds = view.bounds
    }
    
    private func settingPlaceButton(){
        placeAnOrderButtonOutlet.layer.cornerRadius = 20
    }
    
    //?????????????? ?????????? ??????????????
    private func totalPrice(){
        var sum = 0
        for i in arrayItem{
            let price = i.price
            sum += price
        }
        totalPriceLabel.text = "\(sum) ??????."
        sum == 0 ? self.placeAnOrderButtonOutlet.setTitle("???? ??????????????", for: .normal) : self.placeAnOrderButtonOutlet.setTitle("???????????????? ??????????", for: .normal)
    }
    //???????????? "???????????????? ??????????"
    @IBAction func placeAnOrderButton(_ sender: UIButton) {
        if !arrayItem.isEmpty{
            let ac = UIAlertController(title: "??????????????!", message: "?????? ?????????? ?????????????? ????????????????", preferredStyle: .alert)
            let action = UIAlertAction(title: "?????????????????? ???? ?????????????? ??????????", style: .default) { (action) in
                Persistence.shared.removeAll()
                self.countItemZeroDelegate?.countItemBadgeInZero(count: 0)
                self.performSegue(withIdentifier: "unwind", sender: self)
            }
            ac.addAction(action)
            present(ac, animated: true, completion: nil)
        } else{
            self.performSegue(withIdentifier: "unwind", sender: self)
        }
    }
    //?????????????????????? ???????????? "????" ?????? ???????????????? ????????????
    @IBAction func yesButtonAction(_ sender: UIButton){
        if let delegate = delegate, let indexPath = indexPath{
            delegate.deleteItem(indexPath: indexPath)
        }
        animateOutPopUp()
    }
    
    //?????????????????????? ???????????? "??????" ?????? ???????????????? ????????????
    @IBAction func noButtonAction(_ sender: UIButton){
        self.transparentView.isHidden = true
        animateOutPopUp()
    }
    
    private func animateInPopUp(){
        yesButton.layer.cornerRadius = 10
        noButton.layer.cornerRadius = 10
        
        yesButton.layer.borderWidth = 1
        noButton.layer.borderWidth = 1
        
        yesButton.layer.borderColor = UIColor.darkGray.cgColor
        noButton.layer.borderColor = UIColor.darkGray.cgColor
        
        popUpView.layer.cornerRadius = 10
        self.view.addSubview(transparentView)
        self.view.addSubview(popUpView)
        popUpView.center = view.center
        popUpView.backgroundColor = .white
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.transparentView.backgroundColor = .darkGray
            self.transparentView.alpha = 0.5
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateOutPopUp(){
        UIView.animate(withDuration: 0.4) {
            self.popUpView.alpha = 0
            self.popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.transparentView.alpha = 0
        } completion: { (success) in
            self.popUpView.removeFromSuperview()
        }
    }
}

extension CartVC: UITableViewDataSource, UITableViewDelegate, DeleteCellDelegate, DeleteItem{
    //MARK: -delegate
    func deleteItem(indexPath: IndexPath) {
        Persistence.shared.remove(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        tableView.reloadData()
        print("delete \(indexPath.row)")
        totalPrice()
        animateOutPopUp()
    }
    
    func deleteCellPressed(_ cartCell: CartCell, indexPath: IndexPath) {
        self.transparentView.isHidden = false
        self.indexPath = indexPath
        self.delegate = self
        animateInPopUp()
    }
    
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
        cell.sizeLabel.text = "????????????: \(arrayItem[indexPath.row].size)"
        cell.colorLabel.text = "????????: \(arrayItem[indexPath.row].color)"
        cell.priceLabel.text = "\(arrayItem[indexPath.row].price) ???"
        cell.countLabel.text = "????????????????????: \(arrayItem[indexPath.row].count)"
        cell.delegate = self
        cell.indexPath = indexPath
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
