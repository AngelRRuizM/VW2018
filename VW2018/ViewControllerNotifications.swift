//
//  ViewControllerNotifications.swift
//  VW2018
//
//  Created by Alumno on 27/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerNotifications: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var alerts = [AlertMessage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Precarga las notificaciones
        self.getNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    //Define el contenido de las celdas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = alerts[row].type
        cell.detailTextLabel?.text = alerts[row].datetime
        //Puesto que la prioridad es alta o baja, pone las imágenes en la celda de acuerdo a lo correspondiente
        if(alerts[row].priority == "Alta" || alerts[row].priority == "High"){
           cell.imageView?.image = #imageLiteral(resourceName: "HighPriorityIcon")
        }
        else if(alerts[row].priority == "Baja" || alerts[row].priority == "Low"){
            cell.imageView?.image = #imageLiteral(resourceName: "LowPriorityIcon")
        }
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //Realiza la petición para el get de todas las notificaciones
    func getNotifications(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //URL para realizar la petición
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/alerts")
        let request = URLRequest(url: url! as URL)
        
        dataTask = defaultSession.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                //Si es exitoso, entonces procesa la información
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.processData(data: data!)
                        }
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    //Procesa los json como notificaciones
    func processData(data: Data){
        
        let jsonDecoder = JSONDecoder()
        let array = try? jsonDecoder.decode([AlertMessage].self, from: data)
        alerts = array!
        //Vuelve a cargar la información de la tabla porque va a cambiar.
        table.reloadData()
    }
    
}
