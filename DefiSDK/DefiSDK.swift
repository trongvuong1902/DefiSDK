//
//  DefiSDK.swift
//  DefiSDK
//
//  Created by Fury on 11/05/2021.
//

import Foundation
import TrustSDK

public class DefiSDK {
    public static func setScheme(string: String) {
        TrustSDK.initialize(with: TrustSDK.Configuration.init(scheme: string))
    }
        
    public static func openURL(url: URL) {
        _ = TrustSDK.application(UIApplication.shared, open: url)
    }
}
