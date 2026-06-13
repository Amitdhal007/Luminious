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
        
        // Start timers
        // Subscribe to live vehicle updates
    }
    
    func handleScreenWillDisappear() {
        
        // Stop timers
        // Cancel long running work
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
        print("Vehicle count: \(vehicles.count)")

        vehicles.forEach { vehicle in
            print(
                "Vehicle \(vehicle.id): lat=\(vehicle.currentLatitude), lon=\(vehicle.currentLongitude)"
            )
        }

        let existingAnnotations =
            mapView.annotations.filter {
                !($0 is MKUserLocation)
            }

        mapView.removeAnnotations(
            existingAnnotations
        )

        let annotations =
            vehicles.map {
                VehicleAnnotation(
                    vehicle: $0
                )
            }

        print("Annotation count: \(annotations.count)")

        mapView.addAnnotations(
            annotations
        )
    }
}

final class VehicleAnnotation:
    NSObject,
    MKAnnotation {
    
    let vehicle: Vehicle
    
    var coordinate:
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
                
                let vehicle = try await viewModel
                    .loadVehicles(
                        sessionId: session.id
                    )
                
                self
                    .updateVehicleAnnotations(vehicle)
                
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
