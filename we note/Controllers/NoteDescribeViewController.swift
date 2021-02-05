//
//  NoteDescribeViewController.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit

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
        }
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
    }
    
    // MARK:- TODO:- func NewNote.
    func NewNote() {
        // First Dismiss Keypad if it's Active
        self.view.endEditing(true)
        
        let data = [
                    "NoteTitle": notedescribeview.NoteTitle.text!,
                    "NoteDesc": notedescribeview.NoteDescribtion.text!,
                    "dateCreated": "2020/05/15",
                    "dateModify": "2020/05/15",
                    "long": 31.51447889,
                    "lati": 32.514778889
                   ] as [String : Any] 
        
        FirebaseNetworking.addData(collectionName: "Notes", data: data) { (res) in
            if res == "Success" {
                //self.delegate.NewNote(NoteTitle: self.notedescribeview.NoteTitle.text!)
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
