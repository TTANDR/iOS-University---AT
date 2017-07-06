//
//  ViewController.swift
//  weather
//
//  Created by Andrey Timokhov on 03/07/2017.
//  Copyright © 2017 Andrey Timokhov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let realm = try! Realm()
        print (Realm.Configuration.defaultConfiguration.fileURL)
        let url = "http://api.wunderground.com/api/0aaad10764e1a886/astronomy/q/Russia/Moscow.json"

        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            
            case .success(let value):
                let json = JSON(value)
                
                print("JSON: \(json["moon_phase"]["sunrise"]["hour"].stringValue)")
                let todaySunPhase = SunPhaseData()
                todaySunPhase.Sunset = json["moon_phase"]["sunset"]["hour"].stringValue + ":" + json["moon_phase"]["sunset"]["minute"].stringValue
                todaySunPhase.Sunrise = json["moon_phase"]["sunrise"]["hour"].stringValue + ":" + json["moon_phase"]["sunrise"]["minute"].stringValue
                print ("Sunset: \(todaySunPhase.Sunset)")
                print ("Sunrise: \(todaySunPhase.Sunrise)")
                try! realm.write {
                    realm.add(todaySunPhase)
                }
            
            case .failure(let error):
                print("!!!ERROR!!!: \(error)")
            } //switch
        
        }

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


} //class ViewController: UIViewController

