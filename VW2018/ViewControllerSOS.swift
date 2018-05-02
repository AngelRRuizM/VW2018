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
    
    //Función para llamar bomberos
    @IBAction func callFirefighters(_ sender: Any) {
        //Número es un placeholder
        guard let url = URL(string: "tel://2224555870") else { return }
        UIApplication.shared.open(url)
    }
    
    //Función para llamar seguridad
    @IBAction func callSecurity(_ sender: Any) {
        //Número es un placeholder
        guard let url = URL(string: "tel://223872836") else { return }
        UIApplication.shared.open(url)
    }
    
    //Función para llamar paramédicos
    @IBAction func callParamedics(_ sender: Any) {
        //Número es un placeholder
        guard let url = URL(string: "tel://2291454786") else { return }
        UIApplication.shared.open(url)
    }
}
