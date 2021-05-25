//
//  RegisterController.swift
//  remoteattendance
//
//  Created by Pinlet on 5/28/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Network

class RegisterController: UIViewController {
    
    @IBOutlet weak var capturedPicture: UIImageView!
    @IBOutlet weak var declineVw: UIView!
    @IBOutlet weak var captureVw: UIView!
    @IBOutlet weak var acceptVw: UIView!
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var captureBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    let myPhotographController = UIImagePickerController()
    var delegate: HomeControllerDelegate?
    var centerController: UIViewController!
    
    let colorPrimary = "#89c64d"
    let urlString = "http://192.81.132.98:8090/wsTechindCelular/registrarAsistencia"
    let alternateUrlStr = "http://www.pinlet.net/pinletapi/v1/registrarAsistencia"
    var url: URL!
    var date: Date!
    var imageData:NSData!
    var alertView: UIAlertController!
    var photograph = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        configureNavigationBar()
        url = URL(string: urlString)!
        date = Date()

        let declineTgr = UITapGestureRecognizer(target: self, action: #selector(declineTapped(tapGestureRecognizerDecline:)))
        declineVw.isUserInteractionEnabled = true
        declineVw.addGestureRecognizer(declineTgr)
        
        let declineTgrBtn = UITapGestureRecognizer(target: self, action: #selector(declineTapped(tapGestureRecognizerDecline:)))
        declineBtn.isUserInteractionEnabled = true
        declineBtn.addGestureRecognizer(declineTgrBtn)
        
        let captureTgr = UITapGestureRecognizer(target: self, action: #selector(captureTapped(tapGestureRecognizerCapture:)))
        captureVw.isUserInteractionEnabled = true
        captureVw.addGestureRecognizer(captureTgr)
        
        let captureTgrBtn = UITapGestureRecognizer(target: self, action: #selector(captureTapped(tapGestureRecognizerCapture:)))
        captureBtn.isUserInteractionEnabled = true
        captureBtn.addGestureRecognizer(captureTgrBtn)
        
        let acceptTgr = UITapGestureRecognizer(target: self, action: #selector(acceptTapped(tapGestureRecognizerAccept:)))
        acceptVw.isUserInteractionEnabled = true
        acceptVw.addGestureRecognizer(acceptTgr)
        
        let acceptTgrBtn = UITapGestureRecognizer(target: self, action: #selector(acceptTapped(tapGestureRecognizerAccept:)))
        acceptBtn.isUserInteractionEnabled = true
        acceptBtn.addGestureRecognizer(acceptTgrBtn)
    }

    @objc func declineTapped(tapGestureRecognizerDecline: UITapGestureRecognizer) {
        AppSettings.userPhotograph = ""
        let storyBoard : UIStoryboard = UIStoryboard(name: "Gps", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
        self.present(viewController, animated: false)
    }
    
    @objc func captureTapped(tapGestureRecognizerCapture: UITapGestureRecognizer) {
        managePhoto()
    }
    
    @objc func acceptTapped(tapGestureRecognizerAccept: UITapGestureRecognizer) {
        loadAttendanceRecord()
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

    
    
    @IBAction func throwBackScene(_ sender: Any) {
        AppSettings.userPhotograph = ""
        let storyBoard : UIStoryboard = UIStoryboard(name: "Gps", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
        self.present(viewController, animated: false)
    }
    

    func loadAttendanceRecord(){
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let formattedDate = format.string(from: self.date)
        let userTypeKey = getUserType()
        var userTypeID: String!
        var userTypeName: String!
        
        if userTypeKey.contains("e") {
            userTypeID = AppSettings.employeeId
            userTypeName = AppSettings.employeeId
        } else{
            userTypeID = AppSettings.userEnterpriseId
            userTypeName = AppSettings.userEnterpriseId
        }
        
        if NetworkReachabilityManager()!.isReachable {
            let connectionType =
                NetworkReachabilityManager()!.isReachableOnCellular ? "m": "w"
            let headerS = [
                   "Content-Type": "multipart/form-data"
               ]
            
            let optionBl = (AppSettings.optionsFlag as NSString).boolValue
            if optionBl {
                url = URL(string: alternateUrlStr)!
            } else{
                url = URL(string: urlString)!
            }
            
            if AppSettings.userPhotograph != "" {
                let httpHeaders = HTTPHeaders(headerS)
                let params: [String: String] = [
                   "cliente": "\(AppSettings.customerId)",
                   "movil": "\(AppSettings.mobileId)",
                   "tipo": userTypeKey,
                   "id": userTypeID,
                   "empleado": userTypeName,
                   "fecha_hora": formattedDate,
                   "evento": "1",
                   "foto": AppSettings.userPhotograph,
                   "latitud": AppSettings.latitude,
                   "longitud": AppSettings.longitude,
                   "conexion": connectionType
                ]
                
                AF.upload(multipartFormData: { multiPart in
                       for (key, value) in params {
                            multiPart.append(value.data(using: .utf8)!, withName: key)
                       }
                    
                }, to: self.url, headers: httpHeaders)
                   .uploadProgress(queue: .main, closure: { progress in
                       //Current upload progress of file
                       print("Upload Progress: \(progress.fractionCompleted)")
                       self.showProgressBarAlert(value: progress.fractionCompleted)
                   })
                   .responseJSON(completionHandler: { (response) in
                       print("RESPUESTA EXITO HTTP REQUEST.")
                       
                       guard let _ = response.response?.statusCode else {
                           //completion(.failure(""))
                           print("Error.")
                            return
                       }
                    
                       switch response.result {
                       case .success:
                           print("")
                           if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                               do {
                                   self.hideProgressAlert()
                                   let json = try JSON(data: (utf8Text.data(using: .utf8)!))
                                   let record:[String: Any] = (json["registrarAsistencia"].dictionaryObject!)
                                   let valueMark = record["respuesta"] as! Bool
                                   let fechaHora = record["fecha_hora"] as! String
                                   let messageMark = record["mensaje"] as! String
                                
                                   if valueMark == true {
                                      AppSettings.userPhotograph = ""
                                      print("Marcacion Exitosa.")
                                      let dateStr = messageMark + " " + fechaHora
                                      self.alertHttpResponse(message: dateStr)
                                      print("\(fechaHora)")
                                      print("\(messageMark)")
                                   } else {
                                      print("Marcacion Fallida.")
                                   }
                                
                               } catch let aError as NSError {
                                   print("Fallo JSON \(aError)")
                               }
                            }
                            
                       case .failure(_):
                            print("Fallo.")
                            print("NO HAY INTERNET !!! ")
                            print("NO HAY INTERNET !!! ")
                       }
                   })
                
            } else {
                showAlert(message: "No puede enviar marcación sin fotografia.")
            }

        } else {
            let params: [String: String] = [
               "cliente": "\(AppSettings.customerId)",
               "movil": "\(AppSettings.mobileId)",
               "tipo": userTypeKey,
               "id": userTypeID,
               "empleado": userTypeName,
               "fecha_hora": formattedDate,
               "evento": "1",
               "foto": AppSettings.userPhotograph,
               "latitud": AppSettings.latitude,
               "longitud": AppSettings.longitude,
               "conexion": "n"
            ]
            
            let noInternetMess = "Su marcacion se enviara cuando haya internet."
            var array = AppSettings.offlineMarks
            array.append(params)
            AppSettings.offlineMarks = array
            self.alertHttpResponse(message: noInternetMess)
        }
    }

    
    func getUserType() -> String {
        var userLoggedType: String!
        
        if AppSettings.employeeId == "0" {
            if AppSettings.userEnterpriseId == "0" {
                userLoggedType = "i"
            } else{
                userLoggedType = "u"
            }
        } else{
            if AppSettings.userEnterpriseId == "0" {
                userLoggedType = "e"
            } else{
               // EasyMarkSingleton.UsuEmpLoggedType = "e"
            }
        }
        return userLoggedType
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Información", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }

    
    func alertHttpResponse(message: String){
        let alert = UIAlertController(title: "Información", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Gps", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "gps_ini") as! Gps
            self.present(viewController, animated: false)
        }))
        self.present(alert, animated: true)
    }
    
    
    func showProgressBarAlert(value: Double){
        var progressView: UIProgressView!
        
        alertView = UIAlertController(title: "Espere por favor", message: "Procesando ...", preferredStyle: .alert)
        //  Show it to your users
        present(alertView, animated: true, completion: {
            //  Add your progressbar after alert is shown (and measured)
            let margin:CGFloat = 8.0
            let rect = CGRect(x: margin, y: 72.0, width: self.alertView.view.frame.width - margin * 2.0 , height: 2.0)
            progressView = UIProgressView(frame: rect)
            progressView!.progress = Float(value)
            progressView!.tintColor = self.view.tintColor
            self.alertView.view.addSubview(progressView!)
        })
    }
    
    func hideProgressAlert(){
        alertView.dismiss(animated: true, completion: nil)
    }
    
    
}


extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func managePhoto(){
        myPhotographController.delegate = self
        myPhotographController.allowsEditing = true
        myPhotographController.sourceType = .camera
        self.present(myPhotographController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        myPhotographController.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            capturedPicture.image = resizeImage(image: image)
            AppSettings.userPhotograph = imageToHexString(image: image)
        }
    }
    
    
    func getArrayOfBytesFromImage(imageData:NSData) -> NSMutableArray {
        let count = imageData.length / MemoryLayout<UInt8>.stride
        var bytes = [UInt8](repeating: 0, count: count)
        imageData.getBytes(&bytes, length:count * MemoryLayout<UInt8>.stride)
        let byteArray:NSMutableArray = NSMutableArray()

        for i in 0...(bytes.count-1) {
            byteArray.add(NSNumber(value: bytes[i]))
        }
        return byteArray
    }
    
    func intToHexString(intValue:Int) -> String {
        return String(format:"%02X", intValue)
    }
    
    func bytesConvertToHexstring(byte : [UInt8]) -> String {
        var string = ""
        for val in byte {
            string = string + String(format: "%02X", val)
        }
        return string
    }

    
    func imageToHexString(image: UIImage) -> String {
        //var mutString = ""
        let resizedImage = resizeImage(image: image)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)
        let array = getArrayOfBytesFromImage(imageData: imageData! as NSData)
        let byteArray : [UInt8] = array as! [UInt8]
        let hexStr = bytesConvertToHexstring(byte: byteArray)
        return hexStr
    }
    
    
    func resizeImage(image: UIImage) -> UIImage {
        let imgSrcWidth = image.size.width
        let imgSrcHeight = image.size.height
        var newSize: CGSize
        
        newSize = CGSize(width: imgSrcWidth/3, height: imgSrcHeight/3)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

}

struct Connectivity {
     static let sharedInstance = NetworkReachabilityManager()!
     static var isConnectedToInternet:Bool {
         return self.sharedInstance.isReachable
       }
}

