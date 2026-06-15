import UIKit

// MARK: - Delegate

/// Handles user interactions from the Search Vehicle table.
protocol SearchVehicleTableViewDataSourceHandlerDelegate: AnyObject {

    /// Called when a vehicle is selected from the list.
    func searchVehicleHandler(
        _ handler: SearchVehicleTableViewDataSourceHandler,
        didSelect vehicle: Vehicle
    )
}

// MARK: - Table View Handler

/// Acts as a dedicated UITableViewDataSource and UITableViewDelegate
/// for the Search Vehicle screen.
///
/// Responsibilities:
/// - Provide vehicle data to the table view
/// - Handle row selection
/// - Forward selection events to ViewModel and delegate
final class SearchVehicleTableViewDataSourceHandler: NSObject {

    // MARK: - Dependencies

    /// Source of truth for vehicle list and selection logic
    private let viewModel: SearchVehicleViewModel

    /// Delegate to notify external layers (e.g., coordinator or controller)
    weak var delegate: SearchVehicleTableViewDataSourceHandlerDelegate?

    // MARK: - Init

    init(viewModel: SearchVehicleViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource

extension SearchVehicleTableViewDataSourceHandler: UITableViewDataSource {

    /// Returns number of rows based on available vehicles
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.vehicles.count
    }

    /// Configures and returns cell for given index path
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchVehicleTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? SearchVehicleTableViewCell
        else {
            assertionFailure("Failed to dequeue SearchVehicleTableViewCell")
            return UITableViewCell()
        }

        let vehicle = viewModel.vehicles[indexPath.row]
        cell.configure(with: vehicle)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchVehicleTableViewDataSourceHandler: UITableViewDelegate {

    /// Handles selection of a vehicle row
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        guard let vehicle = viewModel.vehicles[safe: indexPath.row] else {
            return
        }

        // Update ViewModel state
        viewModel.selectVehicle(vehicle)

        // Notify external listener (Coordinator / VC)
        delegate?.searchVehicleHandler(
            self,
            didSelect: vehicle
        )
    }
}
