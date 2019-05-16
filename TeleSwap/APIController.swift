//
//  APIController.swift
//  TeleSwap
//
//  Created by Moin Uddin on 5/12/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
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
    
    func getUser(userId: Int, completion: @escaping (User?, ErrorMessage?) -> Void) {
        
    }
    
    
    //Helper Methods
    
    //Save JSON Web Token and Associated User
    private func saveCurrentUser(userId: Int, token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.token.rawValue)
        UserDefaults.standard.set(userId, forKey: UserDefaultsKeys.userId.rawValue)
    }
    
    
    let baseUrl = URL(string: "https://teleswapapi.herokuapp.com/api")!
    //let baseUrl = URL(string: "http://localhost:3000/api")!
}
