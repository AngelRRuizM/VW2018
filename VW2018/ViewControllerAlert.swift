//
//  ViewControllerAlert.swift
//  VW2018
//
//  Created by Alumno on 25/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerAlert: UIViewController {

    @IBOutlet weak var highPriority: UIButton!
    @IBOutlet weak var lowPriority: UIButton!
    var low = true
    var high = false
    var alertType = String()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let alertView = segue.destination as! ViewControllerSendAlert
        alertView.alertType = alertType
        alertView.highPriority = high
        alertView.lowPriority = low
    }
    
    func toggleButtons(){
        if high {
            highPriority.setImage(#imageLiteral(resourceName: "highselected"), for: .normal)
        }
        else{
            highPriority.setImage(#imageLiteral(resourceName: "high"), for: .normal)
        }
        if low {
            lowPriority.setImage(#imageLiteral(resourceName: "lowselected"), for: .normal)
        }
        else{
            lowPriority.setImage(#imageLiteral(resourceName: "low"), for: .normal)
        }
    }
    
    @IBAction func setLow(_ sender: Any) {
        low = true
        high = false
        toggleButtons()
    }
    
    @IBAction func setHigh(_ sender: Any) {
        low = false
        high = true
        toggleButtons()
    }
    
    @IBAction func setTypeTrafico(_ sender: Any) {
        alertType = "Trafico"
        self.performSegue(withIdentifier: "toAlert", sender: self)
    }
    
    @IBAction func setTypeAccidente(_ sender: Any) {
        alertType = "Accidente"
        self.performSegue(withIdentifier: "toAlert", sender: self)
    }
    
    @IBAction func setTypeClosedRoad(_ sender: Any) {
        alertType = "Calle Cerrada"
        self.performSegue(withIdentifier: "toAlert", sender: self)
    }
}
