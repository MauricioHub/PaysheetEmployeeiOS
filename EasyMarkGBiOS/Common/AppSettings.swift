//
//  AppSettings.swift
//  remoteattendance
//
//  Created by Pinlet on 6/19/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import Foundation
import UIKit

//MARK: User Settings
@objc protocol AppSettingsConfigurable {
    
    //MARK: - get set INTS
    static var fcmToken : String { get set }
    static var enterpriseRUC : String { get set }
    static var cardID : String { get set }
    static var password : String { get set }
    static var accessLog : String { get set }
    static var accessTimeLog : String { get set }
    static var accessMessage : String { get set }
    static var employeeId : String { get set }
    static var employeeName : String { get set }
    static var customerId : String { get set }
    static var customerName : String { get set }
    static var mobileId : String { get set }
    static var userEnterpriseId : String { get set }
    static var userEnterpriseName : String { get set }
    static var connectionType: String { get set }
    static var latitude : String { get set }
    static var longitude : String { get set }
    static var userPhotograph : String { get set }
    static var optionsFlag : String { get set }
    static var offlineMarks : Array<[String: String]> { get set }
}

class AppSettings: NSObject {
    
    fileprivate static func updateDefaults(for key: String, value: Any) {
        // Save value into UserDefaults
        UserDefaults.standard.set(value, forKey: key)
    }
    
    fileprivate static func value<T>(for key: String) -> T? {
        // Get value from UserDefaults
        return UserDefaults.standard.value(forKey: key) as? T
    }
}

extension AppSettings: AppSettingsConfigurable {
    
    //MARK: - get set INTS
    static var fcmToken: String {
        get { return AppSettings.value(for: #keyPath(fcmToken)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(fcmToken), value: newValue)
            }
    }
    
    static var enterpriseRUC: String {
        get { return AppSettings.value(for: #keyPath(enterpriseRUC)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(enterpriseRUC), value: newValue)
            }
    }
    
    static var cardID: String {
        get { return AppSettings.value(for: #keyPath(cardID)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(cardID), value: newValue)
            }
    }
    
    static var password: String {
        get { return AppSettings.value(for: #keyPath(password)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(password), value: newValue)
            }
    }
    
    static var accessLog: String {
        get { return AppSettings.value(for: #keyPath(accessLog)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(accessLog), value: newValue)
            }
    }
    
    static var accessTimeLog: String {
        get { return AppSettings.value(for: #keyPath(accessTimeLog)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(accessTimeLog), value: newValue)
            }
    }
    
    static var accessMessage: String {
        get { return AppSettings.value(for: #keyPath(accessMessage)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(accessMessage), value: newValue)
            }
    }
    
    static var employeeId: String {
        get { return AppSettings.value(for: #keyPath(employeeId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(employeeId), value: newValue)
            }
    }
    
    static var employeeName: String {
        get { return AppSettings.value(for: #keyPath(employeeName)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(employeeName), value: newValue)
            }
    }
    
    static var customerId: String {
        get { return AppSettings.value(for: #keyPath(customerId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(customerId), value: newValue)
            }
    }
    
    static var mobileId: String {
        get { return AppSettings.value(for: #keyPath(mobileId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(mobileId), value: newValue)
            }
    }
    
    static var customerName: String {
        get { return AppSettings.value(for: #keyPath(customerName)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(customerName), value: newValue)
            }
    }
    
    static var userEnterpriseId: String {
        get { return AppSettings.value(for: #keyPath(userEnterpriseId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(userEnterpriseId), value: newValue)
            }
    }
    
    static var userEnterpriseName: String {
        get { return AppSettings.value(for: #keyPath(userEnterpriseName)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(userEnterpriseName), value: newValue)
            }
    }

    static var connectionType: String {
        get { return AppSettings.value(for: #keyPath(connectionType)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(connectionType), value: newValue)
            }
    }
    
    static var latitude: String {
        get { return AppSettings.value(for: #keyPath(latitude)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(latitude), value: newValue)
            }
    }
    
    static var longitude: String {
        get { return AppSettings.value(for: #keyPath(longitude)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(longitude), value: newValue)
            }
    }
    
    static var userPhotograph: String {
        get { return AppSettings.value(for: #keyPath(userPhotograph)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(userPhotograph), value: newValue)
            }
    }
    
    static var optionsFlag: String {
        get { return AppSettings.value(for: #keyPath(optionsFlag)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(optionsFlag), value: newValue)
            }
    }
    
    static var offlineMarks: Array<[String : String]> {
        get { return AppSettings.value(for: #keyPath(offlineMarks)) ?? Array<[String : String]>() }
        set { AppSettings.updateDefaults(for: #keyPath(offlineMarks), value: newValue)
            }
    }
    
}
