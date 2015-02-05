//
//  PlaceMarker.swift
//  Feed Me
//
//  Created by yosemite on 26/01/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//
//clase para los marcadores en googlemaps

import UIKit

class PlaceMarker: GMSMarker {

  let place:GooglePlace
  
  init(place: GooglePlace)
  {
    self.place = place
    super.init()
    position = place.coordinate
    icon = UIImage(named: place.placeType+"_pin")
    groundAnchor = CGPoint(x: 0.5, y: 1 )
    appearAnimation = kGMSMarkerAnimationPop
  
  }
}
