//
//  ViewController.swift
//  TeleSwap
//
//  Created by Cameron Dunn on 4/25/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    @IBOutlet weak var logoMiddleConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var logoImageview: UIImageView!
    
    let locationManager = CLLocationManager()
    var logoCenter : CGPoint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logoCenter = logoImageview.center
        logoMiddleConstraint.constant = 0
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        buttonStackView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animateKeyframes(withDuration: 1, delay: 0.2, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 10, animations: {
                self.logoImageview.center = self.logoCenter!
            })
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 10, animations: {
                self.buttonStackView.alpha = 1
            })
        }, completion: nil)
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (_) in
                
            }
        }
        self.locationManager.requestWhenInUseAuthorization()
    }
}




