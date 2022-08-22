//
//  MapTest.swift
//  test0708
//
//  Created by khg on 2022/08/17.
//

import SwiftUI
import MapKit

struct MapTest: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude:-122.009_020),
        latitudinalMeters: 500,
        longitudinalMeters: 500
    )
    
    var body: some View {
        Map(coordinateRegion: $region)
    }


}
