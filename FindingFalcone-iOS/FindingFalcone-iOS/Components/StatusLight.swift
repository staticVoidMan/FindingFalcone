import UIKit

/// A view that shows the 'readiness' of a task based on `ReadyStatus` values
///
/// You control when the status light animates by providing a `ReadyStatus` value in `update(status:animated)`
///
/// You can change the animation duration by updating the `animationDuration` property.
class StatusLight: UIView {
    private(set) var status: ReadyStatus = .notReady
    
    /// Specifies the duration of the animation when status is updated (default is 1 second)
    var animationDuration: TimeInterval = 1
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayer()
    }
    
    private func setupLayer() {
        update(.notReady, animated: false)
    }
    
    func update(_ status: ReadyStatus, animated: Bool = true) {
        self.status = status
        
        UIView.animate(withDuration: animated ? animationDuration : 0) { [unowned self] in
            self.backgroundColor = self.status.color
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.width/2
        self.layer.shadowColor = UIColor.white.withAlphaComponent(0.75).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
}
