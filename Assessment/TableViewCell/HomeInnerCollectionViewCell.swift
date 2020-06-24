//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//
import UIKit
import AlamofireImage

class HomeInnerCollectionViewCell: UICollectionViewCell, CAAnimationDelegate , UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate  {


    @IBInspectable var cornerRadius: CGFloat = 2
    
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    
    @IBOutlet var optionBtn: UIButton?
    @IBOutlet var optImgBtn: UIButton?
    
    @IBOutlet weak var imgItem: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet var viewCart: UIView!
    @IBOutlet var btnDeleteProduct: UIButton!
    @IBOutlet var btnPlusProduct: UIButton!
    @IBOutlet var lblProductQuantity: UILabel!
    var animationImageView: UIImageView?

    var topView: UIView!
    var optView: UIView!
    var cellData:NSDictionary = [:]
    
    private var myArray: NSArray = []
    private var tableView: UITableView!
    var collectionview: UICollectionView!
    var optionLinkData =  [Any]()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var wishListBtn: UIButton!
    var wishListAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnCart.layer.cornerRadius = 5.0
        self.btnCart.clipsToBounds = true
        self.btnDeleteProduct.layer.cornerRadius = 5.0
        self.btnDeleteProduct.clipsToBounds = true
        self.btnPlusProduct.layer.cornerRadius = 5.0
        self.btnPlusProduct.clipsToBounds = true
        self.viewCart.layer.cornerRadius = 5.0
        self.btnDeleteProduct.backgroundColor = UIColor.clear
        self.btnPlusProduct.backgroundColor = UIColor.clear
        self.btnPlusProduct.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        self.lblProductQuantity.textColor = UIColor.black
        
    }

    
    @IBAction func wishListBtnTpd(_ sender: Any) {
        if let action = self.wishListAction {
            action()
        }
    }
    
    @IBAction func optBtnTpd(_ sender: Any) {
        topView =  self.superview
        self.addpopuptoTopview(topViewOfVC: topView)
    }
    
    func addpopuptoTopview(topViewOfVC:UIView) -> Void {
        
        let displayWidth: CGFloat = topViewOfVC.frame.width
        let displayHeight: CGFloat = topViewOfVC.frame.height
        
        let testFrame : CGRect = CGRect(x: 0, y: 0, width: displayWidth , height: displayHeight)
        optView = UIView(frame: testFrame)
        optView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        optView.alpha=1.0
        topViewOfVC.addSubview(optView)
        
        myArray =  cellData["variants"] as! NSArray

        let rowCount = myArray.count

        var tableViewhight =  rowCount * 40 + 80
        if myArray.count > 4 {
          tableViewhight =  240 + 80
        }
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Int(displayWidth - 130), height: tableViewhight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.center =  optView.center
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = 111
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.sectionHeaderHeight = 70

        topViewOfVC.addSubview(tableView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        optView.addGestureRecognizer(tap)
        optView.isUserInteractionEnabled = true
        
    }

    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
            optView.removeFromSuperview()
            tableView.removeFromSuperview()
    }
    
    // Set the spacing between sections
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor =  .lightGray
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textAlignment = .center
        label.text = "Options"
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 40
        }
        else
        {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let list =  cellData["variants"] as! NSArray
        if  (list as AnyObject).count > 0
        {
            return list.count
        }
            return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        let list =  cellData["variants"] as! NSArray
        let options = list[indexPath.row] as! NSDictionary
        cell.textLabel!.text = options["color"] as? String

        cell.textLabel?.textAlignment = .center
        cell.viewCornerRadius = 5
        cell.borderWidth = 0.2
        cell.borderColor = .black
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optView.removeFromSuperview()
        tableView.removeFromSuperview()
        
        let list =  cellData["variants"] as! NSArray
        let options = list[indexPath.row] as! NSDictionary
        let title = options["color"] as? String ?? ""
        
        let dir = list.object(at: indexPath.row) as! [String:Any]
        let price = Int(dir["price"] as! Double )
        self.lblPrice.text = "\(price)"

        self.optionBtn?.setTitle(title, for: .normal)
        
    }
}

@IBDesignable
extension HomeInnerCollectionViewCell
{
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
