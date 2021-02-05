//
//  Tools.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit

// MARK:- TODO:- In this Class i write some Methods i used it in all the programme
class Tools {
    
    // MARK:- TODO:- Function Make Alert.
    public static func MakeAlert (Title:String , Mess:String , ob:UIViewController)
    {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        ob.present(alert,animated:true,completion: nil)
    }
    
}
