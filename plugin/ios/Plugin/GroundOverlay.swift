import Foundation
import GoogleMaps
import Capacitor

public struct GroundOverlay {
    let bounds: GMSCoordinateBounds
    let imagePath: String
    
    init(_ call: CAPPluginCall) throws {
        print("init GroundOverlay")
        
        guard let latitude = call.getDouble("latitude"),
              let longitude = call.getDouble("longitude"),
              let width = call.getFloat("width"),
              let height = call.getFloat("height"),
              let imagePath = call.getString("imagePath")
        else {
            throw NSError(domain: "GroundOverlayError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Missing required parameters"])
        }
        
        let southWestLat = latitude - Double(height) / 200000
        let southWestLng = longitude - Double(width) / 150000
        let northEastLat = latitude + Double(height) / 200000
        let northEastLng = longitude + Double(width) / 150000

        let southWest = CLLocationCoordinate2D(latitude: southWestLat, longitude: southWestLng)
        let northEast = CLLocationCoordinate2D(latitude: northEastLat, longitude: northEastLng)
        self.bounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        
        self.imagePath = imagePath;
        
    }
}
