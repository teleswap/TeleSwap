//
//  PostViewController.swift
//  TeleSwap
//
//  Created by Cameron Dunn on 5/16/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MapKit

class PostViewController : UIViewController{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipTextField: UITextField!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var phoneOfferedTF: UITextField!
    @IBOutlet weak var colorOfferedTF: UITextField!
    @IBOutlet weak var cashOnTopTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationHelper = LocationHelper()
    var offers : [AcceptableOffer] = []
    var images: [UIImage] = []
    let picker = UIImagePickerController()
    var uploadedImage = UIImage()
    
    @IBAction func addImagesTapped(_ sender: Any) {
        loadPicker()
    }
    
    @IBAction func addOfferTapped(_ sender: Any) {
//        let offer = AcceptableOffer(title: phoneOfferedTF.text!, color: colorOfferedTF.text!, offerOnTop: Double(cashOnTopTF.text!)!)
        //offers.append(offer)
        tableView.reloadData()
        
    }
    
    @IBAction func postSwapTapped(_ sender: Any) {
        APIController.shared.createUserListing(userId: APIController.shared.currentUser!.id, title: titleTextField.text!, body: descriptionTextField.text!, city: cityTextField.text!, zipCode: Int(zipTextField.text!)!, images: self.images) { (listing, errorMessage) in
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.text = UserDefaults.standard.city
        zipTextField.text = UserDefaults.standard.zipCode
        picker.delegate = self
        mapKitView.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationHelper.locationManager.delegate = self
            locationHelper.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationHelper.locationManager.startUpdatingLocation()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
}


//Extension for table view
extension PostViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell") as! PhoneTableViewCell
        cell.phoneNameLabel.text = offers[indexPath.row].title
        cell.yearLabel.text = "\(offers[indexPath.row].year ?? 2006)"
        cell.offerOnTop.text = "$\(offers[indexPath.row].offerOnTop)"
        guard let safeData = offers[indexPath.row].imageData else {return cell}
        cell.imageView?.image = UIImage(data: safeData)
        return cell
    }
}


//Extension for image picker
extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func loadPicker(){
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({_ in
                let alert = UIAlertController(title: "Continue", message: "If you just granted permisson you'll need to tap the button again to be taken to image selection.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert,animated: true)
                return
            })
        }else{
            if PHPhotoLibrary.authorizationStatus() == .authorized{
                picker.allowsEditing = true
                self.present(self.picker, animated: true)
            } else {
                let alert = UIAlertController(title: "Error", message: "You have not granted this app permission to your photo gallery. Please do so in your settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image : UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        images.append(image)
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}



//extension for collection view

extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.uploadedImage.image = images[indexPath.row]
        return cell
    }
    
    
}


//extension for MapKit and getting user location

extension PostViewController : CLLocationManagerDelegate, MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else {return}
        mapKitView.showsUserLocation = true
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 40000, longitudinalMeters: 40000)
        mapKitView.region = region
        mapKitView.addOverlay(MKCircle(center: location, radius: 15000))
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverLay = overlay as? MKCircle else {return MKOverlayRenderer()}
        
        let circleRenderer = MKCircleRenderer(circle: circleOverLay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.2
        return circleRenderer
    }
    
}
