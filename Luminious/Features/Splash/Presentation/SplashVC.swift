import UIKit
internal import _LocationEssentials

final class SplashVC: UIViewController {
    
    public var toast: ToastPresenting!
    public var viewModel: SplashViewModel!
    public weak var coordinator: SplashCoordinating?
    
    @IBOutlet weak var resumeSessionButton: UIButton!
    @IBOutlet weak var newSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    @IBAction func resumeSessionButtonTapped(_ sender: UIButton) {
        
        handleResumeSessionTapped()
    }
    
    @IBAction func newSessionButtonTapped(_ sender: UIButton) {
        
        handleNewSessionTapped()
    }
}

private extension SplashVC {
    
    func initialSetup() {
        
        setButtonsEnabled(true)
        
        loadSessionState()
    }
    
    @MainActor
    func updateUI(
        hasPreviousSession: Bool
    ) {
        
        resumeSessionButton.isHidden =
        !hasPreviousSession
        
        newSessionButton.isHidden =
        false
    }
    
    @MainActor
    func setButtonsEnabled(
        _ enabled: Bool
    ) {
        
        newSessionButton.isEnabled =
        enabled
        
        resumeSessionButton.isEnabled =
        enabled
    }
}

private extension SplashVC {
    
    func loadSessionState() {
        
        toast.show(
            style: .info,
            title:
                SplashStrings
                .loadingSessionTitle,
            subtitle:
                SplashStrings
                .loadingSessionSubtitle
        )
        
        Task { [weak self] in
            
            guard let self else {
                return
            }
            
            do {
                
                let hasPreviousSession =
                try await viewModel
                    .hasPreviousSession()
                
                updateUI(
                    hasPreviousSession:
                        hasPreviousSession
                )
                
            } catch {
                
                updateUI(
                    hasPreviousSession:
                        false
                )
                
                await MainActor.run { [weak self] in
                    
                    guard let self else {
                        return
                    }
                    
                    toast.show(
                        style: .error,
                        title:
                            SplashStrings
                            .sessionLoadFailedTitle,
                        subtitle:
                            error
                            .localizedDescription
                    )
                }
            }
        }
    }
}

private extension SplashVC {
    
    func handleNewSessionTapped() {
        
        Task { @MainActor in
            
            guard let vehicleCount =
                    await showVehicleCountPicker()
            else {
                return
            }
            
            do {
                
                let session =
                try await viewModel
                    .createNewSession(
                        vehicleCount: vehicleCount
                    )
                
                try await viewModel.bootstrapSession(session,
                                     userLocation: .init(
                                        latitude: viewModel.locationProvider.currentLocation.coordinate.latitude,
                                        longitude: viewModel.locationProvider.currentLocation.coordinate.longitude))

                coordinator?
                    .splashDidCreateNewSession(
                        session
                    )
                
            } catch {
                
                toast.show(
                    style: .error,
                    title: SplashStrings.sessionCreationFailed,
                    subtitle: error.localizedDescription
                )
            }
        }
    }
    
    func handleResumeSessionTapped() {
        
        coordinator?
            .splashDidRequestResumeSession()
    }
}
