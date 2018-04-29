//
//  ViewControllerResgisterTable.swift
//  VW2018
//
//  Created by Alumno on 27/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerResgisterTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var crafter =  Crafter()
    var strings: [String] = [String]()
    @IBOutlet weak var table: UITableView!
    var selectedRow = 0
    
    //Jala el crafter seleccionado para poder obtener la información del registro
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.getCrafter()
        table.delegate = self
        table.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hace la preparación para el cambio de pantalla dependiendo de cuál celda se presiona
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedRow == 4 {
            let batteryView = segue.destination as! ViewControllerBattery
            let x = crafter.batteries.count
            batteryView.battery = crafter.batteries[x - 1]
        }
        else if selectedRow == 5{
            let fuelView = segue.destination as! ViewControllerFuel
            fuelView.crafter = crafter
        }
    }
    
    //Realiza las segues donde corresponde
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 4){
            selectedRow = 4
            self.performSegue(withIdentifier: "toBattery", sender: self)
        }
        else if(indexPath.row == 5){
            selectedRow = 5
            self.performSegue(withIdentifier: "toFuel", sender: self)
        }
    }
    
    //Precarga los strings puesto que es algo definido
    func loadStrings(){
        strings.append("Crafter \(crafter.id)")
        strings.append(crafter.plates)
        strings.append(crafter.model)
        strings.append("Año \(crafter.year)")
        strings.append("Batería")
        strings.append("Gasolina")
    }
    
    //La cantidad de filas es la cantidad de strings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    //Título para la tabla
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Registro"
    }
    
    //Realiza petición de get para obtener el crafter seleccionado
    func getCrafter(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let plates = UserDefaults.standard.string(forKey: "registerCrafter")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters?plates=\(plates!)")
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
                //Si el get es exitoso, procesa la información
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
    
    //Procesa el JSON para que sea manejado como crafter
    func processData(data: Data){
        let jsonDecoder = JSONDecoder()
        let array = try? jsonDecoder.decode([Crafter].self, from: data)
        self.crafter = array!.first!
        self.loadStrings()
        //Vuelve a cargar la tabla porque la información cambió
        table.reloadData()
        
    }
    
    //Define la información por celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = strings[row]
        if(row == 4 || row == 5){
            cell.accessoryType = .disclosureIndicator
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

}
