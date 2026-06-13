import UIKit

public final class CompassEngine {
    
    private let sensor: HeadingSensoring
    private let orientationProvider: OrientationProviding
    private var processor: HeadingProcessing
    
    public weak var delegate: CompassEngineDelegate?
    
    init(
        sensor: HeadingSensoring,
        orientationProvider: OrientationProviding,
        processor: HeadingProcessing
    ) {
        self.sensor = sensor
        self.orientationProvider = orientationProvider
        self.processor = processor
        self.sensor.delegate = self
    }
    
    public func start() {
        sensor.start()
    }
    
    public func stop() {
        sensor.stop()
    }
}
extension CompassEngine: HeadingSensorDelegate {
    
    public func didUpdateRawHeading(_ raw: CGFloat) {
        
        let orientation = orientationProvider.current
        
        let corrected = processor.process(
            raw: raw,
            orientation: orientation
        )
        
        let output = CompassHeading(
            raw: raw,
            corrected: corrected,
            orientation: orientation
        )
        
        delegate?.didUpdateHeading(output)
    }
}
