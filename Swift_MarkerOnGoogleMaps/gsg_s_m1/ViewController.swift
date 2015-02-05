//
//  ViewController.swift
//  gsg_s_m1
//
//  Created by yosemite on 22/01/15.
//  Copyright (c) 2015 yosemite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //INSTA
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let latitude1 = 17.0
        let longitude1 = 96.16
        //Instancias el mapa
        var camera = GMSCameraPosition.cameraWithLatitude(latitude1, longitude: longitude1, zoom: 8)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled=true
        self.view=mapView;
        
        //Crear un marcador en el mapa
        var marker = GMSMarker()
        marker.position=CLLocationCoordinate2DMake(latitude1,longitude1)
        marker.title="GSG"
        marker.snippet="Paraiso";
        marker.map = mapView
        
        
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //METODOS DELEGADOS PARA LOCALIZACION



}

