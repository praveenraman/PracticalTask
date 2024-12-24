//
//  NetworkManager.swift
//  Practical Task
//
//  Created by Praveen Kumar on 24/12/24.
//

import Foundation
import Reachability

enum DemoError: Error {
    case BadUrl
    case NoData
    case DecodingError
}

class APIManager {
    
    let apiHandler: APIHandler
    let responseHandler: ResponseHandler
    
    init(apiHandler: APIHandler = APIHandler(), responseHandler: ResponseHandler = ResponseHandler()) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func getApiData<T: Decodable>(url: URL, type: T.Type, completion: @escaping(Result<T, DemoError>) -> Void){
        apiHandler.getApiResponse(url: url) { result in
            switch result {
            case .success(let data):
                self.responseHandler.getResponse(type: type, data: data) { deCodedata in
                    switch deCodedata {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(let error):
                         completion(.failure(error))
                    }
                }
            case .failure(let error):
                 completion(.failure(error))
            }
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private var reachability: Reachability?

    private init(){
        do {
            reachability = try Reachability()
        } catch {
            print("Unable to initialize Reachability: \(error.localizedDescription)")
        }
    }

    func startMonitoring() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc private func networkStatusChanged(notification: Notification) {
        guard let reachability = notification.object as? Reachability else { return }
        switch reachability.connection {
        case .wifi:
            print("Network reachable via WiFi")
        case .cellular:
            print("Network reachable via Cellular")
        case .unavailable:
            print("Network unavailable")
        case .none:
            print("No network connection")
        }
    }

    func stopMonitoring() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    func isNetworkAvailable() -> Bool {
        return reachability?.connection != .unavailable
    }
}
