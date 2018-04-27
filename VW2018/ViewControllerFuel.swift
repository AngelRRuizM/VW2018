//
//  ViewControllerFuel.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerFuel: UIViewController {

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
        last.text = crafter.fuel_reffils[x - 1].date
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
    
    @IBAction func recharge(_ sender: Any) {
        if (fuelType.text?.isEmpty)! || (liters.text?.isEmpty)! {
            let alert = UIAlertController(title: "Fallo en registro", message: "Debes incluir la cantidad en litros y el tipo de gasolina", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        else{
            let now = NSDate()
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
            toRegister.date = formater.string(from: now as Date)
            toRegister.type = fuelType.text!
            putRegister()
            self.performSegue(withIdentifier: "back", sender: self)
        }
    }
    
    func putRegister(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        crafter.fuel_reffils.append(toRegister)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(crafter)
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
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        print("Se hizo el put register")
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
}
