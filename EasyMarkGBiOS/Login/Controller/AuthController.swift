//
//  AuthController.swift
//  remoteattendance
//
//  Created by Pinlet on 6/3/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Network
import Reachability

class AuthController: UIViewController, UITextFieldDelegate {

    static var optionsFlag = false
    static var _iOSCODE = "2"
    @IBOutlet weak var enterpriseTxt: UITextField!
    @IBOutlet weak var cardIDTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!    
    //@IBOutlet weak var optionsPkv: UIPickerView!
    
    let colorPrimary = "#6200EE"
    let urlString = "http://192.168.0.103:8080/workspace_php/paysheet/public/api/login"
    let alternateUrlStr = "http://www.pinlet.net/pinletapi/v1/loginM"
    var url: URL!
    var optionsLst = [String()]
    var optionsFlagInt = 0
    //var monitor: NWPathMonitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        //url = URL(string: urlString)!
        self.enterpriseTxt.delegate = self
        self.cardIDTxt.delegate = self
        self.passwordTxt.delegate = self
        //self.optionsLst = ["Escoja una opción", "Opción 1", "Opción 2"]
       // self.optionsPkv.delegate = self
       // self.optionsPkv.dataSource = self
        configureNavigationBar()
    }

    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(false)
        if AppSettings.accessLog.contains("true"){
           throwGpsScene()
        }
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction func enterExec(_ sender: Any) {
      /*  if enterpriseTxt.text != "" && cardIDTxt.text != "" && passwordTxt.text != "" { */
                preAuthLogin(ruc: enterpriseTxt.text!, card: cardIDTxt.text!, pass: passwordTxt.text!)
                AppSettings.cardID = cardIDTxt.text!
                AppSettings.enterpriseRUC = enterpriseTxt.text!
                print("validado.")
                
          /*   } else {
                self.showAlertDialog(message: "Todos los campos son requeridos.")
             } */
    }
    
    
   // @IBAction func enterExec(_ sender: Any) {
       // throwMainScene()
        
        /*let pat = "\\b[a-z]{4,12}\\b"
        let testStr = "testeo"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.count))
        print("Hay \(matches.count) matches.")
         
         let pat = "\\[a-z]{2,12}\\g"
          let testStr = "holamundo"
          
          let regex = try! NSRegularExpression(pattern: pat, options: [])
         let matches = regex.matches(in: testStr, options: [], range:  NSRange(location: 0, length: testStr.count))
          
          print("Resultado \(matches) .")
          print("Hay \(matches.count) matches.")
         */

        /*let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in

            if path.status == .satisfied {
                print("Yay! We have internet!")
                if path.usesInterfaceType(.wifi) {
                    print("It's WiFi!")
                    AppSettings.connectionType = "w"
                } else if path.usesInterfaceType(.cellular) {
                    print("3G/4G FTW!!!")
                    AppSettings.connectionType = "m"
                }
                
            } else{
                print("We don't Have Internet Connection.")
            }
        }*/
        
        
    


       /* if enterpriseTxt.text == "1" {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "new_pass") as! ChangePassController
            self.present(viewController, animated: false)
        } else{
            throwMainScene()
        }*/

   // }
    
    
  /*  @IBAction func forgottenPassword(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "recover_pass") as! RecoverPassController
        self.present(viewController, animated: false)
    }*/
    
    func throwGpsScene(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Gps", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
        self.present(viewController, animated: false)
    }
    
    
    func showAlertDialog(message: String){
        let alert = UIAlertController(title: "Información", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    func preAuthLogin(ruc:String, card:String, pass:String){
       /* if self.optionsFlagInt == 3 {
            self.showAlertDialog(message: "Debe escoger una opción!")
        } else{
            if AuthController.optionsFlag {
                if ruc.count == 13{
                    let index = ruc.index(ruc.startIndex, offsetBy: 10)
                    let mySubstring = ruc[..<index]
                    if self.isValidCardID(cardId: card) && self.isValidCardID(cardId: String(mySubstring)){
                        self.authLogin(ruc: ruc, card: card, pass: pass)
                    } else{
                        self.showAlertDialog(message: "Cédula y RUC deben ser válidos.")
                    }
                } else{
                    self.showAlertDialog(message: "Cédula y RUC deben ser válidos.")
                }
            } else{
                //AppSettings.optionsFlag = String("false")
                self.authLogin(ruc: ruc, card: card, pass: pass)
            }
        }*/
        self.authLogin(ruc: ruc, card: "", pass: "")
    }

 
    func authLogin(ruc:String, card:String, pass:String){
        
        if NetworkReachabilityManager()!.isReachable {
            let connectionType = NetworkReachabilityManager()!.isReachableOnCellular ? "m": "w"
            url = URL(string: urlString)!
            
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                let headerS = [
                       "Content-Type": "multipart/form-data"
                ]
                   
                let httpHeaders = HTTPHeaders(headerS)
                let params: [String: Any] = [
                       "email": "0923388284",
                       "password": "123456"
                ]
                   
                AF.upload(multipartFormData: { multiPart in
                       for (key, value) in params {
                           if let temp = value as? String {
                               multiPart.append(temp.data(using: .utf8)!, withName: key)
                           }
                           if let temp = value as? Int {
                               multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                           }
                           if let temp = value as? NSArray {
                               temp.forEach({ element in
                                   let keyObj = key + "[]"
                                   if let string = element as? String {
                                       multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                                   } else
                                       if let num = element as? Int {
                                           let value = "\(num)"
                                           multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                                   }
                               })
                           }
                       }
                    
                   }, to: url, headers: httpHeaders)
                   .uploadProgress(queue: .main, closure: { progress in
                       //Current upload progress of file
                       print("Upload Progress: \(progress.fractionCompleted)")
                   })
                   .responseJSON(completionHandler: { (response) in
                       print("RESPUESTA EXITO HTTP REQUEST.")
                       
                       guard let _ = response.response?.statusCode else {
                           //completion(.failure(""))
                           print("Error.")
                            self.showAlertDialog(message: "El servidor devolvió un error.")
                            return
                       }
                        switch response.result {
                        case .success:
                           if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                               do {
                                   let json = try JSON(data: (utf8Text.data(using: .utf8)!))
                                   let success = (json["success"].rawString())
                                   AppSettings.accessMessage = (json["message"].rawString()!)
                                
                                   if (success! as NSString).boolValue == true {
                                        let innerData: [String:Any] = (json["data"].dictionaryObject!)
                                        let token = innerData["token"] as! String
                                        AppSettings.fcmToken = token
                                        AppSettings.accessLog = "true"
                                   } else {
                                       self.showAlertDialog(message: AppSettings.accessMessage)
                                   }
                            
                                    self.throwGpsScene()
                                
                               } catch let aError as NSError {
                                   print("Fallo JSON \(aError)")
                               }
                            }
                        case .failure(_):
                            self.showAlertDialog(message: "El servidor devolvió una respuesta fallida.")
                           
                       }
                   })
            } else{
                print("Su dispositivo debe poseer un UUID.")
                self.showAlertDialog(message: "Su dispositivo debe poseer un UUID.")
            }
        } else {
            print("No hay conexion a internet.")
            self.showAlertDialog(message: "Debe tener internet para autenticarse.")
        }
    }
    
    func isValidCardID(cardId: String) -> Bool {
        var validCardID = false
        var digito = 0
        var suma = 0
        
        if cardId.count == 10 {
            let thirdDigitStr = self.getCardSubStr(originStr: cardId, position: 3)
            if let thirdDigit = Int(thirdDigitStr) {
                if(Int(thirdDigit) < 6){
                    let coefValCedula = [2, 1, 2, 1, 2, 1, 2, 1, 2];
                    let tenDigit = self.getCardSubStr(originStr: cardId, position: 10)
                    
                    for p in 0...(cardId.count-2){
                        if let cursor = Int(self.getCardSubStr(originStr: cardId, position: (p+1))){
                            digito = cursor * coefValCedula[p]
                            suma += ((digito%10) + (digito/10))
                        }
                    }

                    if((suma%10 == 0) && (suma%10 == Int(tenDigit))){
                        validCardID = true
                    } else if((10 - (suma%10)) == Int(tenDigit)){
                        validCardID = true
                    } else{
                        validCardID = false
                    }
                }
            }
        }
        return validCardID
    }
    
    func getCardSubStr(originStr: String, position: Int) -> String {
        let start = originStr.index(originStr.startIndex, offsetBy: (position-1))
        let end = originStr.index(originStr.endIndex, offsetBy: (position-originStr.count))
        let range = start..<end
        let mySubstring = originStr[range]
        return String(mySubstring)
    }
    
}

/*extension AuthController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.optionsLst.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.optionsLst[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch self.optionsLst[row] {
        case "Opción 1":
            AuthController.optionsFlag = false
            AppSettings.optionsFlag = String("false")
            self.optionsFlagInt = 1
        case "Opción 2":
            AuthController.optionsFlag = true
            AppSettings.optionsFlag = String("true")
            self.optionsFlagInt = 2
        default:
            self.optionsFlagInt = 3
        }
    }
}*/
