//
//  ViewController.swift
//  NSURLConnection
//
//  Created by Poyao on 2016/8/31.
//  Copyright © 2016年 Poyao. All rights reserved.

import UIKit

var goodtoken:String = ""
var sendString:String = ""
var dataString:NSString = ""
var dataArray = [AnyObject]()
typealias JSON = [String:AnyObject]
var jsonArray: [JSON]!
let semaphore = dispatch_semaphore_create(0)

struct jsonData{
    let id: String
    let label: String
}
var json = [jsonData]()

class ViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var connectHttpJson1 = connectHttpJson()
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! DataTableViewCell
        cell.lbID.text = json[indexPath.row].id
        cell.lbName.text = json[indexPath.row].label
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        connectHttpJson1.main({
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class connectHttpJson: NSObject ,NSURLSessionDelegate {
    
    func main(callback: () -> Void){
        post()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        get(callback)
    }
    
    func post(){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://web.daychen.tw/api-token-auth/")!)
        request.HTTPMethod="POST"
        
        let postString = "username=godschool&password=qazwsxedc"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let taskPost = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
        guard error == nil && data != nil else {
            print("error=\(error)") // check for fundamental networking error
            return
        }
        
        if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
        }
        
        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
        let data: NSData = responseString!.dataUsingEncoding(NSUTF8StringEncoding)!
        var token = String()
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            token = (json["token"] as? String)!
            } catch {
            print("get error\n")
            print("error serializing JSON: \(error)")
            }
            goodtoken = token
            print("goodtoken:\(goodtoken)")
            print("\n")
                
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            print(statusCode)
            print("\n")
            dispatch_semaphore_signal(semaphore)
        }
        taskPost.resume()
    }
    
    func get(callback: () -> Void){
        
        sendString = "jwt " + goodtoken
        print("get key = \(sendString)")
        print("\n")
        
        let geturl = NSURL(string: "http://web.daychen.tw/account/")
        let request1: NSMutableURLRequest = NSMutableURLRequest(URL: geturl!)
        request1.setValue("jwt \(sendString)", forHTTPHeaderField: "Authorization")
        request1.HTTPMethod = "GET"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.HTTPAdditionalHeaders = ["Authorization" : sendString]
        let session = NSURLSession(configuration: config)
        
        session.dataTaskWithURL(geturl!) {
            (let data, let response, let error) in
            if (response as? NSHTTPURLResponse) != nil {
                
                let getString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                let getdata: NSData = getString!.dataUsingEncoding(NSUTF8StringEncoding)!

                do {
                    jsonArray = try NSJSONSerialization.JSONObjectWithData(getdata, options: NSJSONReadingOptions(rawValue: 0)) as? [JSON]
                } catch {
                    print(error)
                }
                
                for item in jsonArray {
                    let id = item["id"] as AnyObject? as? String
                    let label = item["label"] as AnyObject? as? String
                    json.append(jsonData(id: id!, label: label!))
                }
                print("json count =\(json.count)")
                for data in json{
                    print("id = \(data.id)")
                    print("label = \(data.label)\n")
                }
            
            }
            
            callback()
            
        }.resume()
    }
}
