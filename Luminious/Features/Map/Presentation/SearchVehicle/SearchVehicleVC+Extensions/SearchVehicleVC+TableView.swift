import UIKit

extension SearchVehicleVC {

    public func configureTableView() {

        searchTableView.register(
            SearchVehicleTableViewCell.self,
            forCellReuseIdentifier:
                SearchVehicleTableViewCell.reuseIdentifier
        )

        tableViewHandler =
            SearchVehicleTableViewDataSourceHandler(
                viewModel: viewModel
            )
        
        tableViewHandler.delegate =
            self

        searchTableView.dataSource =
            tableViewHandler

        searchTableView.delegate =
            tableViewHandler

        searchTableView.rowHeight =
            UITableView.automaticDimension

        searchTableView.estimatedRowHeight =
            80
        
        searchTableView.separatorStyle = .none

        searchTableView.showsVerticalScrollIndicator =
            false
    }
}
extension SearchVehicleVC:
    SearchVehicleTableViewDataSourceHandlerDelegate
{

    func searchVehicleHandler(
        _ handler: SearchVehicleTableViewDataSourceHandler,
        didSelect vehicle: Vehicle
    ) {

        dismiss(
            animated: true
        )
    }
}
