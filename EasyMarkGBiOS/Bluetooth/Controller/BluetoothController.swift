//
//  BluetoothController.swift
//  remoteattendance
//
//  Created by Pinlet on 6/5/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit

class BluetoothController: UIViewController {
    
    var delegate: HomeControllerDelegate?
    let colorPrimary = "#89c64d"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        configureNavigationBar()
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
