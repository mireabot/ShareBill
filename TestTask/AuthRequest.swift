//
//  AuthRequest.swift
//  TestTask
//
//  Created by Mikhail Kolkov  on 25.02.2021.
//

import Foundation
import SwiftUI
import Combine


class Auth : ObservableObject {
    
    var didChange = PassthroughSubject<Auth, Never>()
    
    @Published var isCorrect : Bool = true
    @Published var isLoggedIn : Bool = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func checkin(password: String, email: String){
        guard let url = URL(string: "https://api-qa.mvpnow.io/v1/sessions") else {
            return
        }
        
        let body: [String : String] = ["password": password, "email": email]
        
        guard let finalBody = try? JSONEncoder().encode(body) else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {return}
            
            let result = try? JSONDecoder().decode(User.self, from: data)
            
            if let result = result {
                DispatchQueue.main.async {
                    self.isCorrect = true
                    print("OKKKK")
                }
            } else {
                DispatchQueue.main.async {
                    self.isCorrect = false
                    print("NOPE")
                }
            }
        }.resume()
    }
}
