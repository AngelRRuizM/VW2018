//
//  ViewControllerFuel.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerFuel: UIViewController, UITextFieldDelegate {

    var crafter = Crafter()
    
    @IBOutlet weak var last: UILabel!
    @IBOutlet weak var fuelType: UITextField!
    @IBOutlet weak var liters: UITextField!
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var toRegister = Fuel_reffils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = crafter.fuel_reffils.count
        last.text = crafter.fuel_reffils[x - 1].datetime
        // Do any additional setup after loading the view.
        fuelType.delegate = self
        liters.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            liters.resignFirstResponder()
        }
        else if textField.tag == 1{
            fuelType.resignFirstResponder()
        }
        return true
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Verifica si el string es un número o no
    func isNotNumeric(liters: String) -> Bool{
        return Double(liters) == nil
    }
    
    //Función para la recarga de gasolina
    @IBAction func recharge(_ sender: Any) {
        //Hace validación
        if (fuelType.text?.isEmpty)! || (liters.text?.isEmpty)! || (self.isNotNumeric(liters: liters.text!)) {
            //Si no pasa, da un mensaje de error
            let alert = UIAlertController(title: "Fallo en registro", message: "Debes incluir la cantidad en litros (numérico) y el tipo de gasolina", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        else{
            //Realiza la carga
            let x = Float(liters.text!)
            if x != nil {
                //Cálculo de fecha actual para la carga
                let now = NSDate()
                let formater = DateFormatter()
                formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                toRegister.datetime = formater.string(from: now as Date)
                toRegister.type = fuelType.text!
                toRegister.liters = x!
                putRegister()
                self.performSegue(withIdentifier: "back", sender: self)
            }
            else{
                //Hubo algún error
                let alert = UIAlertController(title: "Fallo en registro", message: "La cantidad en litros debe ser un número", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    //Realiza la petición para agregar la última recarga al back
    func putRegister(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        crafter.fuel_reffils.append(toRegister)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(crafter)
        //URL para la petición
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters/\(crafter.id)")
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        
        dataTask = defaultSession.dataTask(with: request as URLRequest){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            //Si hay error, lo muestra
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
}
