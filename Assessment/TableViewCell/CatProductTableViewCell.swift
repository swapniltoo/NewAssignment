//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import AlamofireImage


class CatProductTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var products: Array<NSDictionary> = []
    var delegate: CatProductTableViewCellDelegate?
    var layoutDirection: UICollectionView.ScrollDirection = .vertical

    @IBOutlet weak var categoryNameLabel: UILabel!
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    MARK: - UICollectionView methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: collectionView.frame.width/2 - 5, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SKHomeCategotiesListCollectionViewCell", for: indexPath) as! SKHomeCategotiesListCollectionViewCell
        cell.imageView.layer.cornerRadius = 4 //30.0
        cell.imageView.layer.borderColor = UIColor.black.cgColor
        cell.imageView.layer.borderWidth = 0.1
        cell.layoutIfNeeded()
        self.configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0
        {
            var index = indexPath.item
            if layoutDirection != .vertical {
                index = indexPath.item
            }
            let dict = self.products[index]
            self.delegate?.catProductTableView(cell: self, didSelectProduct: dict)
        }
        else if indexPath.item ==  self.products.count && layoutDirection == .horizontal
        {
            self.delegate?.catProductTableViewCellViewAllBtnTpd(self)
        }
        else
        {
            var index = indexPath.item
            if layoutDirection != .vertical {
                index = indexPath.item
            }
            let dict = self.products[index]
            self.delegate?.catProductTableView(cell: self, didSelectProduct: dict)
        }
    }
    
    func configure(cell: Any, forItemAt indexPath: IndexPath) {
        var newCell : SKHomeCategotiesListCollectionViewCell =  SKHomeCategotiesListCollectionViewCell()
        let index = indexPath.item
        let dictt = self.products[index]
            newCell =  cell as! SKHomeCategotiesListCollectionViewCell
            newCell.imageView.image = nil
        
            var productId = dictt["product_id"] as? String
            if productId == nil {
                productId = dictt["id"] as? String
            }

            var imgURL = dictt["thumb"] as? String
            if imgURL == nil {
                imgURL = dictt["image"] as? String
            }
            if imgURL != nil {
                let url = URL(string: imgURL!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
                newCell.loadingIndicator.startAnimating()
                newCell.imageView.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeHolder")) { (img) in
                    newCell.loadingIndicator.stopAnimating()
                    newCell.imageView.clipsToBounds = true
                    newCell.imageView.contentMode = .scaleAspectFill
                }
            }
            else {
                newCell.imageView.image = #imageLiteral(resourceName: "icon-placeholder.jpg")
            }
            var title = dictt["name"] as? String
            if title == nil {
               title = dictt["title"] as? String
            }
            let name = title?.plainString()
            newCell.titleLbl.text = name
            newCell.imageView.image = newCell.imageView.image?.withAlignmentRectInsets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            // Do something
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Do something
        let offsetX: CGFloat = scrollView.contentOffset.x
        let contentWidth: CGFloat = scrollView.contentSize.width
        if offsetX >= contentWidth - scrollView.frame.size.width {
            //start loading new images
            print(offsetX)
        }
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
        self.delegate?.catProductTableViewCellViewAllBtnTpd(self)
    }
}
