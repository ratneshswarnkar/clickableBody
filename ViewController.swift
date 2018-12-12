//
//  ViewController.swift
//
//
//  Created by Ratnesh Swarkar on 12/6/18.
//  Copyright © 2018 Ratnesh Swarkar. All rights reserved.
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
        self.bodyPartId()
        
        self.screenImageView.image = self.screenshot()
        
    }
    //Get selected id
    func bodyPartId() {
        let idval = "0"
        
        
        if let functionGetId = self.jsContext.objectForKeyedSubscript("getbodyPartId"){
            
            if let bodyselectionId = functionGetId.call(withArguments: [idval]){
                
                print(bodyselectionId.toString())
            }
        }
        
    }
    
    //Web view delegate
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

