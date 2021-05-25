//
//  Bluetooth.swift
//  remoteattendance
//
//  Created by Pinlet on 6/4/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit

class Bluetooth: UIViewController{
    
    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        configureBluetoothController()
    }
    
    
    func configureBluetoothController(){
        let bluetoothController = UIStoryboard(name: "Bluetooth", bundle: nil).instantiateViewController(withIdentifier: "bluetoothVCID") as! BluetoothController
        bluetoothController.delegate = self
        centerController = UINavigationController(rootViewController: bluetoothController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    
    func throwGpsScene(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Gps", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
        self.present(viewController, animated: false)
    }
    
    func throwClosedSession(){
        AppSettings.accessLog = "\(false)"
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "authentication") as! AuthController
        let centerController = UINavigationController(rootViewController: viewController)
        self.present(centerController, animated: false)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    
    func throwReportsScene(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "reportsID") as! Reports
        self.present(viewController, animated: false)
    }
    
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
            
        } else {
            // hide menu
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        
        animateStatusBar()
    }
    
    
    func didSelectMenuOption(menuOption: MenuOption) {
        switch menuOption {
        case .Gps:
            throwGpsScene()
       /* case .Bluetooth:
            print("Show Bluetooth")*/
        case .Reporte:
            throwReportsScene()
        case .Cierre:
            throwClosedSession()
        }
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
}

extension Bluetooth: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
