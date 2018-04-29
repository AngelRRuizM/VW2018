//
//  ViewControllerCrafter.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewControllerCrafter: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData = NSMutableArray()
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var dataToProcess = Data()
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var leaveCrafter: UIButton!
    //Secciones o componentes en el picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Cantidad de filas en el picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //Nombre de la fila del picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerData[row] as! String)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Carga el dataSource
        picker.dataSource = self
        //Se pone a sí mismo como delegate
        picker.delegate = self
        //Carga los crafters disponibles
        self.getCrafters()
        //Verifica si ya hay un crafter seleccionado por el conductor
        if UserDefaults.standard.string(forKey: "crafter") != nil {
            leaveCrafter.isHidden = false
        }
        else{
            leaveCrafter.isHidden = true
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Checar si crafter es nil. Si no lo es, ya selecciono crafter
        
    }

    func getCrafters(){
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //URL  a la que se le hace el request para el get
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/crafters")
        let request = URLRequest(url: url! as URL)
        dataTask = defaultSession.dataTask(with: request){
            data, response, error in
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            //Manejo de errores
            if let error = error {
                print(error.localizedDescription)
            }
            else{
                //Procesa la información si el resultado de la petición es exitoso
                if let httpsResponse = response as? HTTPURLResponse {
                    if httpsResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            self.processData(data: data!)
                        }
                    }
                    else{
                        //Si no es válida la petición, algo raro sucedió y mejor hace logout
                        DispatchQueue.main.async {
                            self.logOut()
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        self.logOut()
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    //Función que procesa la información de los crafters y hace manejo de las placas para mostrarlas
    func processData(data: Data){
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? NSArray{
            for crafter in array{
                if let dictionary = crafter as? NSDictionary {
                    let plates = dictionary.value(forKey: "plates")
                    self.pickerData.add("\(plates ?? "no plates" )")
                }
            }
        }
        picker.reloadAllComponents()
    }
    
    //Hace logout, se llama cuando hubo algún error "imposible"
    func logOut(){
        let x = UserDefaults.standard
        //Mata la llave
        x.set(nil, forKey: "email")
        x.synchronize()
        //Mata el crafter
        x.set(nil, forKey: "crafter")
        x.synchronize()
        let alert = UIAlertController(title: "Error en el servidor", message: "Hubo un error en el servidor, vuelva a intentar mas tarde", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
        self.performSegue(withIdentifier: "toLogIn", sender: self)
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
    
    //Función que hace set del crafter en los user defaults
    @IBAction func selectCrafter(_ sender: Any) {
        let x = UserDefaults.standard
        x.set( (pickerData[picker.selectedRow(inComponent: 0)] as! String), forKey: "crafter")
        print( (pickerData[picker.selectedRow(inComponent: 0)] as! String) )
        x.synchronize()
        self.performSegue(withIdentifier: "toTabBar", sender: self)
    }
    
    //Mata el user default del crafter
    @IBAction func leaveCrafterAction(_ sender: Any) {
        let x = UserDefaults.standard
        x.set( nil, forKey: "crafter")
        print("nil")
        x.synchronize()
        leaveCrafter.isHidden = true
    }
    
    
    
}
