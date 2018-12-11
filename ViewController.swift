//
//  ViewController.swift
//  HTMLDemo
//
//  Created by Kawalpreet Kaur on 12/6/18.
//  Copyright © 2018 Kawalpreet Kaur. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class ViewController: UIViewController,WKNavigationDelegate{
    var jsContext: JSContext!
    @IBOutlet weak var webKit: WKWebView!
    
    @IBOutlet weak var screenImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webKit.navigationDelegate = self
        
        let url = Bundle.main.url(forResource: "front-new", withExtension: "html")
        // let url = URL(string: "http://172.10.178.41:8089/front-new.html")
        let request = URLRequest(url: url!)
        webKit.allowsBackForwardNavigationGestures = true
        webKit.load(request)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeJS()
        
    }
    func initializeJS() {
        
        self.jsContext = JSContext()
        
        // Specify the path to the jssource.js file.
        if let jsSourcePath = Bundle.main.path(forResource: "jssource", ofType: "js") {
            do {
                // Load its contents to a String variable.
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                
                // Add the Javascript code that currently exists in the jsSourceContents to the Javascript Runtime through the jsContext object.
                self.jsContext.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        self.jsContext.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString())
            }
        }
    }
    @IBAction func actionCheckId(_ sender: Any) {
        self.jsDemo1()
        // var imag:UIImage? = self.screenshot()
        
        self.screenImageView.image = self.screenshot()
        
    }
    func jsDemo1() {
        let firstname = "Mickey"
        //let lastname = "Mouse"
        
        //        if let functionFullname = self.jsContext.objectForKeyedSubscript("getFullname") {
        //            // Call the function that composes the fullname.
        //            if let fullname = functionFullname.call(withArguments: [firstname, lastname]) {
        //                print(fullname.toString())
        //            }
        //        }
        
        if let functionGetId = self.jsContext.objectForKeyedSubscript("getbodyPartId"){
            
            if let bodyselectionId = functionGetId.call(withArguments: [firstname]){
                
                print(bodyselectionId.toString())
            }
        }
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let path = Bundle.main.path(forResource: "illustration-style", ofType: "css")!
        let javaScriptStr = "var link = document.createElement('link'); link.href = '\(path)'; link.rel = 'stylesheet'; document.head.appendChild(link)"
        webKit.evaluateJavaScript(javaScriptStr) { (data, error) in
        }
        
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        //webKit.stringByEvaluatingJavaScript(from: javaScriptStr)
    }
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.webKit.bounds.size, true, 0);
        self.webKit.drawHierarchy(in: self.webKit.bounds, afterScreenUpdates: true);
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return snapshotImage;
    }
}

