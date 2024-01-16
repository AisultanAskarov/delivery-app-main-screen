//
//  BaseENV.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 16.01.2024.
//

import Foundation

class BaseENV {
    
    let dict: NSDictionary
    
    init(resourceName: String) {
        guard let filePath = Bundle.main.path(forResource: resourceName, ofType: "plist"), let plist = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file '\(resourceName)' plist")
        }
        self.dict = plist
    }
}

protocol APIKeyable {
    var MENU_ITEMS_API_KEY: String { get }
}

final class DebugEnv: BaseENV, APIKeyable {
    init() {
        super.init(resourceName: "DEBUG-Keys")
    }
    
    var MENU_ITEMS_API_KEY: String {
        dict.object(forKey: "MENU_ITEMS_API_KEY") as? String ?? ""
    }
}

final class ProdEnv: BaseENV, APIKeyable {
    init() {
        super.init(resourceName: "PROD-Keys")
    }
    
    var MENU_ITEMS_API_KEY: String {
        dict.object(forKey: "MENU_ITEMS_API_KEY") as? String ?? ""
    }
}
