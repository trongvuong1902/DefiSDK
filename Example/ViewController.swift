//
//  ViewController.swift
//  Example
//
//  Created by Fury on 10/05/2021.
//

import UIKit
import WebKit
import DefiSDK

class ViewController: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: TypeRequest.native.rawValue)
        configuration.userContentController.add(self, name: TypeRequest.networkNative.rawValue)
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
//        webView.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "http://192.168.1.63:3000/webview")!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            print("link")
            guard let url = navigationAction.request.url else {return}
            print(url)
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        print("no link")
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("Name: \(message.name)")
        let management = BridgeRequestManagement(message: message)
        management.handlerRequest { [unowned self] result in
            switch result {
            case .success(let js):
                self.webView.evaluateJavaScript(js) { any, error in
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}



