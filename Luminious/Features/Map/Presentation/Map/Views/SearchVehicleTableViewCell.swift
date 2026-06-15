import UIKit

final class SearchVehicleTableViewCell:
    UITableViewCell
{

    static let reuseIdentifier =
        "SearchVehicleTableViewCell"

    // MARK: - UI

    private let glassView: UIVisualEffectView =
        {
            let effect =
                UIGlassEffect(
                    style: .clear
                )

            effect.tintColor = .black.withAlphaComponent(0.2)

            let view =
                UIVisualEffectView(
                    effect: effect
                )

            view.translatesAutoresizingMaskIntoConstraints =
                false

            view.layer.cornerRadius =
                20

            view.clipsToBounds =
                true

            return view
        }()

    private let driverLabel =
        UILabel()

    private let vehicleLabel =
        UILabel()

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Setup

extension SearchVehicleTableViewCell {

    private func setupView() {

        backgroundColor =
            .clear

        selectionStyle =
            .none

        contentView.backgroundColor =
            .clear

        contentView.addSubview(
            glassView
        )

        NSLayoutConstraint.activate([

            glassView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 6
            ),

            glassView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: .zero
            ),

            glassView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: .zero
            ),

            glassView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -6
            ),
        ])

        driverLabel.translatesAutoresizingMaskIntoConstraints =
            false

        driverLabel.textColor = .white

        driverLabel.font =
            .systemFont(
                ofSize: 17,
                weight: .semibold
            )

        vehicleLabel.translatesAutoresizingMaskIntoConstraints =
            false

        vehicleLabel.font =
            .systemFont(
                ofSize: 14,
                weight: .medium
            )

        vehicleLabel.textColor =
            .white

        glassView.contentView.addSubview(
            driverLabel
        )

        glassView.contentView.addSubview(
            vehicleLabel
        )

        NSLayoutConstraint.activate([

            driverLabel.topAnchor.constraint(
                equalTo:
                    glassView.contentView.topAnchor,
                constant: 14
            ),

            driverLabel.leadingAnchor.constraint(
                equalTo:
                    glassView.contentView.leadingAnchor,
                constant: 16
            ),

            driverLabel.trailingAnchor.constraint(
                equalTo:
                    glassView.contentView.trailingAnchor,
                constant: -16
            ),

            vehicleLabel.topAnchor.constraint(
                equalTo:
                    driverLabel.bottomAnchor,
                constant: 4
            ),

            vehicleLabel.leadingAnchor.constraint(
                equalTo:
                    driverLabel.leadingAnchor
            ),

            vehicleLabel.trailingAnchor.constraint(
                equalTo:
                    driverLabel.trailingAnchor
            ),

            vehicleLabel.bottomAnchor.constraint(
                equalTo:
                    glassView.contentView.bottomAnchor,
                constant: -14
            ),
        ])
    }
}

// MARK: - Configure

extension SearchVehicleTableViewCell {

    func configure(
        with vehicle: Vehicle
    ) {

        driverLabel.text =
            vehicle.driverName

        vehicleLabel.text =
            vehicle.vehicleNumber
    }
}
