//
//  ViewModel.swift
//  studyrecord01
//
//  Created by Min Lee on 8/14/24.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    @Published var items = [PostModel]()
    
    let prefixURL = "https://node.momsy.co.kr"
    
    init() {
        fetchPost()
    }
    
    
    //MARK: - retrieve data

    func fetchPost() {
        guard let url = URL(string: "\(prefixURL)/posts") else {
            print("Not Found URL")
            return
        }
        
        let email = UserDefaults.standard.string(forKey: "email")
        let apikey = UserDefaults.standard.string(forKey: "apikey")
        
        let parameters: [String: Any] = [ "email": email ?? "", "apikey": apikey ?? ""]
        
        let data = try! JSONSerialization.data(withJSONObject: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if(error != nil) {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(DataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.items = result.data
                    }
                } else {
                    print("No Data")
                }
                    
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }

    
    //MARK: - Create data
    func createPost(parameters: [String: Any], completion: @escaping () -> Void) {
    //    func createPost(parameters: [String: Any]) {
        guard let url = URL(string: "\(prefixURL)/createPost") else {
            print("Not Found URL")
            return
        }
        
        let email = UserDefaults.standard.string(forKey: "email")
        let apikey = UserDefaults.standard.string(forKey: "apikey")
        
        var updatedParameters = parameters

        // 새로운 값 추가
        updatedParameters["email"] = email ?? ""
        updatedParameters["apikey"] = apikey ?? ""
        
        let data = try! JSONSerialization.data(withJSONObject: updatedParameters)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if(error != nil) {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(DataModel.self,from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No Data")
                }
            completion()
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - Update data
    func updatePost(parameters: [String: Any], completion: @escaping () -> Void) {
        guard let url = URL(string: "\(prefixURL)/updatePost") else {
            print("Not Found URL")
            return
        }
        
        let email = UserDefaults.standard.string(forKey: "email")
        let apikey = UserDefaults.standard.string(forKey: "apikey")
        
        var updatedParameters = parameters

        // 새로운 값 추가
        updatedParameters["email"] = email ?? ""
        updatedParameters["apikey"] = apikey ?? ""
        
        let data = try! JSONSerialization.data(withJSONObject: updatedParameters)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if(error != nil) {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(DataModel.self,from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No Data")
                }
            completion()
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }
    
    
    //MARK: - Login
    func loginInfo(parameters: [String: Any]) {
    //    func createPost(parameters: [String: Any]) {
        guard let url = URL(string: "\(prefixURL)/login") else {
            print("Not Found URL")
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if(error != nil) {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(apikeyModel.self,from: data)
                    DispatchQueue.main.async {
                        let value = result.apikey
                        print(result)
                        print(value)
                        UserDefaults.standard.set(value, forKey: "apikey")
                    }
                    
                    
                } else {
                    print("No Data")
                }
            
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: - Delete data
    func deletePost(parameters: [String: Any], completion: @escaping () -> Void) {
        guard let url = URL(string: "\(prefixURL)/deletePost") else {
            print("Not Found URL")
            return
        }
        
        let email = UserDefaults.standard.string(forKey: "email")
        let apikey = UserDefaults.standard.string(forKey: "apikey")
        
        var updatedParameters = parameters

        // 새로운 값 추가
        updatedParameters["email"] = email ?? ""
        updatedParameters["apikey"] = apikey ?? ""
        
        let data = try! JSONSerialization.data(withJSONObject: updatedParameters)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if(error != nil) {
                print("error", error?.localizedDescription ?? "")
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(DataModel.self,from: data)
                    DispatchQueue.main.async {
                        print(result)
                    }
                } else {
                    print("No Data")
                }
            completion()
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }
}
