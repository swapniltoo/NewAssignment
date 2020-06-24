//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import UIKit

class ViewController: UIViewController, CatProductTableViewCellDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var arr : [[String:Any]] = [[:]]
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView()
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        GlobalMethod.sharedInstance.getPopulerViews(availableperiod: "1") { (isResult, result) in
            print(result ?? "Error")
            DispatchQueue.main.async {
            self.arr = result!["categories"] as! [[String : Any]]
            self.tableView.reloadData()
                //  stop activity indicator
                myActivityIndicator.stopAnimating()
                myActivityIndicator.removeFromSuperview()
            }
        }
    }

}

extension ViewController : UITableViewDelegate,UITableViewDataSource
{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 310
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arr.count >= 1
        {
            return arr.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr.count > 1
        {
            return 1
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dir = arr[indexPath.section]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CatProductTableViewCell
        self.configure(cell: cell, forRowAt: indexPath , dir: dir)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dir = arr[indexPath.section]
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let detailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.cellData = dir["products"] as! [[String : Any]]
        self.navigationController?.modalPresentationStyle = .fullScreen

        self.present(detailViewController, animated: false, completion: {
        })
    }
    
    func configure(cell: CatProductTableViewCell, forRowAt indexPath: IndexPath , dir : [String:Any]) {
        cell.products = dir["products"] as! Array<NSDictionary>

        cell.categoryNameLabel.text = dir["name"] as? String ?? ""
            cell.collectionView.register(UINib(nibName: "ViewAllCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllCollectionCell")
            cell.collectionView.tag = 0 //indexPath.section
                let layout = cell.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
                layout?.scrollDirection = .horizontal
                cell.collectionView.setCollectionViewLayout(layout!, animated: true)
                cell.collectionView.isScrollEnabled = true
                cell.layoutDirection = .horizontal
                layout?.minimumLineSpacing = 8
            cell.collectionView.reloadData()
        cell.delegate = self
        
            cell.selectionStyle = .none
        }
    
    
    func catProductTableViewCellViewAllBtnTpd(_ cell: CatProductTableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let dir = arr[indexPath.section]
             let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let detailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            detailViewController.products = dir["products"] as! Array<NSDictionary>
            detailViewController.strTitle = dir["name"] as? String
            self.navigationController?.modalPresentationStyle = .fullScreen

            self.present(detailViewController, animated: false, completion: {
            })
        }
    }
    
    func catProductTableViewCellWillSendCartNotification() {
        
    }
    
    func catProductTableView(cell: CatProductTableViewCell, didSelectProduct product: NSDictionary) {
    
    }
    
    func cartPorductTableViewCellUpdateWishList(_ cell: Any) {
    
    }
    
    func viewMoreProductDelegate(_ dict: NSDictionary) {
    
    }
    
}

