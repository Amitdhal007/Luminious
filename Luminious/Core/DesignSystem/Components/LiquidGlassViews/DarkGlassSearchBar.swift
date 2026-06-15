import Combine
import UIKit

/// A custom glass-style search bar built on top of UISearchBar.
///
/// Responsibilities:
/// - Encapsulates UISearchBar styling and behavior
/// - Provides reactive event stream via Combine
/// - Ensures consistent design across the application
///
/// Design decisions:
/// - Uses Combine instead of delegate callbacks for external communication
/// - Wraps UISearchBar to isolate UIKit styling complexity from feature modules
///
/// Assumptions:
/// - Component is used inside MVVM or reactive architecture
/// - Only text-based search interaction is required
public final class DarkGlassSearchBar: UIView {

    // MARK: - Public API

    public var actionPublisher: AnyPublisher<LiquidGlassSearchBarAction, Never> {
        actionSubject.eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 56)
    }

    // MARK: - State

    private let actionSubject = PassthroughSubject<LiquidGlassSearchBarAction, Never>()

    // MARK: - UI

    private let glassEffectView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .clear)
        effect.isInteractive = true
        effect.tintColor = .black.withAlphaComponent(0.35)

        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let searchBar = UISearchBar()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        glassEffectView.layer.cornerRadius = bounds.height / 2
        glassEffectView.layer.masksToBounds = true
    }
}

private extension DarkGlassSearchBar {

    func setupView() {

        translatesAutoresizingMaskIntoConstraints = false

        // Allows flexible width inside stack views / layouts
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        addSubview(glassEffectView)

        NSLayoutConstraint.activate([
            glassEffectView.topAnchor.constraint(equalTo: topAnchor),
            glassEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupSearchBar()
    }
}

private extension DarkGlassSearchBar {

    func setupSearchBar() {

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self

        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = .white

        searchBar.placeholder = Self.defaultPlaceholder

        glassEffectView.contentView.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: glassEffectView.contentView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: glassEffectView.contentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: glassEffectView.contentView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: glassEffectView.contentView.bottomAnchor)
        ])

        configureSearchField()
    }
    
    func configureSearchField() {

        let field = searchBar.searchTextField

        field.backgroundColor = .clear
        field.layer.backgroundColor = UIColor.clear.cgColor
        field.borderStyle = .none

        field.textColor = .white
        field.tintColor = .white

        field.font = .systemFont(ofSize: 17, weight: .semibold)

        field.attributedPlaceholder = NSAttributedString(
            string: Self.defaultPlaceholder,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5),
                .font: UIFont.systemFont(ofSize: 17, weight: .medium)
            ]
        )

        field.clearButtonMode = .whileEditing

        field.leftView?.tintColor = .white
        field.rightView?.tintColor = .white
    }

    static let defaultPlaceholder = "Search vehicles"
}

extension DarkGlassSearchBar: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        actionSubject.send(.textChanged(searchText))

        if searchText.isEmpty {
            actionSubject.send(.clearTapped)
        }
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        actionSubject.send(.searchSubmitted(searchBar.text ?? ""))
        searchBar.resignFirstResponder()
    }
}

extension DarkGlassSearchBar {

    public var text: String {
        searchBar.text ?? ""
    }

    public func clear() {
        searchBar.text = ""
        actionSubject.send(.clearTapped)
        actionSubject.send(.textChanged(""))
    }

    public func focus() {
        searchBar.becomeFirstResponder()
    }

    public func resign() {
        searchBar.resignFirstResponder()
    }

    public func setPlaceholder(_ text: String) {
        searchBar.placeholder = text
    }
}
