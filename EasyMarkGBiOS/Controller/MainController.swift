//
//  MainController.swift
//  remoteattendance
//
//  Created by Pinlet on 6/17/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit
import Reachability
import Alamofire

class MainController: UIViewController{

    @IBOutlet weak var registerImg: UIImageView!
    @IBOutlet weak var reportsImg: UIImageView!
    @IBOutlet weak var settingsImg: UIImageView!
        
    let colorPrimary = "#89c64d"
    var delegate: HomeControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        configureNavigationBar()
        
        let registerTgr = UITapGestureRecognizer(target: self, action: #selector(registerTapped(tapGestureRecognizerRegister:)))
        registerImg.isUserInteractionEnabled = true
        registerImg.addGestureRecognizer(registerTgr)
        
        let reportsTgr = UITapGestureRecognizer(target: self, action: #selector(reportsTapped(tapGestureRecognizerReports:)))
        reportsImg.isUserInteractionEnabled = true
        reportsImg.addGestureRecognizer(reportsTgr)
        
        let settingsTgr = UITapGestureRecognizer(target: self, action: #selector(settingsTapped(tapGestureRecognizer:)))
        settingsImg.isUserInteractionEnabled = true
        settingsImg.addGestureRecognizer(settingsTgr)
    }

    
    @objc func registerTapped(tapGestureRecognizerRegister: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Gps", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
        self.present(viewController, animated: false)
    }
    
    @objc func reportsTapped(tapGestureRecognizerReports: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Reports", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "reportsID") as! Reports
        self.present(viewController, animated: false)
    }
    
    @objc func settingsTapped(tapGestureRecognizer: UITapGestureRecognizer) {
       /* let storyBoard : UIStoryboard = UIStoryboard(name: "Bluetooth", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "bluetoothID") as! Bluetooth
        self.present(viewController, animated: false)*/
    }
    
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(hexString: colorPrimary)
        navigationController?.navigationBar.barStyle = .black

        let titleBarLbl: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 21)
            label.text = "Reloj Online"
            return label
        }()
        navigationItem.titleView = titleBarLbl
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }    
}


