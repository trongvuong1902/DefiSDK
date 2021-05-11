//
//  TypeRequest.swift
//  DemoWebView
//
//  Created by Fury on 05/05/2021.
//

import Foundation

public enum TypeRequest: String {
    case native = "nativeRequest"
    case networkNative = "nativeNetworkRequest"
}

public enum JSBridgeRequest: String {
    case getWallet = "GET_WALLET"
    case getBalance = "GET_BALANCE"
    case getAccount = "GET_ACCOUNT"
    case sendToken = "SEND_TOKEN"
    case sendNativeToken = "SEND_NATIVE_COIN"
    case signMsg = "SIGN_MESSAGE"
    case signTrans = "SIGN_TRANSACTION"
}

public enum WalletType: String {
    case trust = "TRUST_WALLET"
    case metamask = "META_MASK"
}

public protocol BridgeWebKit {
    var walletType: WalletType {get set}
    
    func getAddresses(callback: @escaping (Result<[String], Error>) -> Void)
    func getAccount() -> String
    func getBalance() -> String
    func signMsg(msg: String, callback: @escaping (Result<String, Error>) -> Void)
    func sendNativeToken(contractAddress: String, toAddress: String, amount: String,
                         callback: @escaping (Result<String, Error>) -> Void)
    func sendToken(to: String, amount:String, callback: @escaping (Result<String, Error>) -> Void)
}



struct BuildJavascript {
    var typeRequest: TypeRequest!
    var brideRequest: JSBridgeRequest!
    var data: String
    init(request: JSBridgeRequest, data: String, type: TypeRequest) {
        self.brideRequest = request
        self.data = data
        self.typeRequest = type
    }
    
    func generateJS() -> String {
        return String(format: "%@('%@','%@'", typeRequest.rawValue,
                      brideRequest.rawValue, data)
    }
}
