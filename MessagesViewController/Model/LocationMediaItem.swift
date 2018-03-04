//
//  LocationMediaItem.swift
//  PlaygroundLibrary
//
//  Created by TOYOTA KMOTORS on 27/2/2561 BE.
//  Copyright © 2561 papcoe. All rights reserved.
//

import Foundation
import MapKit

class LocationMediaItem: MediaItem, MKAnnotation {
    
    var location: CLLocation
    var cachedMapSnapshotImage: UIImage!
    var cachedMapImageView: UIImageView!
    var coordinate: CLLocationCoordinate2D { return location.coordinate }
    typealias LocationMediaItemCompletionBlock = () -> Void
    
    init(location: CLLocation) {
        self.location = location
        super.init(isOutgoing: true)
    }
    
    override func setAppliesMediaViewMaskAsOutgoing(_ appliesMediaViewMaskAsOutgoing: Bool) {
        super.setAppliesMediaViewMaskAsOutgoing(appliesMediaViewMaskAsOutgoing)
        cachedMapSnapshotImage = nil
        cachedMapImageView = nil
    }
    
    func setLocation(_ location: CLLocation, withCompletionHandler completion: LocationMediaItemCompletionBlock?) {
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0)
        setLocation(location, region: region, withCompletionHandler: completion)
    }
    
    func setLocation(_ location: CLLocation, region: MKCoordinateRegion, withCompletionHandler completion: LocationMediaItemCompletionBlock?) {
        self.location = location
        cachedMapSnapshotImage = nil
        cachedMapImageView = nil
        createMapViewSnapshot(forLocation: location, region: region, completion: completion)
    }
    
    func createMapViewSnapshot(forLocation location: CLLocation, region: MKCoordinateRegion, completion: LocationMediaItemCompletionBlock?) {
        
        let options = MKMapSnapshotOptions()
        options.region = region
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start(with: DispatchQueue.main) { (snapshot, error) in
            
            if let snapshot = snapshot {
                
                let image = snapshot.image
                let pin = MKPinAnnotationView()
                var coordinatePoint = snapshot.point(for: location.coordinate)
                coordinatePoint.x += pin.centerOffset.x - (pin.bounds.width / 2.0)
                coordinatePoint.y += pin.centerOffset.y - (pin.bounds.height / 2.0)
                
                UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
                image.draw(at: CGPoint.zero)
                pin.image?.draw(at: coordinatePoint)
                self.cachedMapSnapshotImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    completion?()
                }
            }else{
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    override var mediaView: UIView? {
        if self.cachedMapSnapshotImage == nil {
            return nil
        }
        if cachedMapImageView == nil {
            
            let size = self.mediaViewDisplaySize
            let point = CGPoint.zero
            let frame = CGRect(origin: point, size: size)
            let imageView = UIImageView(image: cachedMapSnapshotImage)
            imageView.frame = frame
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            MessagesMediaViewBubbleImageMasker.applyBubbleImageMask(toMediaView: imageView, isOutgoing: self.appliesMediaViewMaskAsOutgoing)
            self.cachedMapImageView = imageView
        }
        return cachedMapImageView
    }
}
