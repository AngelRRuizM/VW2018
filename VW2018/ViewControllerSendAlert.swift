//
//  ViewControllerSendAlert.swift
//  VW2018
//
//  Created by Alumno on 26/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit
import MapKit

class ViewControllerSendAlert: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    var alertType: String = ""
    var highPriority: Bool = false
    var lowPriority: Bool = true
    
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var moreInfo: UITextField!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var manager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    
    //Precarga la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        //Muestra la imagen del tipo de alerta para evitar errores del usuario
        alertLabel.text = alertType
        manager.delegate = self
        if manager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            manager.requestWhenInUseAuthorization()
        }
        if alertType == "Trafico"{
            alertImage.image = #imageLiteral(resourceName: "trafficjam")
        }
        if alertType == "Accidente" {
            alertImage.image = #imageLiteral(resourceName: "crash")
        }
        if alertType == "Calle Cerrada"{
            alertImage.image = #imageLiteral(resourceName: "closedroad")
        }
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //Sí se puede manejar ubicaciones
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
        
        moreInfo.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        moreInfo.resignFirstResponder()
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

    //Calcula latitud y longitud
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        lat = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude
    }
    
    //Manda la alerta y hace la petición dependiendo de la fecha calculada, el tipo de alerta seleccionado por el usuario.
    @IBAction func sendAlert(_ sender: Any) {
        let now = NSDate()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        var alertMessage = AlertMessage()
        alertMessage.type = alertType
        if highPriority {
            //Alta prioridad
            alertMessage.priority = "High"
        }
        else{
            //Baja prioridad
            alertMessage.priority = "Low"
        }
        if !(moreInfo.text!.isEmpty) {
            alertMessage.message = moreInfo.text!
        }
        else{
            alertMessage.message = ""
        }
        //Ubicación
        alertMessage.lat = lat
        alertMessage.lng = long
        alertMessage.datetime = formater.string(from: now as Date)
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(alertMessage)
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/alerts")
        let request = NSMutableURLRequest(url: url! as URL)
        request.addValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
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
                    }
                }
            }
        }
        dataTask?.resume()
        
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    
}
