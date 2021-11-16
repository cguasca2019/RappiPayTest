//
//  Tools.swift
//  rappimovie
//
//  Created by Cesar Guasca on 12/11/21.
//

import Foundation

class Tools {
    static let shared: Tools = Tools()
    var settings = Dictionary<String, AnyObject>()
    
    func readSettingsPlist() -> Dictionary<String, AnyObject> {
        let path = Bundle.main.path(forResource: "Settings", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as? Dictionary<String, AnyObject>
        return dict!
    }
    
    class func getPath(_ fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    class func copyFile(_ fileName: NSString) {
        
        let dbPath: String = getPath(fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL!.appendingPathComponent(fileName as String)
            
            do {
                try fileManager.copyItem(atPath: fromPath.path, toPath: dbPath)
            } catch let error1 as NSError {
                print(error1)
            }
        }
    }
    
    func getAppKey() -> String {
        self.settings = readSettingsPlist()
        return self.settings["ApiKey"] as! String
    }
    
    func getUrlRequest() -> String {
        self.settings = readSettingsPlist()
        return self.settings["Url"] as! String
    }
    
    func getUrlImages() -> String {
        self.settings = readSettingsPlist()
        return self.settings["ImgUrl"] as! String
    }
    
    open func readingPagePopular() -> Int {
        let defaults = UserDefaults.standard
        let i = defaults.integer(forKey: "PagePopular")
        return i
    }
    
    open func writingPagePopular(_ i: Int){
        let defaults = UserDefaults.standard
        defaults.set(i, forKey: "PagePopular")
    }
    
    open func readingPageNowPlay() -> Int {
        let defaults = UserDefaults.standard
        let i = defaults.integer(forKey: "PageNowPlay")
        return i
    }
    
    open func writingPagenowPlay(_ i: Int){
        let defaults = UserDefaults.standard
        defaults.set(i, forKey: "PageNowPlay")
    }
    
    open func readingPageUpcoming() -> Int {
        let defaults = UserDefaults.standard
        let i = defaults.integer(forKey: "PageUpcoming")
        return i
    }
    
    open func writingPageUpcoming(_ i: Int){
        let defaults = UserDefaults.standard
        defaults.set(i, forKey: "PageUpcoming")
    }
    
    open func readingPageTopRated() -> Int {
        let defaults = UserDefaults.standard
        let i = defaults.integer(forKey: "PageTopRated")
        return i
    }
    
    open func writingPageTopRated(_ i: Int){
        let defaults = UserDefaults.standard
        defaults.set(i, forKey: "PageTopRated")
    }
}
