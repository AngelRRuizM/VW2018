//
//  ViewControllerSOS.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerSOS: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func callFirefighters(_ sender: Any) {
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly: true]
        if let url = URL(string: "tel:911"){
            UIApplication.shared.open(url, options: options, completionHandler: nil)
        }
    }
    
    @IBAction func callSecurity(_ sender: Any) {
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly: true]
        if let url = URL(string: "tel:911"){
            UIApplication.shared.open(url, options: options, completionHandler: nil)
        }
    }
    
    @IBAction func callParamedics(_ sender: Any) {
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly: true]
        if let url = URL(string: "tel:911"){
            UIApplication.shared.open(url, options: options, completionHandler: nil)
        }
    }
}
