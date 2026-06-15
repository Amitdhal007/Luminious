import MapKit
import SDWebImage
import UIKit

extension VehicleDetailsVC {

    internal func initialSetup() {

        setupGlassContainer()

        setupMapView()

        configure()

        bind()

        loadRoute()
    }

    internal func cleanup() {

        playbackAnimationTask?
            .cancel()

        routeLoadTask?
            .cancel()

        viewModel
            .stopPlayback()

        viewModel
            .onPlaybackMove = nil
    }

    internal func setupMapView() {

        playbackMapView.delegate =
            self

        // MARK: - User

        playbackMapView.showsUserLocation =
            false

        playbackMapView.userTrackingMode =
            .none

        // MARK: - UI Cleanup

        playbackMapView.pointOfInterestFilter =
            .excludingAll

        playbackMapView.showsCompass =
            false

        playbackMapView.showsScale =
            false

        playbackMapView.showsTraffic =
            false

        playbackMapView.showsBuildings =
            true

        playbackMapView.showsLargeContentViewer =
            false

        // MARK: - Interaction

        playbackMapView.isRotateEnabled =
            false

        playbackMapView.isPitchEnabled =
            true

        playbackMapView.isZoomEnabled =
            true

        playbackMapView.isScrollEnabled =
            true

        // MARK: - Appearance

        playbackMapView.overrideUserInterfaceStyle =
            .dark

        let configuration =
            MKStandardMapConfiguration(
                elevationStyle:
                    .realistic
            )

        configuration.pointOfInterestFilter =
            .excludingAll

        configuration.emphasisStyle =
            .muted

        playbackMapView.preferredConfiguration =
            configuration

        // MARK: - Camera

        playbackMapView.camera =
            MKMapCamera(
                lookingAtCenter:
                    CLLocationCoordinate2D(
                        latitude: 0,
                        longitude: 0
                    ),

                fromDistance:
                    1800,

                pitch:
                    60,

                heading:
                    0
            )

        playbackMapView.cameraZoomRange =
            MKMapView
            .CameraZoomRange(

                minCenterCoordinateDistance:
                    400,

                maxCenterCoordinateDistance:
                    8000
            )
    }
}
