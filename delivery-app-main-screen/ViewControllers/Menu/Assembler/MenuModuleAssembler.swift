//
//  MenuModuleAssembler.swift
//  delivery-app-main-screen
//
//  Created by Aisultan Askarov on 14.01.2024.
//

import UIKit

class MenuModuleAssembler {
    static func assembleModule() -> UIViewController? {
        let router = MenuRouter.start()
        let menuVC = router.entry
        
        return menuVC
    }
}
