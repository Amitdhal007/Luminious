import UIKit

protocol SearchVehicleTableViewDataSourceHandlerDelegate:
    AnyObject
{
    func searchVehicleHandler(
        _ handler: SearchVehicleTableViewDataSourceHandler,
        didSelect vehicle: Vehicle
    )
}

final class SearchVehicleTableViewDataSourceHandler:
    NSObject
{
    
    // MARK: - Dependencies
    
    private let viewModel: SearchVehicleViewModel
    
    public weak var delegate: SearchVehicleTableViewDataSourceHandlerDelegate?
    
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
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchVehicleTableViewCell.reuseIdentifier,
                for: indexPath
            ) as? SearchVehicleTableViewCell,
            let vehicle = viewModel.vehicles[safe: indexPath.row]
        else {
            return UITableViewCell()
        }
        
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
        
        guard
            let vehicle = viewModel.vehicles[
                safe: indexPath.row
            ]
        else {
            return
        }
        
        viewModel.selectVehicle(
            vehicle
        )
        
        delegate?.searchVehicleHandler(
            self,
            didSelect: vehicle
        )
    }
}
