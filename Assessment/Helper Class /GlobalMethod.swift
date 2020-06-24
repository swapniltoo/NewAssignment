//
//  DetailViewController.swift
//  Assessment
//
//  Created by Apple on 23/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit


@objc protocol CatProductTableViewCellDelegate: NSObjectProtocol {
    func catProductTableViewCellWillSendCartNotification()
    func catProductTableView(cell: CatProductTableViewCell, didSelectProduct product: NSDictionary)
    func catProductTableViewCellViewAllBtnTpd(_ cell: CatProductTableViewCell)
    
    @objc optional func cartProductTableViewCellCollectionViewItemSize(_ cell: CatProductTableViewCell) -> CGSize
    func cartPorductTableViewCellUpdateWishList(_ cell: Any)
    func viewMoreProductDelegate(_ dict : NSDictionary)
    
}

private let SharedInstance = GlobalMethod()

enum Endpoint : String {
    
    case mjson                   = "/json"
    case wjson                   = "/"
    
}
class GlobalMethod: NSObject {

    public let BaseApiPath:String = "https://stark-spire-93433.herokuapp.com"
    class var sharedInstance : GlobalMethod {
        return SharedInstance
    }

    override init() {
    }

    
    //MARK: viewsAPI
    
    func getPopulerViews(availableperiod:String, completionHandler:@escaping (_ result:Bool, _ responseObject:NSDictionary?) -> Void){
        let url = "\(BaseApiPath)\(Endpoint.mjson.rawValue)"

        if let url = URL(string: url) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                    let json = jsonString.parseJSONString
                    completionHandler(true, json as? NSDictionary )
                 }
               }
            else
            {
                completionHandler(false, nil)
            }
           }.resume()
        }
    }
}


extension String
{
var parseJSONString: AnyObject?
{
    let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
    if let jsonData = data
    {
        do
        {
            let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
            if let jsonResult = message as? NSMutableArray {
                return jsonResult //Will return the json array output
            } else if let jsonResult = message as? NSMutableDictionary {
                return jsonResult //Will return the json dictionary output
            } else {
                return nil
            }
        }
        catch let error as NSError
        {
            print("An error occurred: \(error)")
            return nil
        }
    }
    else
    {
        // Lossless conversion of the string was not possible
        return nil
    }
}

}


extension UIFont {
    public class func latoFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    public class func boldLatoFont(ofSize fontSize: CGFloat) -> UIFont {
        return  UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
}
