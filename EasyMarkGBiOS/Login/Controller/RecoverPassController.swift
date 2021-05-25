//
//  RecoverPassController.swift
//  remoteattendance
//
//  Created by Pinlet on 6/3/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit

class RecoverPassController: UIViewController{
    
    
    @IBOutlet weak var recoverEmailTxt: UITextField!
    @IBOutlet weak var recoverSuccIma: UIImageView!
    @IBOutlet weak var recoverFailIma: UIImageView!
    @IBOutlet weak var recoverSuccTxt: UILabel!
    @IBOutlet weak var recoverFailTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recoverExec(_ sender: Any) {
        
        print("Email for Recover: \(String(describing: recoverEmailTxt.text))")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "recover_pass_succ") as! RecoverPassController
        self.present(viewController, animated: false)
    }
    
    @IBAction func recoverBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "authentication") as! AuthController
        self.present(viewController, animated: false)
    }
    
    @IBAction func recoverSuccExec(_ sender: Any) {
        print("SALIO !!")
    }
    
    @IBAction func recoverSuccBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "recover_pass") as! RecoverPassController
        self.present(viewController, animated: false)
    }
    
}
