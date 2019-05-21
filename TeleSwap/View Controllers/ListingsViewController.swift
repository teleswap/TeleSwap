//
//  ListingsViewController.swift
//  TeleSwap
//
//  Created by Cameron Dunn on 5/16/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit

class ListingsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var listings : [Listing] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        APIController.shared.getAllListings { (listings, errorMessage) in
            if let error = errorMessage{
                print(error)
                return
            }
            self.listings = listings!
            self.tableView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension for tableView

extension ListingsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell") as! ListingTableViewCell
        cell.phoneLabel.text = self.listings[indexPath.row].title
        guard let images = listings[indexPath.row].images?.first?.url else {return cell}
        APIController.shared.getImage(url: URL(string: images)!) { (image, error) in
            if let error = error{
                print(error)
                return
            }
            DispatchQueue.main.async {
                cell.phoneImageView.image = image
                
            }
            
        }
        return cell
    }
    
}
