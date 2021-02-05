//
//  NoteMetaDataViewController.swift
//  we note
//
//  Created by Mohamed Ali on 2/4/21.
//

import UIKit
import MapKit

class NoteMetaDataViewController: UIViewController {

    // MARK:- TODO:- Make Object From View NoteMetaData
    var notemetadata: NoteMetaDataView! {
        guard isViewLoaded else { return nil }
        return (view as! NoteMetaDataView)
    }
    
    // MARK:- TODO:- Insisalize Varibles Here.
    var NoteMetaData:Note!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Meta Data For Note
        LoadMetaData()
    }
    
    @IBAction func BTNBack (_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- TODO:- Function Load Meta Data.
    func LoadMetaData() {
        
        // Show Data from Getten Object.
        notemetadata.NoteTitle.text = NoteMetaData.NoteTitle
        notemetadata.NoteDateCreated.text = NoteMetaData.NoteCreatedDate
        notemetadata.NoteDateModify.text = NoteMetaData.NoteModifiedDate
        
        // Point on a location with long and latit
        MakeLocation(Title: "Note Location", SubTitle: "You write Note at here", lati: NoteMetaData.lati, long: NoteMetaData.long)
    }
    
    // MARK:- TODO:- This Method For Making a Pin in Map.
    func MakeLocation (Title:String,SubTitle:String,lati:Double,long:Double)  {
        
        let anotation = MKPointAnnotation()
        
        anotation.coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
        notemetadata.mapView.addAnnotation(anotation)
        anotation.title = Title
        anotation.subtitle = SubTitle
        let range = MKCoordinateRegion(center: anotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        notemetadata.mapView.setRegion(range, animated: true)
        
    }
    
}
