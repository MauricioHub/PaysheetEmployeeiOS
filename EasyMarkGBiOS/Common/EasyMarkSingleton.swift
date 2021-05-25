//
//  EasyMarkSingleton.swift
//  EasyMarkGBiOS
//
//  Created by Pinlet on 7/19/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import Network
import Reachability

class EasyMarkSingleton: UIViewController{
    
    let urlString = "http://192.81.132.98:8090/wsTechindCelular/registrarAsistencia"
    static var url = URL(string: "http://192.81.132.98:8090/wsTechindCelular/registrarAsistencia")
    static var nMarks = 0
    static var UsuEmpLoggedType : String!
    static var offlineMarksGlobal : Array<[String: String]>!
    //var monitor: NWPathMonitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*monitor = NWPathMonitor()
        //url = URL(string: urlString)
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)*/
    }
    
    
    static func loadAttendanceRecord(dictMark: [String: String]){

        //let dictMarksArray = AppSettings.offlineMarks
        
       // for dictMark in dictMarksArray {
        
        let headerS = [
               "Content-Type": "multipart/form-data"
           ]
        let httpHeaders = HTTPHeaders(headerS)
        let params: [String: Any] = [
           "cliente": dictMark["cliente"]!,
           "movil": dictMark["movil"]!,
           "tipo":dictMark["tipo"]!,
           "id": dictMark["id"]!,
           "empleado": dictMark["empleado"]!,
           "fecha_hora": dictMark["fecha_hora"]!,
           "evento": dictMark["evento"]!,
           "foto": dictMark["foto"]!,
           "latitud": dictMark["latitud"]!,
           "longitud": dictMark["longitud"]!,
           "conexion": dictMark["conexion"]!
           ]
        
        var array = EasyMarkSingleton.offlineMarksGlobal
        let lastIndex = (EasyMarkSingleton.offlineMarksGlobal.count - 1)
        array?.remove(at: lastIndex)
        EasyMarkSingleton.offlineMarksGlobal = array!
        AppSettings.offlineMarks = array!

               
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
                
                  /* multiPart.append(image, withName: "foto", fileName: filenameStr, mimeType: "image/png")*/
                
            }, to: url!, headers: httpHeaders)
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
                               let record:[String: Any] = (json["registrarAsistencia"].dictionaryObject!)
                               let valueMark = record["respuesta"] as! Bool
                               let fechaHora = record["fecha_hora"] as! String
                               let messageMark = record["mensaje"] as! String
                            
                               if valueMark == true {
                                  nMarks-=1
                                 /* var array = EasyMarkSingleton.offlineMarksGlobal
                                  let lastIndex = (EasyMarkSingleton.offlineMarksGlobal.count - 1)
                                  array?.remove(at: lastIndex)
                                  EasyMarkSingleton.offlineMarksGlobal = array!
                                  AppSettings.offlineMarks = array!*/
                                    
                                  print("Marcacion Exitosa.")
                                  let dateStr = fechaHora + " " + messageMark
                                  //self.showAlert(message: dateStr)
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
        //}
        
    }
    
    
    static func getConnectionType() -> String {
        let reachable = ReachabilityHandler()
        return reachable.connectionTypeAvailable()
    }
    
    
}
