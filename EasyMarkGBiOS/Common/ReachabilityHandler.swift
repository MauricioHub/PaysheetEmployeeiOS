//
//  ReachabilityHandler.swift
//  EasyMarkGBiOS
//
//  Created by Pinlet on 7/22/20.
//

import UIKit
import Foundation
import Reachability
import SystemConfiguration

class ReachabilityHandler {
  
    let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
  //MARK: Lifecycle
    
    init() {
        var address = sockaddr_in()
        address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        address.sin_family = sa_family_t(AF_INET)
        // Passes the reference of the struct
        let reachability = withUnsafePointer(to: &address, { pointer in
            // Converts to a generic socket address
            return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
                // $0 is the pointer to `sockaddr`
                return SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        })
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        
        let isReachable: Bool = flags.contains(.reachable)
    }
    
    
    func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    

    func connectionTypeAvailable() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com") else { return "n"}
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        if !isNetworkReachable(with: flags) {
            // Device doesn't have internet connection
            return "n"
        }
        #if os(iOS)
            // It's available just for iOS because it's checking if the device is using mobile data
            if flags.contains(.isWWAN) {
                // Device is using mobile data
                return "m"
            }
        #endif
        return "w"
    }
    
    
    
 /* required init() {
    try? addReachabilityObserver()
  }
  
  deinit {
    removeReachabilityObserver()
  }
  
  //MARK: Reachability
    
  func reachabilityChanged(_ isReachable: Bool) -> Bool {
    if !isReachable {
        print("No internet connection")
        return false
    } else{
        return true
    }
  }*/

}
