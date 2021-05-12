//
//  BridgeManagement.swift
//  DemoWebView
//
//  Created by Fury on 05/05/2021.
//

import Foundation
import UIKit
import WebKit

public protocol ResponseDelegate {
    func getAddresses(addresses: [String])
}

public struct BridgeRequestManagement {
    var wallet: WalletType!
    let message: WKScriptMessage!
    var type: TypeRequest?
    var request: JSBridgeRequest?
    var delegate: ResponseDelegate?
    public init(message: WKScriptMessage, walletType: WalletType) {
        self.message = message
        self.wallet = walletType
        if let dict = convertStringToDictionary(text: message.body as! String),
           let key = dict["key"] as? String {
            type = TypeRequest(rawValue: message.name)
            request = JSBridgeRequest(rawValue: key)
        }
        listenEvent()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    public func listenEvent() {
        switch type {
        case .native:
            let native = NativeRequest(walletType: wallet)
            switch request {
            case .getWallet:
                native.getAddresses { result in
                    switch result {
                    case .success(let responses):
                        delegate?.getAddresses(addresses: responses)                    case .failure(let error):
                            print("Check wallet addresses error: \(error.localizedDescription)")
                    }
                }
            default: break
            }
        default: break
        }
    }
    
//    public func handlerRequest(callback: @escaping (Result<Any, Error>) -> ())  {
//        guard let dict = convertStringToDictionary(text: message.body as! String),
//              let key = dict["key"] as? String else {return}
//        if let type = TypeRequest(rawValue: message.name),
//           let request = JSBridgeRequest(rawValue: key) {
//            
//            switch type {
//            case .native:
//                let native = NativeRequest(walletType: .trust)
//                switch request {
//                case .getWallet:
//                    native.getAddresses { result in
//                        switch result {
//                        case .success(let responses): callback(.success(responses.first!))
//                        case .failure(let error): callback(.failure(error))
//                        }
//                    }
//                case .getBalance: callback(.success(native.getBalance()))
//                case .getAccount: callback(.success(native.getAccount()))
//                case .signMsg:
//                    let data = dict["data"] as! [String: Any]
//                    let msg = data["message"] as! String
////                    native.signMsg(msg: msg, callback: callback)
//                case .sendToken:
//                    guard let data = dict["data"] as? [String: Any],
//                          let address = data["to"] as? String else {return}
//                    var amount = ""
//                    if let value = data["amount"] as? Int64 {
//                        amount = String(value)
//                    }
//                    
//                    if let value = data["amount"] as? String {
//                        amount = value
//                    }
////                    native.sendToken(to: address, amount: amount, callback: callback)
//                case .sendNativeToken:
//                    guard let data = dict["data"] as? [String: Any],
//                          let contractAddress = data["contractAddress"] as? String,
//                          let address = data["address"] as? String
//                          else {return}
//                    
//                    var amount = ""
//                    if let value = data["amount"] as? Int64 {
//                        amount = String(value)
//                    }
//                    
//                    if let value = data["amount"] as? String {
//                        amount = value
//                    }
////                    native.sendNativeToken(contractAddress: contractAddress,
////                                                  toAddress: address, amount: amount, callback: callback)
//                case .signTrans: return
//                case .checkAppInstall: return
////                    native.getWalletInstalled(listWallets: [""], callback: callback)
//                }
//            case .networkNative:
//                return
//            }
//        }
//        return
//    }
}
