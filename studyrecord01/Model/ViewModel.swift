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
    @Published var timerecords = [TimerecordModel]()
    @Published var durations = [DurationModel]()
    
    let prefixURL = "https://node.momsy.co.kr"
    
    init() {
        fetchPost()
        fetchTable()
        sumDuration()
    }
    
    func refresh() {
        fetchPost()
        fetchTable()
        sumDuration()
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

    func loginInfo(parameters: [String: Any]) -> Bool {
        guard let url = URL(string: "\(prefixURL)/login") else {
            print("Not Found URL")
            return false
        }
        
        let data = try! JSONSerialization.data(withJSONObject: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let semaphore = DispatchSemaphore(value: 0)
        var success = false
        
        URLSession.shared.dataTask(with: request) { (data, res, error) in
            if let error = error {
                print("error", error.localizedDescription)
                semaphore.signal()
                return
            }
            
            do {
                if let data = data {
                    let result = try JSONDecoder().decode(apikeyModel.self, from: data)
                    let value = result.apikey
                    print(result)
                    print(value)
                    UserDefaults.standard.set(value, forKey: "apikey")
                    success = true
                } else {
                    print("No Data")
                }
            } catch let jsonError {
                print("fetch json error:", jsonError.localizedDescription)
            }
            semaphore.signal()
        }.resume()
        
        semaphore.wait()
        return success
    }
    
    // MARK: - Login async
//    func loginInfo(parameters: [String: Any], completion: @escaping () -> Void)  {
//    //    func createPost(parameters: [String: Any]) {
//        guard let url = URL(string: "\(prefixURL)/login") else {
//            print("Not Found URL")
//            return
//        }
//        
//        let data = try! JSONSerialization.data(withJSONObject: parameters)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = data
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        URLSession.shared.dataTask(with: request) { (data, res, error) in
//            if(error != nil) {
//                print("error", error?.localizedDescription ?? "")
//                return
//            }
//            
//            do {
//                if let data = data {
//                    let result = try JSONDecoder().decode(apikeyModel.self,from: data)
//                    DispatchQueue.main.async {
//                        let value = result.apikey
//                        print(result)
//                        print(value)
//                        UserDefaults.standard.set(value, forKey: "apikey")
//                    }
//                    
//                    
//                } else {
//                    print("No Data")
//                }
//            completion()
//            } catch let JsonError {
//                print("fetch json error:", JsonError.localizedDescription)
//            }
//        }.resume()
//    }
    
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
    
    
    //MARK: - retrieve table

    func fetchTable() {
        guard let url = URL(string: "\(prefixURL)/fetchtable") else {
            print("Not Found URL")
            return
        }
        
        let email = UserDefaults.standard.string(forKey: "email")
        let apikey = UserDefaults.standard.string(forKey: "apikey")
        
        let parameters: [String: Any] = [ "email": email ?? "", "apikey": apikey ?? ""]
        
        

        // 새로운 값 추가
//        updatedParameters["email"] = email ?? ""
//        updatedParameters["apikey"] = apikey ?? ""
        
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
                    let result = try JSONDecoder().decode(TRDataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.timerecords = result.data
                    }
                } else {
                    print("No Data")
                }
                    
            } catch let JsonError {
                print("fetch json error:", JsonError.localizedDescription)
            }
        }.resume()
    }

    //MARK: - sum duration

    func sumDuration() {
        guard let url = URL(string: "\(prefixURL)/sumduration") else {
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
                    let result = try JSONDecoder().decode(DRDataModel.self, from: data)
                    DispatchQueue.main.async {
                        self.durations = result.data
                        print(result.data)
                    }
                    
                } else {
                    print("No Data")
                }
                    
            } catch let JsonError {
                print("sumduration fetch json error:", JsonError.localizedDescription)
                print(data)
            }
        }.resume()
    }

    
    //MARK: - Create timerecord
    func createTimerecord(parameters: [String: Any], completion: @escaping () -> Void) {
    //    func createPost(parameters: [String: Any]) {
        guard let url = URL(string: "\(prefixURL)/createTimerecord") else {
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
}
