//
//  ReportsController.swift
//  EasyMarkGBiOS
//
//  Created by Pinlet on 7/23/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReportsController: UIViewController{
    
    var delegate: HomeControllerDelegate?
    let colorPrimary = "#89c64d"
    let reuseIdentifier = "reportsCell"
    //let url = "http://192.81.132.98:8090/wsTechindCelular/consultaMarcaciones"
    
    let urlString = "http://192.81.132.98:8090/wsTechindCelular/consultaMarcaciones"
    let alternateUrlStr = "http://www.pinlet.net/pinletapi/v1/consultaMarcaciones"
    var url: URL!
    
    @IBOutlet weak var infoReportLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var markReportLst : [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
        tableView.delegate = self
        tableView.dataSource = self
        configureNavigationBar()
        infoReportLbl.text = "Se muestran los últimos 10 registros"
        requestMarksReport()
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @IBAction func throwHomeScene(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "containerID") as! ContainerController
        self.present(viewController, animated: false)
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
                EasyMarkSingleton.UsuEmpLoggedType = "e"
            }
        }
        return userLoggedType
    }
    
    func reportsBody(bodyLst: [Any]) -> [String] {
        var reportLst = [""]
        for p in 0...(bodyLst.count-1){
            if let bodyItem = bodyLst[p] as? [String:Any]{
                if let markItem = bodyItem["marcacion"] as? String {
                    reportLst.append(markItem)
                }
            }
        }
        return reportLst
    }
    
    func requestMarksReport(){
        
        let userTypeKey = getUserType()
        var userTypeID: String!
        if userTypeKey.contains("e") {
            userTypeID = AppSettings.employeeId
        } else{
            userTypeID = AppSettings.userEnterpriseId
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

            let httpHeaders = HTTPHeaders(headerS)
            let params: [String: Any] = [
                "cliente": AppSettings.customerId,
                "tipo": userTypeKey,
                "movil": AppSettings.mobileId,
                "id": userTypeID!,
                "conexion": connectionType
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
                        return
                   }
                    switch response.result {
                    case .success:
                       print("")
                       if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                           do {
                               let json = try JSON(data: (utf8Text.data(using: .utf8)!))
                               let record = (json["consultaMarcaciones"].dictionaryObject!)
                               let auth = record["respuesta"] as! Bool
                               self.infoReportLbl.text = record["mensaje"] as? String
                               
                               if auth == true {
                                  if let marksLst = record["registros"] as? [String]{
                                     self.markReportLst = marksLst
                                     self.tableView.reloadData()
                                  } else{
                                     self.markReportLst = self.reportsBody(bodyLst: record["registros"] as! [Any])
                                    self.tableView.reloadData()
                                  }
                               } else {
                                  print("fallo consulta.")
                               }
                            
                           } catch let aError as NSError {
                               print("Fallo JSON \(aError)")
                           }
                        }
                    case .failure(_):
                       print("Fallo.")
                       
                   }
               })
            
        } else{
            print("No Hay Internet.")
        }
    }

}

extension ReportsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        markReportLst.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ReportCell
        cell.markReportLbl.text = markReportLst[indexPath.row]
        return cell
    }
    
    
}
