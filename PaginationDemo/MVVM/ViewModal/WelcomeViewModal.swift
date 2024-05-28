//
//  WelcomeViewModal.swift
//  PaginationDemo
//
//  Created by shree on 28/05/24.
//

import Foundation

class WelcomeViewModal {
    
    var objWelCome : [WelcomeElement] = [WelcomeElement]()
    
    var eventHandler : ((_ event : HomeWelcome) -> Void)?

    func fetchProduct(){
        
        let dict = ["_page" : "\(MyVariables.pageCount)", "_limit" : "\(MyVariables.limitCount)"]
        self.eventHandler?(.loadIndicator)
        ApiHandler.shared.apiCall(urlStr: Constant.baseUrl, method: HTTPMethod.get, param: dict) { (result: Result<[WelcomeElement], ApiError>) in
            
            print("response view Moadal -", result)
            switch result {
            case .success(let response) :
                print("View Model Product -", response)
                self.objWelCome.append(contentsOf: response)
                self.eventHandler?(.loadData)
            case .failure(let error) :
                print("error - ", error)
                self.eventHandler?(.error(error))
                
            }
        }
    }
}

extension WelcomeViewModal{
    enum HomeWelcome {
        
        case loadIndicator
        case stopIndicator
        case loadData
        case error(Error?)
    }
}
