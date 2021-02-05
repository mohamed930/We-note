//
//  FirebaseNetworking.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit
import RappleProgressHUD
import Firebase
import FirebaseFirestore
import FirebaseAuth
import ProgressHUD

class FirebaseNetworking {
    
    // MARK:- TODO:- This Method For Creating Account in firebase
    public static func createAccount(Email:String,Password:String,completion: @escaping (String) -> ()){
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please Wait", attributes: RappleModernAttributes)
        
        Auth.auth().createUser(withEmail: Email, password: Password) { (auth, error) in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your Data not created Successed!")
                completion("Failed")
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                completion("Success")
            }
        }
    }
    
    // MARK:- TODO:- This Method For Make a login opertation.
    public static func MakeLogin (Email:String,Password:String,completion: @escaping (String) -> ())  {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please Wait", attributes: RappleModernAttributes)
        
        Auth.auth().signIn(withEmail: Email, password: Password) { (auth, error) in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your \(error!.localizedDescription)")
                completion("Failed")
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showSuccess("Success in login")
                completion("Success")
            }
        }
        
    }
    
    // MARK:- TODO:- This Method for Read Data from Firebase with condtion.
    public static func readWithWhereCondtion (collectionName:String,k: String , v:String , complention: @escaping (QuerySnapshot) -> ()) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please Wait", attributes: RappleModernAttributes)
        Firestore.firestore().collection(collectionName).whereField(k, isEqualTo: v).getDocuments { (quary, error) in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("We Can't Find Your Data!")
            }
            else {
                complention(quary!)
            }
        }
    }
    
    // MARK:- TODO:- This Method For Adding Data to Firebase.
    public static func addData (collectionName:String,data:[String:Any],complention: @escaping (String) -> ()) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("loading", attributes: RappleModernAttributes)
        Firestore.firestore().collection(collectionName).document().setData(data){
            error in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your Data not created Successed!")
                complention("Error")
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showSuccess("Your Data created Successed!")
                complention("Success")
            }
        }
    }
    
    // MARK:- TODO:- This Method For Update Data from Firebase.
    public static func updateDocumnt (collectionName:String,documntId:String,data:[String:Any],complention: @escaping (String) -> ()) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please Wait", attributes: RappleModernAttributes)
        
        Firestore.firestore().collection(collectionName).document(documntId).updateData(data){
            error in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your Data isn't updated Successfully!")
                complention("Failure")
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showSuccess("Your Data is updated Successfully!")
                complention("Success")
            }
        }
        
    }
    
    // MARK:- TODO:- This Method For Update Data from Firebase.
    public static func DeleteDocumnt (collectionName:String,documntId:String,complention: @escaping (String) -> ()) {
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Please Wait", attributes: RappleModernAttributes)
        
        Firestore.firestore().collection(collectionName).document(documntId).delete(){
            error in
            if error != nil {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showError("Your Data isn't deleted Successfully!")
                complention("Failure")
            }
            else {
                RappleActivityIndicatorView.stopAnimation()
                ProgressHUD.showSuccess("Your Data is deleted Successfully!")
                complention("Success")
            }
        }
        
    }

}
