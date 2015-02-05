//
//  ViewController.m
//  gsg
//
//  Created by yosemite on 22/01/15.
//  Copyright (c) 2015 yosemite. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController
{
    //INSTACIAR EL MAPAVIEW
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
//CREAR MAPA con posicion
    //mark llamar la clase que obtiene la posicion del dispositivo
    GMSCameraPosition *camera =[GMSCameraPosition cameraWithLatitude:18.39 longitude:-93.20 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled=YES;
    self.view = mapView_;
    
    
//CREAR UN MARCADOR EN EL MAPA
    GMSMarker *maker = [[GMSMarker alloc] init];
    maker.position = CLLocationCoordinate2DMake(18.39, -93.20);
    maker.title = @"Chedraui Paraiso";
    maker.snippet=@"Tabasco";
    maker.map = mapView_;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
