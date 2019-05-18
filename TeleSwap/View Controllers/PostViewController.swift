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
    
    let picker = UIImagePickerController()
    var uploadedImage = UIImage()
    
    @IBAction func addImagesTapped(_ sender: Any) {
        loadPicker()
    }
    
    @IBAction func addOfferTapped(_ sender: Any) {
        let offer = Offer(title: phoneOfferedTF.text!, color: colorOfferedTF.text!, offerOnTop: Int(cashOnTopTF.text!)!)
        Model.shared.offers.append(offer)
        
    }
    
    @IBAction func postSwapTapped(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
}


//Extension for table view
extension PostViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell")
        return cell!
    }
}


//Extension for image picker
extension PostViewController: UIImagePickerControllerDelegate{
    
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
        uploadedImage = image
        picker.dismiss(animated: true, completion: nil)
    }
}
