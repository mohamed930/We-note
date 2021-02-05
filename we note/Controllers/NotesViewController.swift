//
//  NotesViewController.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit
import FirebaseAuth
import RappleProgressHUD

class NotesViewController: UIViewController {
    
    // MARK:- TODO:- Insialize object from NotesView.
    var notesview: NotesView!  {
        guard isViewLoaded else { return nil }
        return (view as! NotesView)
    }
    
    // MARK:- TODO:- Insialize Varibles we used here:-
    var NotesArr = Array<Note>()
    let CellIdentifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK:- TODO:- Insilaize table view Datasource and delegate and regester to his cell.
        self.notesview.tableView.dataSource = self
        self.notesview.tableView.delegate   = self
        self.notesview.tableView.register(UINib(nibName: "NoteCellTableViewCell", bundle: nil),                                       forCellReuseIdentifier: CellIdentifier)
        
        // MARK:- TODO:- This Method For Getting Current Notes.
        GettingNotes()
    }
    
    // MARK:- TODO:- Action For New Note.
    @IBAction func BTNNewNote (_ sender:Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "NoteDecribe") as! NoteDescribeViewController
        next.delegate = self
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Method GettingNotes For Getting the Notes.
    func GettingNotes () {
        
        FirebaseNetworking.readWithWhereCondtion(collectionName: "Notes", k: "UserNote", v: (Auth.auth().currentUser?.email!)!) { (snapshot) in
            if snapshot.isEmpty {
                // if result is empty show Mess.
                RappleActivityIndicatorView.stopAnimation()
                self.notesview.tableView.isHidden = true
                self.notesview.LabelMess.isHidden = false
            }
            else {
                // Load All Notes
            }
        }
        
    }
    
    // MARK:- TODO:- This Method For  Delete Note From Database.
    func DeleteMethod(rowNumber:Int) {
        
    }
}

extension NotesViewController: UITableViewDelegate {
    // MARK:- TODO:- Tap Note Cell and move to Note Details.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Make Move Operation with Note Data.
        let story = UIStoryboard(name: "Main", bundle: nil)
        let next = story.instantiateViewController(withIdentifier: "NoteDecribe") as! NoteDescribeViewController
        next.delegate = self
        next.EditStatus = true
        next.onece = self.NotesArr[indexPath.row]
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
        
    }
    
    // MARK:- TODO:- Swipe Note Cell to Delete Cell.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Make When Cell Swipe Show Delete Button.
        if editingStyle == .delete {
            
            let alert = UIAlertController(title: "Attention" , message: "Are you sure to delete note?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action1)
            
            let action2 = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
                // When Click on Delete Send Number row and delete the note.
                self.DeleteMethod(rowNumber: indexPath.row)
            }
            alert.addAction(action2)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
}

extension NotesViewController: UITableViewDataSource {
    
    // MARK:- TODO:- Number Sektion in tableView.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK:- TODO:- Number of cell we created to show all notes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesArr.count
    }
    
    // MARK:- TODO:- Show Data in the cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoteCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier , for: indexPath) as! NoteCellTableViewCell
        
        cell.NoteTitleLabel.text = NotesArr[indexPath.row].NoteTitle
        
        return cell
    }
}

// MARK:- TODO:- The Protocol To Get New Title
extension NotesViewController: NewNote {
    func NewNote(NoteData: Note) {
        notesview.tableView.isHidden = false
        notesview.LabelMess.isHidden = true
        
        //let ob = Note()
        //ob.NoteTitle = NoteTitle
        
        self.NotesArr.append(NoteData)
        notesview.tableView.reloadData()
    }
}
