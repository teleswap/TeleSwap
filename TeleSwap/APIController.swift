//
//  APIController.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/12/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit
import JWTDecode

class APIController {
    
    static let shared = APIController()
    
    //Signup User
    func signUp(firstName: String, lastName: String, email: String, username: String, password: String, completion: @escaping (ErrorMessage?) -> Void = {_  in }){
        let url = baseUrl.appendingPathComponent("users")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let userParams = ["firstName": firstName, "lastName": lastName, "username": username, "email": email, "password": password] as [String: Any]
        do {
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error signup up the user: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(signUp)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(signUp) \(error)")
                    return
                }
                return
            }
            
            NSLog("Successfully signed up User")
            
            self.logIn(email: email, password: password, completion: completion)
            
            }.resume()
    }
    
    //Login User
    func logIn(email: String, password: String, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("tokens")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let userParams = ["email": email, "password": password] as [String: Any]
        do {
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error logging in the user: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(logIn)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(logIn) \(error)")
                    return
                }
                
                return
            }
            
            do {
                let jwtToken = try JSONDecoder().decode(JWT.self, from: data)
                let jwt = try decode(jwt: jwtToken.jwt)
                let userId = jwt.body["id"] as! Int
                let token = jwt.string
                self.saveCurrentUser(userId: userId, token: token)
            } catch {
                NSLog("Error decoding JSON Web Token \(error)")
                return
            }
            
            NSLog("Successfully logged in User")
            
            completion(nil)
            }.resume()
    }
    
    //Get User through userId
    func getUser(userId: Int, completion: @escaping (User?, ErrorMessage?) -> Void = { _,_  in }) {
        let url = baseUrl.appendingPathComponent("users")
            .appendingPathComponent("\(userId)")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }

        request.setValue(token, forHTTPHeaderField: "Authorization")

        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting user: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getUser)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getUser) \(error)")
                    return
                }
                return
            }
            
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                self.currentUser = user
                completion(user, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched User")
            
            
            }.resume()
        
    }
    
    //Get All Listings
    func getAllListings(completion: @escaping ([Listing]?, ErrorMessage?) -> Void = {_,_ in}) {
        let url = baseUrl.appendingPathComponent("listings")
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.get.rawValue
        
//        guard let token = UserDefaults.standard.token else {
//            NSLog("No JWT Token Set to User Defaults")
//            return
//        }
        
        //request.setValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error with getting all listings: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(getAllListings)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(getAllListings) \(error)")
                    return
                }
                return
            }
            
            do {
                let listings = try JSONDecoder().decode([Listing].self, from: data)
                self.listings = listings
                completion(listings, nil)
            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("Successfully fetched all Listings")
            
            
            }.resume()
    }
    
    //Create User Listing
    func createUserListing(userId: Int, title: String, body: String, city: String, zipCode: Int, images: [UIImage], completion: @escaping (Listing?, ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("users")
            .appendingPathComponent("\(userId)")
            .appendingPathComponent("listings")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        

        let params = ["title": title, "body": body, "city": city, "zipCode": zipCode] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }

        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending params to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(createUserListing)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(nil, errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(createUserListing) \(error)")
                    return
                }
                return
            }
            
            do {
                let listing = try JSONDecoder().decode(Listing.self, from: data)
                self.listing = listing
                for image in images {
                    self.uploadImage(imageData: image.pngData()!, type: ModelKeys.listing, model: self.listing!, completion: { (errorMessage) in
                        completion(listing, nil)
                    })
                }

            } catch {
                NSLog("Error with network request: \(error)")
                return
            }
            
            NSLog("User successfully created user listing")
            completion(nil, nil)
            
            }.resume()
    }
    
    //Create Acceptable Offer
    func createAcceptableOffer(listingId: Int, title: String, color: String, cashOnTop: Float, completion: @escaping (ErrorMessage?) -> Void) {
        let url = baseUrl.appendingPathComponent("listings")
            .appendingPathComponent("\(listingId)")
            .appendingPathComponent("acceptable_offers")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        
        let params = ["title": title, "color": color, "cashOnTop": cashOnTop] as [String: Any]
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }
        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if let error = error {
                NSLog("There was an error sending params to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(createUserListing)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(createUserListing) \(error)")
                    return
                }
                return
            }
            
            NSLog("User successfully created offer")
            completion(nil)
            
            }.resume()
    }
    
    func uploadImage(imageData: Data, type: ModelKeys, model: Listing, completion: @escaping (ErrorMessage?) -> Void) {
        let encodedImageData = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        let url = baseUrl.appendingPathComponent("images")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        
        guard let token = UserDefaults.standard.token else {
            NSLog("No JWT Token Set to User Defaults")
            return
        }

        
        request.setValue(token, forHTTPHeaderField: "Authorization")
        //let postString = "image=\(encodedImageData)"
        let params = ["\(type.rawValue)Id": model.id, "image": encodedImageData] as [String: Any]
        //request.httpBody = postString.data(using: .utf8)
        do {
            let json = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            NSLog("Error encoding JSON")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("There was an error sending image data to server: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Error retrieving data from server(updateProfileImage)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                NSLog("Error code from the http request: \(httpResponse.statusCode)")
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
                    completion(errorMessage)
                } catch {
                    NSLog("Error decoding ErrorMessage(updateProfileImage) \(error)")
                    return
                }
                return
            }
            NSLog("Successfully Changed Profile Picture")
            completion(nil)
        }
        task.resume()
    }
    
    
    //Helper Methods
    
    //Save JSON Web Token and Associated User
    private func saveCurrentUser(userId: Int, token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    //Get Image
    func getImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void = {_,_ in}) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, error);
            }.resume()
    }
    
    var currentUser: User?
    var listings: [Listing] = []
    var listing: Listing?
    let baseUrl = URL(string: "https://teleswapapi.herokuapp.com/api")!
//    let baseUrl = URL(string: "http://localhost:3000/api")!
}
