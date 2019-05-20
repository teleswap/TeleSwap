//
//  MessagesViewController.swift
//  TeleSwap
//
//  Created by Cameron Dunn on 5/20/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import UIKit

class MessagesViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
    }
}
