import Combine
import MapKit
import UIKit

final class MapVC: UIViewController {
    
    public var toast: ToastPresenting!
    public var viewModel: MapViewModel!
    public weak var coordinator: MapCoordinating?
    
    internal var cancellables =
    Set<AnyCancellable>()
    
    internal var mapView: MKMapView!

    private var annotationMap:
        [UUID: VehicleAnnotation] = [:]

    private var currentSessionId: UUID?
    
    private let searchBar =
    LiquidGlassSearchBar()
    
    private let arButton =
    LiquidGlassButton(
        image: UIImage(
            systemName: "arkit"
        )
    )
    
    @IBOutlet weak var arButtonStackView: UIStackView!
    @IBOutlet weak var searchBarStackView: UIStackView!
    @IBOutlet weak var mapContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        loadVehicles()
    }
    
    override func viewWillAppear(
        _ animated: Bool
    ) {
        super.viewWillAppear(animated)
        
        handleScreenWillAppear()
    }
    
    override func viewWillDisappear(
        _ animated: Bool
    ) {
        super.viewWillDisappear(animated)
        
        handleScreenWillDisappear()
    }
}
// MARK: - Setup

private extension MapVC {
    
    func initialSetup() {

        setupMapView()
        centerOnUserLocation()

        configureView()
        configureBindings()

        bindARButton()
        setupSearchTap()
    }

    func setupSearchTap() {

        addTapGesture(
            to: searchBarStackView,
            action: #selector(handleSearchTap)
        )

        searchBar.setInteractionEnabled(false)
        searchBarStackView.isUserInteractionEnabled = true
    }

    @objc
    private func handleSearchTap() {

       let vehicles = viewModel.vehicles

        coordinator?
            .mapDidRequestVehicleSearch(
                vehicles: vehicles
            )
    }
    
    func configureView() {
        
        configureSearchBar()
        
        configureARButton()
    }
    
    func configureSearchBar() {
        
        searchBarStackView
            .addArrangedSubview(
                searchBar
            )
    }
    
    func configureARButton() {
        
        arButtonStackView
            .addArrangedSubview(
                arButton
            )
    }
}

// MARK: - AR

private extension MapVC {
    
    func bindARButton() {
        
        arButton
            .tapPublisher
            .sink { [weak self] _ in
                
                self?
                    .coordinator?
                    .mapDidRequestAR()
            }
            .store(
                in: &cancellables
            )
    }
}

// MARK: - ViewModel Bindings

private extension MapVC {
    
    func configureBindings() {
        
        bindVehicles()
        bindEvents()
    }
    
    func bindVehicles() {

        viewModel
            .vehiclesPublisher
            .drop(while: { $0.isEmpty })
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] vehicles in

                guard let self else {
                    return
                }

                viewModel.vehicles = vehicles

                animateVehicleUpdates(
                    vehicles
                )
            }
            .store(
                in: &cancellables
            )
    }
    
    func bindEvents() {
        
        viewModel
            .eventBus
            .events
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] event in
                
                self?
                    .handleEvent(
                        event
                    )
            }
            .store(
                in: &cancellables
            )
    }
    
    func handleEvent(
        _ event: AppEvent
    ) {
        
        // Handle Event Bus Events
    }
}

// MARK: - Screen Lifecycle

private extension MapVC {
    
    func handleScreenWillAppear() {

        guard let sessionId =
            currentSessionId
        else {
            return
        }

        viewModel.startSimulation(
            sessionId: sessionId
        )
    }
    
    func handleScreenWillDisappear() {

        viewModel.stopSimulation()
    }
}

// MARK: - Map Setup

private extension MapVC {
    
    func setupMapView() {
        
        let mapView =
        MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints =
        false
        
        mapView.delegate =
        self
        
        mapView.showsUserLocation =
        true
        
        mapView.userTrackingMode =
            .none
        
        mapView.pointOfInterestFilter =
            .excludingAll
        
        mapView.showsCompass =
        false
        
        mapView.showsScale =
        false
        
        mapView.showsTraffic =
        false
        
        mapView.isRotateEnabled =
        true
        
        mapView.isPitchEnabled =
        true
        
        mapView.isZoomEnabled =
        true
        
        mapView.isScrollEnabled =
        true
        
        let configuration =
        MKStandardMapConfiguration(
            elevationStyle: .flat
        )
        
        configuration.pointOfInterestFilter =
            .excludingAll
        
        mapView.preferredConfiguration =
        configuration
        
        mapView.overrideUserInterfaceStyle =
            .dark
        
        mapView.cameraBoundary = nil
        mapView.cameraZoomRange =
        MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 200,
            maxCenterCoordinateDistance: 50_000
        )
        
        mapView.layoutMargins.bottom = -100 // removes the 'legal' text
        mapView.layoutMargins.top = -100 // prevents unneeded misplacement of the camera
        
        mapContainerView
            .addSubview(
                mapView
            )
        
        NSLayoutConstraint.activate([
            
            mapView.topAnchor.constraint(
                equalTo:
                    mapContainerView.topAnchor
            ),
            
            mapView.leadingAnchor.constraint(
                equalTo:
                    mapContainerView.leadingAnchor
            ),
            
            mapView.trailingAnchor.constraint(
                equalTo:
                    mapContainerView.trailingAnchor
            ),
            
            mapView.bottomAnchor.constraint(
                equalTo:
                    mapContainerView.bottomAnchor
            )
        ])
        
        self.mapView =
        mapView
    }
}

// MARK: - Vehicle Annotations

private extension MapVC {

    func updateVehicleAnnotations(
        _ vehicles: [Vehicle]
    ) {

        let existingAnnotations =
            mapView.annotations.filter {
                !($0 is MKUserLocation)
            }

        mapView.removeAnnotations(
            existingAnnotations
        )

        annotationMap = [:]

        for vehicle in vehicles {

            let annotation =
                VehicleAnnotation(
                    vehicle: vehicle
                )

            annotationMap[vehicle.id] =
                annotation

            mapView.addAnnotation(
                annotation
            )
        }
    }
}

// MARK: - Smooth Animation

private extension MapVC {

    func animateVehicleUpdates(
        _ vehicles: [Vehicle]
    ) {

        for vehicle in vehicles {

            guard let annotation =
                annotationMap[vehicle.id]
            else {

                // New vehicle appeared — add it
                let newAnnotation =
                    VehicleAnnotation(
                        vehicle: vehicle
                    )

                annotationMap[vehicle.id] =
                    newAnnotation

                mapView.addAnnotation(
                    newAnnotation
                )

                continue
            }

            let newCoordinate =
                CLLocationCoordinate2D(
                    latitude:
                        vehicle.currentLatitude,
                    longitude:
                        vehicle.currentLongitude
                )

            let heading =
                vehicle.currentHeading

            let annotationView =
                mapView.view(
                    for: annotation
                )

            // Duration matches tick interval
            // exactly — no gap, no overlap.
            // .beginFromCurrentState ensures
            // new animations blend from the
            // current interpolated position
            // instead of snapping.
            UIView.animate(
                withDuration: 5.0,
                delay: 0,
                options: [
                    .curveLinear,
                    .beginFromCurrentState,
                    .allowUserInteraction
                ]
            ) {

                annotation.coordinate =
                    newCoordinate

                // Rotate to match heading
                let radians =
                    CGFloat(
                        heading * .pi / 180
                    )

                annotationView?.transform =
                    CGAffineTransform(
                        rotationAngle: radians
                    )
            }
        }
    }
}

final class VehicleAnnotation:
    NSObject,
    MKAnnotation {
    
    let vehicleId: UUID

    let vehicle: Vehicle
    
    dynamic var coordinate:
    CLLocationCoordinate2D
    
    var title: String? {
        vehicle.driverName
    }
    
    var subtitle: String? {
        vehicle.vehicleNumber
    }
    
    init(
        vehicle: Vehicle
    ) {

        self.vehicleId =
            vehicle.id
        
        self.vehicle =
        vehicle
        
        self.coordinate =
        CLLocationCoordinate2D(
            latitude:
                vehicle.currentLatitude,
            longitude:
                vehicle.currentLongitude
        )
        
        super.init()
    }
}

private extension MapVC {
    
    func loadVehicles() {
        
        Task { @MainActor in
            
            do {
                
                guard let session =
                        try await viewModel
                    .fetchCurrentSession()
                else {
                    return
                }

                currentSessionId = session.id
                
                let vehicles = try await viewModel
                    .loadVehicles(
                        sessionId: session.id
                    )
                
                self
                    .updateVehicleAnnotations(
                        vehicles
                    )

                viewModel.startSimulation(
                    sessionId: session.id
                )
                
            } catch {
                
                toast.show(
                    style: .error,
                    title: "Failed to Load Vehicles",
                    subtitle: error.localizedDescription
                )
            }
        }
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(
        _ mapView: MKMapView,
        didUpdate userLocation: MKUserLocation
    ) {
        
        guard let _ = userLocation.location
        else {
            return
        }
        
    }
    
    private func centerOnUserLocation() {
        
        let coordinate =
        viewModel.locationManager.currentLocation.coordinate
        
        let region =
        MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 2_000,
            longitudinalMeters: 2_000
        )
        
        mapView.setRegion(
            region,
            animated: true
        )
    }
}

extension MapVC {

    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {

        guard annotation is VehicleAnnotation else {
            return nil
        }

        let identifier = "VehicleAnnotation"

        var view = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier
        )

        if view == nil {
            view = MKAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )

            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }

        view?.image = UIImage.vehicleMarker

        return view
    }
}
