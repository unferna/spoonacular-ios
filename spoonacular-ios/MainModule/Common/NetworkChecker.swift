//
//  NetworkChecker.swift
//  spoonacular-ios
//
//  Created by Fernando Florez on 21/11/22.
//

import Foundation
import Network

class NetworkChecker {
    let monitor: NWPathMonitor!
    var isConnected: Bool = true
    var isShowingMessage = false
    var wasUnconnected = false
    
    static var defaults = NetworkChecker()
    private var screenDelegates = MulticastDelegate<NetworkCheckerDelegate>()
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                // Notify is connected
                print("Connected")
                defer {
                    self?.isConnected = true
                    self?.wasUnconnected = false
                }
                
                let unconnected = self?.wasUnconnected ?? false
                self?.screenDelegates.invokeDelegates {
                    $0.networkConnection(connected: true, wasUnconnected: unconnected)
                }
            
            } else if path.status == .unsatisfied {
                // Notify isn't connected
                print("There are no connections")
                
                defer {
                    self?.isConnected = false
                    self?.wasUnconnected = true
                }
                
                let unconnected = self?.wasUnconnected ?? false
                self?.screenDelegates.invokeDelegates {
                    $0.networkConnection(connected: false, wasUnconnected: unconnected)
                }
            }
        }
    }
    
    func start() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier, !bundleIdentifier.isEmpty else { return }
        
        let queue = DispatchQueue(label: "\(bundleIdentifier).network.monitor")
        monitor.start(queue: queue)
    }
    
    func registerDelegate(delegate: NetworkCheckerDelegate) {
        screenDelegates.addDelegate(delegate)
    }
    
    func removeDelegate(delegate: NetworkCheckerDelegate) {
        screenDelegates.removeDelegate(delegate)
    }
}

protocol NetworkCheckerDelegate: AnyObject {
    func networkConnection(connected: Bool, wasUnconnected: Bool)
}
