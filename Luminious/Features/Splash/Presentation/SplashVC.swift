import Combine
import CoreLocation
import UIKit

final class SplashVC: UIViewController {
    
    public var toast: ToastPresenting!
    public var viewModel: SplashViewModel!
    public weak var coordinator: SplashCoordinating?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let resumeButton = LiquidGlassTextButton(
        text: "Resume Session"
    )
    
    private let newSessionButton = LiquidGlassTextButton(
        text: "New Session"
    )
    
    @IBOutlet weak var bottomButtonContainer: UIStackView!
    @IBOutlet weak var loopVideoView: IntroVideoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
}
extension SplashVC {
    
    private func initialSetup() {
        
        loopVideoView.playIntro(
            named: "introVideo"
        )
        
        setupGlassButtons()
        
        loadSessionState()
    }
    
    @MainActor
    private func updateUI(hasPreviousSession: Bool) {
        
        resumeButton.isHidden = !hasPreviousSession
        newSessionButton.isHidden = false
    }
    
    private func setupGlassButtons() {
        
        bottomButtonContainer.axis = .vertical
        bottomButtonContainer.spacing = 12
        bottomButtonContainer.alignment = .fill
        bottomButtonContainer.distribution = .fillEqually
        
        bottomButtonContainer.addArrangedSubview(resumeButton)
        bottomButtonContainer.addArrangedSubview(newSessionButton)
        
        bindGlassButtons()
    }
    
    private func bindGlassButtons() {
        
        resumeButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                handleResumeSessionTapped()
            }
            .store(in: &cancellables)
        
        newSessionButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                handleNewSessionTapped()
            }
            .store(in: &cancellables)
    }
}
extension SplashVC {
    
    private func loadSessionState() {
        
        toast.show(
            style: .info,
            title: SplashStrings.loadingSessionTitle,
            subtitle: SplashStrings.loadingSessionSubtitle
        )
        
        Task { [weak self] in
            
            guard let self
            else {
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
                    hasPreviousSession: false
                )
                
                await MainActor.run { [weak self] in
                    
                    guard let self
                    else {
                        return
                    }
                    
                    toast.show(
                        style: .error,
                        title: SplashStrings.sessionLoadFailedTitle,
                        subtitle: error.localizedDescription
                    )
                }
            }
        }
    }
}
extension SplashVC {
    
    private func handleNewSessionTapped() {
        
        Task { @MainActor in
            
            guard
                viewModel.locationProvider.isLocationEnabled()
            else {
                newSessionButton.finishLoading()
                showLocationPermissionAlert()
                return
            }
            
            guard
                let vehicleCount = await showVehicleCountPicker()
            else {
                newSessionButton.finishLoading()
                return
            }
            
            do {
                
                let location = try await viewModel.locationProvider
                    .getCurrentLocation()
                
                let session = try await viewModel.createNewSession(
                    vehicleCount: vehicleCount
                )
                
                try await viewModel.bootstrapSession(
                    session,
                    userLocation: .init(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                )
                
                newSessionButton.finishLoading()
                
                coordinator?.splashDidCreateNewSession(session)
                
            } catch {
                
                newSessionButton.finishLoading()
                
                toast.show(
                    style: .error,
                    title: SplashStrings.sessionCreationFailed,
                    subtitle: error.localizedDescription
                )
            }
        }
    }
    
    private func handleResumeSessionTapped() {
        
        Task { @MainActor in
            
            guard
                viewModel.locationProvider.isLocationEnabled()
            else {
                resumeButton.finishLoading()
                showLocationPermissionAlert()
                return
            }
            
            do {
                
                let _ = try await viewModel.locationProvider
                    .getCurrentLocation()
                
                resumeButton.finishLoading()
                
                coordinator?.splashDidRequestResumeSession()
                
            } catch {
                
                resumeButton.finishLoading()
                
                toast.show(
                    style: .error,
                    title: SplashStrings.sessionCreationFailed,
                    subtitle: error.localizedDescription
                )
            }
        }
    }
}
