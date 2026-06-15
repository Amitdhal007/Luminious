import UIKit
import Combine

public final class LiquidGlassButton:
    UIView
{

    // MARK: - Public

    public var tapPublisher:
        AnyPublisher<
            LiquidGlassButtonAction,
            Never
        >
    {
        tapSubject.eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {

        CGSize(
            width: 56,
            height: 56
        )
    }

    // MARK: - Private

    private let tapSubject =
        PassthroughSubject<
            LiquidGlassButtonAction,
            Never
        >()

    // MARK: - UI

    private let glassEffectView:
        UIVisualEffectView =
    {
        let effect =
            UIGlassEffect(
                style: .clear
            )

        effect.isInteractive =
            true

        let view =
            UIVisualEffectView(
                effect: effect
            )

        view.translatesAutoresizingMaskIntoConstraints =
            false

        return view
    }()

    private let button =
        UIButton(
            type: .system
        )

    // MARK: - Init

    public init(
        image: UIImage?
    ) {

        super.init(
            frame: .zero
        )

        setupView(
            image: image
        )
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout

    public override func layoutSubviews() {

        super.layoutSubviews()

        glassEffectView.layer.cornerRadius =
            min(
                bounds.width,
                bounds.height
            ) / 2
    }
}

// MARK: - Setup

private extension LiquidGlassButton {

    func setupView(
        image: UIImage?
    ) {

        translatesAutoresizingMaskIntoConstraints =
            false

        addSubview(
            glassEffectView
        )

        NSLayoutConstraint.activate([

            glassEffectView.topAnchor.constraint(
                equalTo: topAnchor
            ),

            glassEffectView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),

            glassEffectView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),

            glassEffectView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            )
        ])

        clipsToBounds =
            false

        setupButton(
            image: image
        )
    }

    func setupButton(
        image: UIImage?
    ) {

        button.translatesAutoresizingMaskIntoConstraints =
            false

        var configuration =
            UIButton.Configuration.plain()

        configuration.image =
            image

        configuration.baseForegroundColor =
            .white

        configuration.preferredSymbolConfigurationForImage =
            UIImage.SymbolConfiguration(
                pointSize: 22,
                weight: .medium
            )

        button.configuration =
            configuration

        glassEffectView.contentView
            .addSubview(
                button
            )

        NSLayoutConstraint.activate([

            button.topAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .topAnchor
            ),

            button.leadingAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .leadingAnchor
            ),

            button.trailingAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .trailingAnchor
            ),

            button.bottomAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .bottomAnchor
            )
        ])

        button.addTarget(
            self,
            action:
                #selector(
                    handleTap
                ),
            for:
                .touchUpInside
        )
    }

    @objc
    func handleTap() {

        tapSubject.send(
            .tapped
        )
    }
}
