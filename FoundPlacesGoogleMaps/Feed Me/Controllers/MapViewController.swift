//
//  MapViewController.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
  //CONECTAR EL MAPA VIEW
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant", "hospital", "hotel"]
    
 //   var searchedTypes = ["doctor", "gas_station", "hospital","pharmacy", "police", "taxi_stand", "bus_station", "church", "dentist", "fire_station", "travel_agency"]
  @IBOutlet weak var adresLabel: UILabel!
  //SELECCIONAR TIPO DE MAPA
  @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
    let segmentedControl = sender as UISegmentedControl
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      mapView.mapType = kGMSTypeNormal
    case 1:
      mapView.mapType = kGMSTypeSatellite
    case 2:
      mapView.mapType = kGMSTypeHybrid
    default:
      mapView.mapType = mapView.mapType
    }
  }
  
    
    @IBAction func refreshPlaces(sender: AnyObject) {
        fetchNearbyPlaces(mapView.camera.target)
    }

    
     //INSTANCIA DE GEOCALIZACION
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //USAR LA GEOLOCALIZACION
  locationManager.delegate = self
  locationManager.requestWhenInUseAuthorization()
   //deelegado para geocoder
  mapView.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Types Segue" {
      let navigationController = segue.destinationViewController as UINavigationController
      let controller = segue.destinationViewController.topViewController as TypesTableViewController
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
  }
  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = sorted(controller.selectedTypes)
    dismissViewControllerAnimated(true, completion: nil)
    //manejo de los places
    fetchNearbyPlaces(mapView.camera.target)
  }
  
  //localizar
  // 1
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    // 2
    if status == .AuthorizedWhenInUse {
           // 3
      locationManager.startUpdatingLocation()
           //4
      mapView.myLocationEnabled = true
      mapView.settings.myLocationButton = true
    }
  }
  // 5
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    
    if let location = locations.first as? CLLocation {
         // 6
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      let marker = GMSMarker()
      marker.position=CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
      marker.title = location.coordinate.latitude.description
      marker.snippet = location.coordinate.longitude.description
      marker.map = mapView
      
      // 7
      locationManager.stopUpdatingLocation()
      
      
      //manejos d elos places
      fetchNearbyPlaces(location.coordinate)
      
    }
    
  }
  
  //geocoder para encontrar la direccion de las coordenadas
  func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D)
  {
  let geocoder = GMSGeocoder()
  geocoder.reverseGeocodeCoordinate(coordinate) { response,error in 
self.adresLabel.unlock()
if let adress = response?.firstResult() {
  let lines = adress.lines as [String]
  self.adresLabel.text = join("\n", lines)
  let labelHeight = self.adresLabel.intrinsicContentSize().height
  self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
  UIView.animateWithDuration(0.25){
  
  self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length)*0.5)
  self.view.layoutIfNeeded()
        }
      }
    }
  }
//encontrar la direccion cuando la posicion cambie
func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {reverseGeocodeCoordinate(position.target)
    }
  
  //poner reloj de arena al label mientras se actualiza
  func mapView(mapView: GMSMapView!, willMove gesture:Bool)
  {adresLabel.lock()
  
    //reseteat la posicion de icono deposicion
    if (gesture) {
        mapCenterPinImage.fadeIn(0.25)
        mapView.selectedMarker=nil
    }
    
  
  }

//Manejo de los markers
  var mapRadius: Double{
    get {
          let region = mapView.projection.visibleRegion()
          let verticalDistance =  GMSGeometryDistance(region.farLeft, region.nearLeft)
          let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
          return max(horizontalDistance, verticalDistance)*0.5
      
      }
    
    }

//proveedor de datos para los places
  let dataProvider = GoogleDataProvider()  
  func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D)
  {
    //limpiar el mapa de los places que existan
    mapView.clear()
    dataProvider.fetchPlacesNearCoordinate(coordinate, radius: mapRadius, types: searchedTypes) {places in
      for place: GooglePlace in places {
        let marker = PlaceMarker(place: place)
          marker.map = self.mapView
        }
    }
  }
 
//detalles de los places
    
    func  mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as PlaceMarker
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = placeMarker.place.name
            if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            }else {
            infoView.placePhoto.image = UIImage(named: "generic")
            }
                return infoView
        }else {
            return nil
        }
        
    }
  
//evitar que se vea el icono de posicion  seleccionar un place
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    mapCenterPinImage.fadeOut(0.25)
      return false
  }
  
//Trazar la ruta a un place
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    let googleMarker = mapView.selectedMarker as PlaceMarker
    dataProvider.fetchDirectionsFrom(mapView.myLocation.coordinate, to: googleMarker.place.coordinate) { optionalRoute in
      if let encodedRoute = optionalRoute {
        let path = GMSPath(fromEncodedPath: encodedRoute)
        let line = GMSPolyline(path: path)
        line.strokeWidth = 4.0
        line.strokeColor = self.randomlineColor
        line.tappable = true
        line.map = self.mapView
        mapView.selectedMarker = nil
      }
    }
    
  }
 //propiedad que maneja el color de la linea
  
  var randomlineColor:UIColor{
    get {
      let randomRed = CGFloat(drand48())
      let randomGreen = CGFloat(drand48())
      let randomBlue = CGFloat(drand48())
      return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
  }
  
  
  
  //fin de la clase
}