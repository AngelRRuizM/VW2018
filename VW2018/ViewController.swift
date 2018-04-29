//
//  ViewController.swift
//  VW2018
//
//  Created by Alumno on 24/04/18.
//  Copyright © 2018 Gekko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var driver = Driver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Checar si email es nil. Si no lo es, ya hizo login
        if UserDefaults.standard.string(forKey: "email") != nil {
            print("lol")
            self.performSegue(withIdentifier: "toCrafter", sender: self)
        }
        else{
            print("lol2")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func logIn(_ sender: Any) {
        //Para que las peticiones no hagan overlap
        if dataTask != nil {
            dataTask?.cancel()
        }
        //Deja saber al usuario que su petición se está procesando.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //Saca el usuario y la contraseña del textfield y hace el encoding
        let user = username.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let pass = password.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //URL a la que se le hace la petición para validar el login
        let url = NSURL(string: "https://fake-backend-mobile-app.herokuapp.com/drivers?email=\(user)&password=\(pass)")
        
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
                //Verifica si la respuesta de la petición es exitosa
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
    
    //Función que procesa la información del conductor y maneja el set de los user defaults.
    func processData(data: Data){
        let json = try? JSONSerialization.jsonObject(with: data, options: [])
        if let array = json as? [Any]{
            if array.count == 1{
                let jsonDecoder = JSONDecoder()
                let array = try? jsonDecoder.decode([Driver].self, from: data)
                
                self.driver = array!.first!
                //Hace set del email.
                let x = UserDefaults.standard
                x.set(username.text!, forKey: "email")
                x.synchronize()
                x.set(driver.id, forKey: "id")
                x.synchronize()
                //Como fue exitoso, pasa a la siguiente vista
                self.performSegue(withIdentifier: "toCrafter", sender: self)
            }
            else{
                //Si no fue exitoso, manda mensaje de error
                let alert = UIAlertController(title: "Inicio de sesión", message: "Usuario o contraseña invalidos", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    //Función relacionada a lo que corresponde al botón de contraseña olvidada
    @IBAction func forgottenPassword(_ sender: Any) {
        //No se puede mandar correo si se desconoce la cuenta
        if (username.text?.isEmpty)!{
            let alert = UIAlertController(title: "Contraseña", message: "Por favor introduzca su correo electronico", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        else{
            //TODO: Mandar correo al proporcionado
            let alert = UIAlertController(title: "Contraseña", message: "Una liga para restablecer su contraseña se ha enviado a su correo", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    //Función necesaria para el unwind cuando se hace logout
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
}

