import Combine
import UIKit

extension SearchVehicleVC {

    public func bindViewModel() {

        viewModel.$vehicles
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] _ in

                guard let self
                else {
                    return
                }

                searchTableView.reloadData()
            }
            .store(
                in: &cancellables
            )
    }

    public func bindSearchBar() {

        searchBar.actionPublisher
            .sink { [weak self] action in

                guard let self
                else {
                    return
                }

                switch action {

                case .textChanged(
                    let text
                ):

                    viewModel.search(
                        query: text
                    )

                case .searchSubmitted(
                    let text
                ):

                    viewModel.search(
                        query: text
                    )

                case .clearTapped:

                    viewModel.search(
                        query: ""
                    )
                }
            }
            .store(
                in: &cancellables
            )
    }

    public func bindCloseButton() {

        closeButton.tapPublisher
            .sink { [weak self] _ in

                guard let self
                else {
                    return
                }

                dismiss(
                    animated: true
                )
            }
            .store(
                in: &cancellables
            )
    }
}
