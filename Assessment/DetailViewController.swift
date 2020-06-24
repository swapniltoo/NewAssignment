//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController  {

    var cellData : [[String : Any]]!

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet  var newTitle: UILabel!


    @IBOutlet weak var collectionView: UICollectionView!
    var products: Array<NSDictionary> = []
    var delegate: CatProductTableViewCellDelegate?
    var layoutDirection: UICollectionView.ScrollDirection = .vertical

    fileprivate var priceAttr: [NSAttributedString.Key:UIFont] = {
        return [
            NSAttributedString.Key.font: UIFont.boldLatoFont(ofSize: 12.0)
        ]
    }()
    
    fileprivate var priceStrikeThroughAttr: [NSAttributedString.Key : Any] = {
        return [
            NSAttributedString.Key.font: UIFont.latoFont(ofSize: 8.0),
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.strikethroughColor: UIColor.red
        ]
    }()

    
      var strTitle: String!
      var arrData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.newTitle.text = strTitle
        
        self.collectionView.reloadData()

    }
    
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

}


extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //    MARK: - UICollectionView methods
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return self.products.count
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
            return CGSize(width: collectionView.frame.width/2 - 5, height: 260)
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeInnerCollectionViewCell", for: indexPath) as! HomeInnerCollectionViewCell
            cell.imgItem.layer.cornerRadius = 4 //30.0
            cell.imgItem.layer.borderColor = UIColor.black.cgColor
            cell.imgItem.layer.borderWidth = 0.1
            cell.layoutIfNeeded()
            self.configure(cell: cell, forItemAt: indexPath)
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        }
        
        func configure(cell: Any, forItemAt indexPath: IndexPath) {
            var homeInnerCell : HomeInnerCollectionViewCell = HomeInnerCollectionViewCell()
            let index = indexPath.item
            let dictt = self.products[index]

              homeInnerCell = cell as! HomeInnerCollectionViewCell
              homeInnerCell.cellData = dictt
              homeInnerCell.wishListBtn.setImage(#imageLiteral(resourceName: "WishListUnselect"), for: .normal)
              homeInnerCell.wishListBtn.setBackgroundImage(#imageLiteral(resourceName: "WishListUnselect"), for: .normal)
            homeInnerCell.bottomView.isHidden = false
            
                homeInnerCell.imgItem.image = nil

                var productId = dictt["id"] as? String
                if productId == nil {
                    productId = "0"
                }

                homeInnerCell.imgItem.image = #imageLiteral(resourceName: "icon-placeholder.jpg")

                var title = dictt["name"] as? String
                if  title == nil {
                    title = dictt["title"] as? String
                }
                let name = title?.plainString()
                homeInnerCell.titleLabel?.text = name

                homeInnerCell.btnCart.addTarget(self, action: #selector(self.btnAddCartPopularProudctsAction), for: .touchUpInside)
                homeInnerCell.btnCart.tag = index
                homeInnerCell.btnPlusProduct.addTarget(self, action: #selector(self.btnPlusProductCartPopularProudctsAction), for: .touchUpInside)
                homeInnerCell.btnPlusProduct.tag = index
                homeInnerCell.btnDeleteProduct.addTarget(self, action: #selector(self.btnDeleteProductCartPopularProudctsAction), for: .touchUpInside)
                homeInnerCell.btnDeleteProduct.tag = index

                homeInnerCell.btnCart.isHidden = false
                homeInnerCell.viewCart.isHidden = false
                homeInnerCell.bottomView.isHidden = false
            
                homeInnerCell.lblPrice.isHidden = false
                 
                    let price = dictt["price"] as? String
                    if price == nil {
                        homeInnerCell.viewCart.isHidden = true
                        homeInnerCell.btnCart.isHidden = true
                        homeInnerCell.wishListBtn.isHidden = true
                    }
                    else {
                        homeInnerCell.wishListBtn.isHidden = false
                    }
                    homeInnerCell.lblPrice.text = price
                


                let list =  (dictt["variants"] as? NSArray) as? [Any]
                if list?.count ?? 0 <= 0 {
                    homeInnerCell.optionBtn?.isHidden = true
                    homeInnerCell.optImgBtn?.isHidden = true
                }
                else
                {
                    let list =  dictt["variants"] as! NSArray
                    if  (list as AnyObject).count > 0
                    {
                        homeInnerCell.optionBtn?.setTitle((list[0] as! NSDictionary)["color"] as? String, for: .normal)
                        homeInnerCell.optionBtn?.isHidden = false
                        homeInnerCell.optImgBtn?.isHidden = false
                        homeInnerCell.viewCart.isHidden = false
                        homeInnerCell.bottomView.isHidden = false
                        let dir = list.object(at: 0) as! [String:Any]
                        let price = Int(dir["price"] as! Double )
                        homeInnerCell.lblPrice.text = "\(price)"
                    }
                }
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            
            if !decelerate {
                // Do something on scroll end
            }
            
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            // Do something for scroll end
            let offsetX: CGFloat = scrollView.contentOffset.x
            let contentWidth: CGFloat = scrollView.contentSize.width
            if offsetX >= contentWidth - scrollView.frame.size.width {
                //start loading new data 
                print(offsetX)
            }
        }

        func attributedPriceFrom(dictt: NSDictionary) -> NSMutableAttributedString {
            return NSMutableAttributedString(string: dictt["price"] as! String, attributes: self.priceAttr)
        }
        
    //    MARK: - Actions
        
        @objc func btnAddCartPopularProudctsAction(sender: UIButton){
            
        }
        
        @objc func btnPlusProductCartPopularProudctsAction(sender: UIButton){
            
            print("TAG: \(sender.tag)")

            guard let dict = self.products[sender.tag] as? [String: Any] else { return }
            var productId = dict["product_id"] as? String
            if productId == nil {
                productId = dict["id"] as? String
            }

        }
        
        @objc func btnDeleteProductCartPopularProudctsAction(sender: UIButton){
            let dict = self.products[sender.tag]
            var productId = dict["product_id"] as? String
            if productId == nil {
                productId = dict["id"] as? String
            }

        }

        @IBAction func viewAllBtnTpd(_ sender: Any) {
        }
    
}
