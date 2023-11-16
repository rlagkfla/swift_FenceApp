//
//  SettingHandler.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/4/23.
//

import UIKit

struct SettingHandler {
    
    static func moveToSetting() {
        
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}
