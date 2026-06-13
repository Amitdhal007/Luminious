import Combine
import UIKit

public final class LiquidGlassSearchBar:
    UIView
{

    // MARK: - Public

    public var actionPublisher:
        AnyPublisher<
            LiquidGlassSearchBarAction,
            Never
        >
    {
        actionSubject
            .eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {

        CGSize(
            width: UIView.noIntrinsicMetric,
            height: 56
        )
    }

    // MARK: - Private

    private let actionSubject =
        PassthroughSubject<
            LiquidGlassSearchBarAction,
            Never
        >()

    // MARK: - UI

    private let glassEffectView: UIVisualEffectView =
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

    private let searchBar =
        UISearchBar()

    // MARK: - Init

    public override init(
        frame: CGRect
    ) {

        super.init(
            frame: frame
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout

    public override func layoutSubviews() {

        super.layoutSubviews()

        glassEffectView.layer.cornerRadius =
            bounds.height / 2
    }
    
    public func setInteractionEnabled(
        _ isEnabled: Bool
    ) {

        searchBar.isUserInteractionEnabled =
            isEnabled
    }
}

// MARK: - Setup

extension LiquidGlassSearchBar {

    fileprivate func setupView() {

        translatesAutoresizingMaskIntoConstraints =
            false

        setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )

        setContentHuggingPriority(
            .defaultLow,
            for: .horizontal
        )

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
            ),
        ])

        glassEffectView.clipsToBounds =
            true

        setupSearchBar()
    }

    fileprivate func setupSearchBar() {

        searchBar.translatesAutoresizingMaskIntoConstraints =
            false

        searchBar.delegate =
            self

        searchBar.placeholder =
            "Search vehicles"

        searchBar.searchBarStyle =
            .prominent

        searchBar.backgroundImage =
            UIImage()

        searchBar.backgroundColor =
            .clear

        searchBar.tintColor =
            .white

        glassEffectView
            .contentView
            .addSubview(
                searchBar
            )

        NSLayoutConstraint.activate([

            searchBar.topAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .topAnchor
            ),

            searchBar.leadingAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .leadingAnchor
            ),

            searchBar.trailingAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .trailingAnchor
            ),

            searchBar.bottomAnchor.constraint(
                equalTo:
                    glassEffectView
                    .contentView
                    .bottomAnchor
            ),
        ])

        configureSearchField()
    }
}

// MARK: - Search Field Styling

extension LiquidGlassSearchBar {

    fileprivate func configureSearchField() {

        let field =
            searchBar.searchTextField

        field.backgroundColor =
            .clear

        field.borderStyle =
            .none

        field.textColor =
            .white

        field.tintColor =
            .white

        field.font =
            .systemFont(
                ofSize: 17,
                weight: .semibold
            )

        field.attributedPlaceholder =
            NSAttributedString(
                string:
                    "Search vehicles",
                attributes: [

                    .foregroundColor:
                        UIColor.white
                        .withAlphaComponent(
                            0.75
                        ),

                    .font:
                        UIFont.systemFont(
                            ofSize: 17,
                            weight: .medium
                        ),
                ]
            )

        field.clearButtonMode =
            .whileEditing

        field.leftView?.tintColor =
            .white

        field.rightView?.tintColor =
            .white

        if let clearButton = field.value(forKey: "clearButton") as? UIButton {

            let templateImage = clearButton.imageView?.image?.withRenderingMode(
                .alwaysTemplate
            )

            clearButton.setImage(templateImage, for: .normal)

            clearButton.tintColor = .white
        }
    }
}

// MARK: - UISearchBarDelegate

extension LiquidGlassSearchBar:
    UISearchBarDelegate
{

    public func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {

        if searchText.isEmpty {

            actionSubject.send(
                .clearTapped
            )
        }

        actionSubject.send(
            .textChanged(
                searchText
            )
        )
    }

    public func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {

        actionSubject.send(
            .searchSubmitted(
                searchBar.text ?? ""
            )
        )

        searchBar.resignFirstResponder()
    }
}

// MARK: - Public API

extension LiquidGlassSearchBar {

    public var text: String {

        searchBar.text ?? ""
    }

    public func clear() {

        searchBar.text = ""

        actionSubject.send(
            .clearTapped
        )

        actionSubject.send(
            .textChanged("")
        )
    }

    public func focus() {

        searchBar
            .becomeFirstResponder()
    }

    public func resign() {

        searchBar
            .resignFirstResponder()
    }

    public func setPlaceholder(
        _ text: String
    ) {

        searchBar.placeholder =
            text

        let field =
            searchBar.searchTextField

        field.attributedPlaceholder =
            NSAttributedString(
                string: text,
                attributes: [

                    .foregroundColor:
                        UIColor.white
                        .withAlphaComponent(
                            0.75
                        ),

                    .font:
                        UIFont.systemFont(
                            ofSize: 17,
                            weight: .medium
                        ),
                ]
            )
    }
}
