//
//  ViewModel.swift
//  Store
//
//  Created by SCT on 26/05/24.
//

import Foundation
import CoreData
import UIKit

class DashboardViewModel: NSObject {
    
    var dashboardModel : DashboardModel?
    
//    private(set) var dashboardModel : DashboardModel
    
    override init() {
        super.init()
    }
    
    convenience init( model: DashboardModel) {
        self.init()
        self.dashboardModel = model
    }
    
    func fetchDBData(completion: @escaping (Error?) -> Void) {
            let urlString = "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"
            
            guard let url = URL(string: urlString) else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                completion(error)
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(error)
                    return
                }
                do {

                    let decoder = JSONDecoder()
                    
                    self.dashboardModel = try decoder.decode(DashboardModel.self, from: data)
                    if let model = self.dashboardModel {
                        CoreDataHandler.shared.saveDashboardModel(model)
                    }

//                    self.dashboardModel?.products?.forEach {$0.store()}
//                    self.dashboardModel?.category?.forEach {$0.store()}
                    completion(nil)
                } catch {
                    print(error)
                    completion(error)
                }
            }.resume()
        }
        
}


