import Combine
import UIKit

public final class DarkGlassSearchBar: UIView {

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

    private let glassEffectView:
        UIVisualEffectView =
        {
            let effect =
                UIGlassEffect(
                    style: .clear
                )

            effect.isInteractive =
                true

            effect.tintColor =
                .black
                .withAlphaComponent(
                    0.35
                )

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

        glassEffectView.layer.masksToBounds =
            true
    }
}

// MARK: - Setup

extension DarkGlassSearchBar {

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
            .minimal

        searchBar.backgroundImage =
            UIImage()

        searchBar.setBackgroundImage(
            UIImage(),
            for: .any,
            barMetrics: .default
        )

        searchBar.backgroundColor =
            .clear

        searchBar.isTranslucent =
            true

        searchBar.tintColor =
            .black

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

extension DarkGlassSearchBar {

    fileprivate func configureSearchField() {

        let field =
            searchBar.searchTextField

        field.backgroundColor =
            .clear

        field.layer.backgroundColor =
            UIColor.clear.cgColor

        field.borderStyle =
            .none

        field.textColor =
            .black

        field.tintColor =
            .black

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
                        UIColor.black
                        .withAlphaComponent(
                            0.5
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
            .black

        field.rightView?.tintColor =
            .black
    }
}

// MARK: - UISearchBarDelegate

extension DarkGlassSearchBar:
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

extension DarkGlassSearchBar {

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
                        UIColor.black
                        .withAlphaComponent(
                            0.5
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
