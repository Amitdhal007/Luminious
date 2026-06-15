import UIKit

public final class IconAppleToastView: UIStackView {

    // MARK: - Views

    private lazy var vStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var symbolContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40),
        ])

        return view
    }()

    private lazy var imageView: UIImageView = {

        let imageView = UIImageView()

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = toastStyle.tintColor

        imageView.preferredSymbolConfiguration = .init(
            pointSize: 22,
            weight: .semibold,
            scale: .medium
        )

        NSLayoutConstraint.activate([

            imageView.widthAnchor.constraint(
                equalToConstant: 24
            ),

            imageView.heightAnchor.constraint(
                equalToConstant: 24
            )
        ])

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()

        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Properties

    private let toastStyle: ToastStyle

    // MARK: - Init

    public init(
        toastStyle: ToastStyle,
        title: String,
        subtitle: String? = nil
    ) {

        self.toastStyle = toastStyle

        super.init(frame: .zero)

        commonInit()

        configureContent(
            title: title,
            subtitle: subtitle
        )

        configureSymbol()

        startAnimation()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

extension IconAppleToastView {

    private func commonInit() {

        axis = .horizontal
        spacing = 10
        alignment = .center
        distribution = .fill

        addArrangedSubview(symbolContainerView)
        addArrangedSubview(vStack)
    }

    private func configureContent(
        title: String,
        subtitle: String?
    ) {

        titleLabel.text = title
        vStack.addArrangedSubview(titleLabel)

        if let subtitle,
            !subtitle.isEmpty
        {

            subtitleLabel.text = subtitle
            vStack.addArrangedSubview(subtitleLabel)
        }
    }

    private func configureSymbol() {

        imageView.image = UIImage(
            systemName: toastStyle.symbolName
        )

        symbolContainerView.addSubview(imageView)

        NSLayoutConstraint.activate([

            imageView.centerXAnchor.constraint(
                equalTo: symbolContainerView.centerXAnchor
            ),

            imageView.centerYAnchor.constraint(
                equalTo: symbolContainerView.centerYAnchor
            )
        ])
    }
}

// MARK: - Animation

extension IconAppleToastView {

    private func startAnimation() {

        switch toastStyle {

        case .success:

            imageView.addSymbolEffect(
                .bounce,
                options: .repeating
            )

        case .error:

            imageView.addSymbolEffect(
                .breathe,
                options: .repeating
            )

        case .warning:

            imageView.addSymbolEffect(
                .pulse,
                options: .repeating
            )

        case .info:

            imageView.addSymbolEffect(
                .variableColor.iterative,
                options: .repeating
            )
        }
    }
}
