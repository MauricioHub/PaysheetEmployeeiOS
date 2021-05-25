//
//  ChangePassController.swift
//  remoteattendance
//
//  Created by Pinlet on 6/3/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit

class ChangePassController: UIViewController{
    
    @IBOutlet weak var newPassTxt: UITextField!
    @IBOutlet weak var newPassConfirmTxt: UITextField!
    @IBOutlet weak var dataEnterpriseTxt: UITextField!
    @IBOutlet weak var dataCardIDTxt: UITextField!
    @IBOutlet weak var dataNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var dataPhoneTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func newPassExec(_ sender: Any) {
        
        print("New Password: \(String(describing: newPassTxt.text))")
        print("New Password Confirm: \(String(describing: newPassConfirmTxt.text))")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "login_confirm_datos") as! ChangePassController
        self.present(viewController, animated: false)
    }
    
    @IBAction func newPassBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "authentication") as! AuthController
        self.present(viewController, animated: false)
    }
    
    @IBAction func confirmDataExec(_ sender: Any) {
        
        print("Enterprise: \(String(describing: dataEnterpriseTxt.text))")
        print("Card ID: \(String(describing: dataCardIDTxt.text))")
        print("Name: \(String(describing: dataNameTxt.text))")
        print("Email: \(String(describing: emailTxt.text))")
        print("Phone: \(String(describing: dataPhoneTxt.text))")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "login_load_pic") as! ChangePassController
        self.present(viewController, animated: false)
    }
    
    @IBAction func confirmDataBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "new_pass") as! ChangePassController
        self.present(viewController, animated: false)
    }
    
    @IBAction func loadPicExec(_ sender: Any) {
        print("SALIO !!")

    }
    
    @IBAction func loadPicBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "login_confirm_datos") as! ChangePassController
        self.present(viewController, animated: false)
    }
}
