import Combine
import UIKit

/// A custom glass-style search bar component built on UISearchBar.
///
/// Responsibilities:
/// - Encapsulates UISearchBar styling and behavior
/// - Provides consistent UI for vehicle search across the app
/// - Emits user interactions via Combine for reactive architecture integration
///
/// Design decisions:
/// - Uses Combine instead of delegate callbacks for external communication
///   to support MVVM / event-driven architecture
/// - Wraps UIKit search bar to isolate styling complexity from business logic
///
/// Assumptions:
/// - Component is used in a reactive architecture (e.g., MVVM + Coordinator)
/// - Only text search interaction is required
public final class LiquidGlassSearchBar: UIView {

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
        glassEffectView.clipsToBounds = true
    }
}

private extension LiquidGlassSearchBar {

    func setupView() {

        translatesAutoresizingMaskIntoConstraints = false

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

private extension LiquidGlassSearchBar {

    func setupSearchBar() {

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self

        searchBar.placeholder = Self.defaultPlaceholder
        searchBar.searchBarStyle = .prominent
        searchBar.tintColor = .white
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear

        glassEffectView.contentView.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: glassEffectView.contentView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: glassEffectView.contentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: glassEffectView.contentView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: glassEffectView.contentView.bottomAnchor)
        ])

        configureSearchField(searchBar.searchTextField)
    }

    static let defaultPlaceholder = "Search vehicles"
}

private extension LiquidGlassSearchBar {

    func configureSearchField(_ field: UITextField) {

        field.backgroundColor = .clear
        field.borderStyle = .none

        field.textColor = .white
        field.tintColor = .white

        field.font = .systemFont(ofSize: 17, weight: .semibold)

        field.attributedPlaceholder = NSAttributedString(
            string: Self.defaultPlaceholder,
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.75),
                .font: UIFont.systemFont(ofSize: 17, weight: .medium)
            ]
        )

        field.clearButtonMode = .whileEditing
        
        field.leftView?.tintColor = .white
        field.rightView?.tintColor = .white
    }
}

extension LiquidGlassSearchBar: UISearchBarDelegate {

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

extension LiquidGlassSearchBar {
    
    public func setInteractionEnabled(_ enabled: Bool) {
        searchBar.isUserInteractionEnabled = enabled
    }

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
