//
//  NativeRequest.swift
//  DefiSDK
//
//  Created by Fury on 11/05/2021.
//

import Foundation

struct NativeRequest: BridgeWebKit {
    var walletType: WalletType
    
    func sendNativeToken(contractAddress: String, toAddress: String, amount: String,
                         callback: @escaping (Result<String, Error>) -> Void) {
        print("Send \(amount) trx")
        switch walletType {
        case .trust:
            TrustWalletUtil.sendNativeCoin(contractAddress: contractAddress, to: toAddress,
                                           amount: amount) { result in
                switch result {
                case .success(let signature):
                    let scriptBuild = BuildJavascript(request: .sendNativeToken,
                                                      data: signature,
                                                      type: .native)
                    callback(.success(scriptBuild.generateJS()))
                case .failure(let error): callback(.failure(error))
                }
            }
        default: break
        }
        
    }
    
    func sendToken(to: String, amount: String,
                   callback: @escaping (Result<String, Error>) -> Void) {
        print("send token")
        TrustWalletUtil.sendTrx(amount: String(amount), address: to) { result in
            switch result {
            case .success(let response):
                callback(.success("nativeResponse('\(JSBridgeRequest.sendToken.rawValue)','\(response)')"))
            case .failure(let error): callback(.failure(error))
            }
        }
    }
    
    func signMsg(msg: String, callback: @escaping (Result<String, Error>) -> Void) {
        print("sign message")
        TrustWalletUtil().signMessage(message: msg) { result in
            switch result {
            case .success(let signature): callback(.success("nativeResponse('\(JSBridgeRequest.signMsg.rawValue)','\(signature)')"))
            case .failure(let error): callback(.failure(error))
            }
        }
    }
    
    func getAddresses(callback: @escaping (Result<[String], Error>) -> Void){
        print("Native get wallet")
        switch walletType {
        case .trust:
            TrustWalletUtil().getAddress { result in
                switch result {
                case .success(let addresses):
                    let address = addresses.first!
                    let data = WalletData(address: address, name: "tron", asset: "trx", walletType: walletType.rawValue)
                    do {
                        let data = try JSONEncoder().encode(data)
                        let jsonStr = String(data: data, encoding: .utf8)!
                        let js = BuildJavascript(request: .getWallet, data: jsonStr, type: .native)
                        callback(.success([js.generateJS()]))
                    } catch let error {callback(.failure(error))}
                case .failure(let error): callback(.failure(error))
                }
            }
        default: break
        }
    }
    
    func getAccount() -> String{
        print("Get Account")
        do {
            let account = AccountData()
            let data = try JSONEncoder().encode(account)
            let jsonStr = String(data: data, encoding: .utf8)!
            return "nativeResponse('\(JSBridgeRequest.getAccount.rawValue)','\(jsonStr)')"
        } catch {}
        return ""
    }
    
    func getBalance() -> String {
        print("Get balance script")
        do {
            let account = AccountData()
            let data = try JSONEncoder().encode(account)
            let jsonStr = String(data: data, encoding: .utf8)!
            return "nativeResponse('\(JSBridgeRequest.getBalance.rawValue)','\(jsonStr)')"
        } catch {}
        return ""
    }
}
