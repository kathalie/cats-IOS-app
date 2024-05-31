//
//  infoplist_util.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 31.05.2024.
//

import Foundation
import CatsNetworking

func getMode() -> String? {
    let mainBundle = Bundle.main
        
    return mainBundle.object(forInfoDictionaryKey: "mode") as? String
}

func getApi() -> Api? {
    let mode = getMode()
    
    switch(mode) {
    case "DOGS": return .dogs
    case "CATS": return .cats
    default: return nil
    }
}
