import Foundation
import Capacitor

public struct Marker {
	let coordinate: LatLng
	let opacity: Float?
	let title: String?
	let snippet: String?
	let isFlat: Bool?
	var iconUrl: String?
	let iconSize: CGSize?
	let iconAnchor: CGPoint?
	let draggable: Bool?
	let color: UIColor?
	let zIndex: Int32
	var icon: UIImage?

	init(fromJSObject: JSObject) throws {
		guard let latLngObj = fromJSObject["coordinate"] as? JSObject else {
			throw GoogleMapErrors.invalidArguments("Marker object is missing the required 'coordinate' property")
		}

		guard let lat = latLngObj["lat"] as? Double, let lng = latLngObj["lng"] as? Double else {
			throw GoogleMapErrors.invalidArguments("LatLng object is missing the required 'lat' and/or 'lng' property")
		}

		var iconSize: CGSize?
		if let sizeObj = fromJSObject["iconSize"] as? JSObject {
			if let width = sizeObj["width"] as? Double, let height = sizeObj["height"] as? Double {
				iconSize = CGSize(width: width, height: height)
			}
		}

		var iconAnchor: CGPoint?
		if let anchorObject = fromJSObject["iconAnchor"] as? JSObject {
			if let x = anchorObject["x"] as? Double, let y = anchorObject["y"] as? Double {
				if let size = iconSize {
					let u = x / size.width
					let v = y / size.height
					iconAnchor = CGPoint(x: u, y: v)
				}
			}
		}

		var tintColor: UIColor?
		if let rgbObject = fromJSObject["tintColor"] as? JSObject {
			if let r = rgbObject["r"] as? Double, let g = rgbObject["g"] as? Double, let b = rgbObject["b"] as? Double, let a = rgbObject["a"] as? Double {
				let uiColorR = CGFloat(r / 255).clamp(min: 0, max: 255)
				let uiColorG = CGFloat(g / 255).clamp(min: 0, max: 255)
				let uiColorB = CGFloat(b / 255).clamp(min: 0, max: 255)
				tintColor = UIColor(red: uiColorR, green: uiColorG, blue: uiColorB, alpha: CGFloat(a))
			}
		}

		self.coordinate = LatLng(lat: lat, lng: lng)
		self.opacity = fromJSObject["opacity"] as? Float
		self.title = fromJSObject["title"] as? String
		self.snippet = fromJSObject["snippet"] as? String
		self.isFlat = fromJSObject["isFlat"] as? Bool
		self.iconUrl = fromJSObject["iconUrl"] as? String
		self.draggable = fromJSObject["draggable"] as? Bool
		self.iconSize = iconSize
		self.iconAnchor = iconAnchor
		self.color = tintColor
		self.zIndex = Int32((fromJSObject["zIndex"] as? Int) ?? 0)

		// Handle the base64 image (if provided)
		if let iconUrl = self.iconUrl, iconUrl.hasPrefix("data:image/png;base64,") {
			if let base64Data = Data(base64Encoded: iconUrl.replacingOccurrences(of: "data:image/png;base64,", with: "")) {
				self.icon = UIImage(data: base64Data)
				self.iconUrl = nil // Remove iconUrl after assigning the icon

				if self.icon == nil {
					print("Base64 image conversion failed.")
				} else {
					print("Base64 image successfully converted.")
				}
			}
		}
	}
}

extension CGFloat {
	func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
		if self < min {
			return min
		}
		if self > max {
			return max
		}
		return self
	}
}
