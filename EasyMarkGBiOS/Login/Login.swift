//
//  Login.swift
//  remoteattendance
//
//  Created by Pinlet on 5/28/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//


import UIKit
import Alamofire

class Login: UIViewController {    
    
    var delegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } 
        //configureNavigationBar()
    }
    
    
    @IBAction func confirmLogin(_ sender: Any) {
        throwMenuScene()
    }
    
    func throwMenuScene(){
        
        /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "containerID") as! ContainerController*/
        // viewController.handleMenuItem(item:"maps")
        //let centerController = UINavigationController(rootViewController: viewController)
       // self.present(viewController, animated: false)
        
        /*let loginController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "containerID") as! ContainerController

                let loginController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "login_ini") as! Login
        //loginController.delegate = self
        centerController = UINavigationController(rootViewController: loginController)*/

    }
    
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Side Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu_white_3x").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }

    
    
    func doHttpLogin(ent:String, cdi:String, pwd:String) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
                     ]
        
        let parameters = [
                        "conjunto": "1",
                        "usuario": "mauricio.guzman@pinlet.net",
                        "password": "P1nl3t2019@",
                        "tokenfirebase": "e3kP0I4YGhM:APA91bFEqVrs7NZ_2qGt9qAi0w2XHX0XWYBmTmDn2M8dsaKfERIBLFPRGRMzkUxhWruO42zFFjUGoHhQRbboymLStynDEOc6ex5Qw51bq-TosLvb4dnDwtS4W_Q1vSMscSM1MaVAv5ZT"
                     ]
        
        AF.request("https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/login", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .responseJSON {
            response in
                
            DispatchQueue.main.async {
                    
            switch response.result {
            case .success(let value):
                    print("Exito. Response")
                    if let JSON = value as? [String: Any] {
                        let itemForm = JSON["noticias"]!
                        print("Salio respuesta. \(itemForm)")
                    }
                    
            case .failure(let error):
                    print(error.errorDescription ?? "")
                    break
                    // error handling
            }}
            
        }
        
    }
    
}
