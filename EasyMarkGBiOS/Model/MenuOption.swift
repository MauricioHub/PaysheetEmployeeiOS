//
//  MenuOption.swift
//  remoteattendance
//
//  Created by Pinlet on 5/28/20.
//  Copyright © 2020 Pinlet. All rights reserved.
//

import UIKit

enum MenuOption: Int, CustomStringConvertible {
    
    case Gps
    //case Bluetooth
    case Reporte
    case Cierre
    
    var description: String {
        switch self {
        case .Gps: return "Registrar asistencia (GPS)"
        //case .Bluetooth: return "Registrar asistencia (Bluetooth)"
        case .Reporte: return "Reporte asistencia"
        case .Cierre: return "Cerrar sesion"
        }
    }
    
    var image: UIImage {
        switch self {
        case .Gps: return UIImage(named: "ic_person_outline_white_2x") ?? UIImage()
        //case .Bluetooth: return UIImage(named: "ic_mail_outline_white_2x") ?? UIImage()
        case .Reporte: return UIImage(named: "ic_menu_white_3x") ?? UIImage()
        case .Cierre: return UIImage(named: "baseline_settings_white_24dp") ?? UIImage()
        }
    }
}
