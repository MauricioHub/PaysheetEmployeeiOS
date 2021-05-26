//
//  SplashViewController.swift
//  EasyMarkGBiOS
//
//  Created by Jorge Guzman on 5/26/21.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello World.")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if AppSettings.accessLog == "true"{
            sleep(2)
            let storyBoard = UIStoryboard(name: "Gps", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
            self.present(controller, animated: true, completion: nil)
        } else{
            DispatchQueue.main.async {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "authentication") as! AuthController
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
}
