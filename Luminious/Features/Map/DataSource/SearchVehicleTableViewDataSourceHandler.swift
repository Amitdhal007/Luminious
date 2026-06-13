import UIKit

final class SearchVehicleTableViewDataSourceHandler:
    NSObject
{

    // MARK: - Dependencies

    private let viewModel:
        SearchVehicleViewModel

    // MARK: - Init

    init(
        viewModel: SearchVehicleViewModel
    ) {

        self.viewModel =
            viewModel
    }
}

// MARK: - UITableViewDataSource

extension SearchVehicleTableViewDataSourceHandler:
    UITableViewDataSource
{

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.vehicles.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier:
                        SearchVehicleTableViewCell
                            .reuseIdentifier,
                    for: indexPath
                ) as? SearchVehicleTableViewCell
        else {
            return UITableViewCell()
        }

        let vehicle =
            viewModel.vehicles[
                indexPath.row
            ]

        cell.configure(
            with: vehicle
        )

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchVehicleTableViewDataSourceHandler:
    UITableViewDelegate
{

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        let vehicle =
            viewModel.vehicles[
                indexPath.row
            ]

        viewModel.selectVehicle(
            vehicle
        )
    }
}
