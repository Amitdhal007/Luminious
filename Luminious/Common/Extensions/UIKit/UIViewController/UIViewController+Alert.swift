import UIKit

extension UIViewController {

    @MainActor
    func showVehicleCountPicker() async -> Int? {

        await withCheckedContinuation { continuation in

            let alert = UIAlertController(
                title: VehicleCountPickerStrings.title,
                message: VehicleCountPickerStrings.message,
                preferredStyle: .actionSheet
            )

            [10, 20, 50].forEach { count in

                alert.addAction(
                    UIAlertAction(
                        title:
                            VehicleCountPickerStrings
                            .vehicleTitle(
                                count: count
                            ),
                        style: .default
                    ) { _ in

                        continuation.resume(
                            returning: count
                        )
                    }
                )
            }

            alert.addAction(
                UIAlertAction(
                    title: VehicleCountPickerStrings.cancel,
                    style: .cancel
                ) { _ in

                    continuation.resume(
                        returning: nil
                    )
                }
            )

            present(
                alert,
                animated: true
            )
        }
    }

    @MainActor
    func showLocationPermissionAlert() {

        let alert =
            UIAlertController(
                title:
                    LocationPermissionStrings
                    .title,

                message:
                    LocationPermissionStrings
                    .message,

                preferredStyle:
                    .alert
            )

        alert.addAction(
            UIAlertAction(
                title:
                    LocationPermissionStrings
                    .cancel,

                style:
                    .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title:
                    LocationPermissionStrings
                    .settings,

                style:
                    .default
            ) { _ in

                guard
                    let url =
                        URL(
                            string:
                                UIApplication
                                .openSettingsURLString
                        )
                else {
                    return
                }

                UIApplication
                    .shared
                    .open(
                        url
                    )
            }
        )

        present(
            alert,
            animated:
                true
        )
    }

}
