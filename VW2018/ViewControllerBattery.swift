//
//  ViewControllerBattery.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerBattery: UIViewController {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var battery = Battery()
    
    @IBOutlet weak var marca: UILabel!
    @IBOutlet weak var modelo: UILabel!
    @IBOutlet weak var fecha: UILabel!
    
    
    //Solamente carga el texto de cada label de acuerdo a la batería del crafter
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marca.text = battery.brand
        modelo.text = battery.model
        fecha.text = battery.date
        
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

}
