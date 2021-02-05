//
//  NoteDescribeViewController.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit
import FirebaseAuth
import CoreLocation

// MARK:- TODO:- This Protocol For Getting New Note Title or Updated.
protocol NewNote {
    func NewNote (NoteData: Note)
}

class NoteDescribeViewController: UIViewController {
    
    // MARK:- TODO:- Make Obj from View NoteDescribe.
    var notedescribeview: NoteDescribeView! {
        guard isViewLoaded else { return nil }
        return (view as! NoteDescribeView)
    }
    
    // MARK:- TODO:- Insialize varibles here we used.
    var EditStatus = false
    var onece: Note!
    var delegate: NewNote!
    let location = CLLocationManager()
    var long = Double()
    var lati = Double()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if Edit Status is true
        if EditStatus == true {
            /*
                1) Change Save Button Title to Edit
                2) Load Note Data in Describe View.
             */
            notedescribeview.ButtonSave.title = "Edit"
            notedescribeview.NoteTitle.text = onece.NoteTitle
            notedescribeview.NoteDescribtion.text = onece.NoteDetails
            notedescribeview.ButtonMetaData.isHidden = false
        }
        
        // Open GPS And Get The Location
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    // MARK:- TODO:- Make Save Button Action.
    @IBAction func BTNSave (_ sender: Any) {
        // Check we use view controoler as Edit or Add.
        if EditStatus == true {
            UpdateNote()
        }
        else {
            NewNote()
        }
    }
    
    // MARK:- TODO:- Make Back Operation Action.
    @IBAction func BTNBack (_ sender: Any) {
        
        let Alert = UIAlertController(title: "Attention", message: "Are sure to Save?", preferredStyle: .alert)
        
        Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        Alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alert) in
            
            // Check if we are Update or Save
            if self.EditStatus == true {
                self.UpdateNote()
                self.dismiss(animated: true, completion: nil) // Changed it when write method
            }
            else {
                self.NewNote()
                
                self.dismiss(animated: true, completion: nil) // Changed it when write method
            }
            
        }))
        self.present(Alert, animated: true, completion: nil)
        
    }
    
    // MARK:- TODO:- Action For Button Meta Data.
    @IBAction func BTNMetaData (_ sender: Any) {
        
        // Move Note Data to MetaData View and Show View.
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "NoteMetaDataView") as! NoteMetaDataViewController
        next.NoteMetaData = onece
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
        
    }
    
    // MARK:- TODO:- func UpdateNote.
    func UpdateNote() {
        // First Dismiss Keypad if it's Active
        self.view.endEditing(true)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyyHH:mm:ss a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let result = formatter.string(from: date)
        
        var noteTitle = String()
        
        if notedescribeview.NoteTitle.text == "" {
            noteTitle = "No Title"
        }
        else {
            noteTitle = notedescribeview.NoteTitle.text!
        }
        
        let data = [
                        "NoteTitle": noteTitle,
                        "NoteDesc": notedescribeview.NoteDescribtion.text!,
                        "dateModify": result,
                        "long": long,
                        "lati": lati
                   ] as [String:Any]
        
        FirebaseNetworking.updateDocumnt(collectionName: "Notes", documntId: onece.NoteID, data: data) { (res) in
            if res == "Success" {
                
                let ob = Note()
                ob.NoteID      = self.onece.NoteID
                ob.NoteTitle   = noteTitle
                ob.NoteCreatedDate = self.onece.NoteCreatedDate
                ob.NoteDetails = self.notedescribeview.NoteDescribtion.text!
                ob.NoteModifiedDate = result
                ob.lati = self.lati
                ob.long = self.long
                self.delegate.NewNote(NoteData: ob)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- TODO:- func NewNote.
    func NewNote() {
        // First Dismiss Keypad if it's Active
        self.view.endEditing(true)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyyHH:mm:ss a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let result = formatter.string(from: date)
        
        var noteTitle = String()
        
        if notedescribeview.NoteTitle.text == "" {
            noteTitle = "No Title"
        }
        else {
            noteTitle = notedescribeview.NoteTitle.text!
        }
        
        let data = [
                    "NoteTitle": noteTitle,
                    "NoteDesc": notedescribeview.NoteDescribtion.text!,
                    "dateCreated": result,
                    "dateModify": result,
                    "long": long,
                    "lati": lati,
                    "UserNote": (Auth.auth().currentUser?.email!)!
                   ] as [String : Any] 
        
        FirebaseNetworking.addData(collectionName: "Notes", data: data) { (res) in
            if res == "Success" {
                let ob = Note()
                ob.NoteTitle   = noteTitle
                ob.NoteDetails = self.notedescribeview.NoteDescribtion.text!
                ob.NoteCreatedDate  = result
                ob.NoteModifiedDate = result
                ob.lati = self.lati
                ob.long = self.long
                self.delegate.NewNote(NoteData: ob)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK:- TODO:- When Touch Began in Screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dissmiss KeyPad
        self.view.endEditing(true)
    }
}

// MARK:- TODO:-
extension NoteDescribeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notedescribeview.NoteDescribtion.becomeFirstResponder()
        return true
    }
}

// MARK:- TODO:- This Extension For Getting Handle GPS Getting Location
extension NoteDescribeViewController: CLLocationManagerDelegate {
    
    // TODO: These Methods For GPS.
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let l = locations[locations.count - 1]
        if l.horizontalAccuracy > 0 {
            location.stopUpdatingLocation()
            location.delegate = nil
            
            // print("Long = \(l.coordinate.longitude) latitude = \(l.coordinate.latitude)")
            
            long = (l.coordinate.longitude)
            lati = (l.coordinate.latitude)
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
