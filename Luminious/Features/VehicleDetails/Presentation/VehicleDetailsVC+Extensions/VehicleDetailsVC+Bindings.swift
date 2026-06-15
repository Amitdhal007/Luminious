import MapKit
import SDWebImage
import UIKit

extension VehicleDetailsVC {

    @MainActor
    internal func configure() {

        viewModel.onPlaybackMove = {
            [weak self]
            coordinate in

            guard let self
            else {
                return
            }

            playbackAnimationTask?
                .cancel()

            playbackAnimationTask =
                Task { [weak self] in

                    guard let self,
                        let vehicleAnnotation
                    else {
                        return
                    }

                    guard !Task.isCancelled
                    else {
                        return
                    }

                    let current =
                        vehicleAnnotation.coordinate

                    let heading =
                        current.heading(
                            to: coordinate
                        )

                    if let vehicleView =
                        playbackMapView.view(
                            for: vehicleAnnotation
                        ) as? PlayBackVehicleAnnotationView
                    {

                        vehicleView.updateHeading(
                            heading,
                            mapHeading:
                                playbackMapView.camera.heading
                        )
                    }

                    await animateVehicle(
                        to: coordinate
                    )
                }
        }

        viewModel.onPlaybackEnd = { [weak self] in

            guard let self
            else {
                return
            }

            updateTripStatus()

            updatePlaybackButtons()
        }

        updateTripStatus()

        updatePlaybackButtons()
    }

    @MainActor
    internal func bind() {

        driverNameLabel.text =
            viewModel.driverName

        ratingLabel.text =
            viewModel.rating

        vehicleNumberLabel.text =
            viewModel.vehicleNumber

        vehicleTypeLabel.text =
            viewModel.vehicleType

        currentLocationLabel.text =
            viewModel.locationText

        fromLocationLabel.text =
            viewModel.fromLocation

        fromTimeLabel.text =
            viewModel.fromTime

        toLocationLabel.text =
            viewModel.toLocation

        toTimeLabel.text =
            viewModel.toTime

        tripDateLabel.text =
            viewModel.tripDate

        driverImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium

        driverImageView.sd_setImage(
            with: viewModel.vehicle.driverAvatarURL,
            placeholderImage: UIImage(
                systemName: "person.circle.fill"
            )
        )
    }

    internal func updateTripStatus() {

        createdStatusButton.isHidden =
            !viewModel.isCreated

        runningStatusButton.isHidden =
            !viewModel.isRunning

        completedStatusButton.isHidden =
            !viewModel.isCompleted

        playbackMapContainer.isHidden =
            !viewModel.showPlayback
    }

    internal func updatePlaybackButtons() {

        playButton.isHidden =
            !viewModel.showPlay

        pauseButton.isHidden =
            !viewModel.showPause

        stopButton.isHidden =
            !viewModel.showStop
    }
}
