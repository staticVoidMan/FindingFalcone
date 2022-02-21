import UIKit
import FindingFalconeCore

class JourneyCell: UITableViewCell {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var readyStatusIndicator: StatusLight!
    
    @IBOutlet private var destinationTitleLabel: UILabel!
    
    @IBOutlet private var planetContainer: UIView!
    @IBOutlet private var vehicleContainer: UIView!
    
    @IBOutlet private var planetTitleLabel: UILabel!
    @IBOutlet private var vehicleTitleLabel: UILabel!
    
    @IBOutlet private var planetSubtitleLabel: UILabel!
    @IBOutlet private var vehicleSubtitleLabel: UILabel!
    
    @IBOutlet private var planetImageView: UIImageView!
    @IBOutlet private var vehicleImageView: UIImageView!
    
    private lazy var selectPlanetGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(selectPlanetGestureTapped(_:)))
        return gesture
    }()
    
    private lazy var selectVehicleGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(selectVehicleGestureTapped(_:)))
        return gesture
    }()
    
    var selectPlanet: VoidHandler?
    var selectVehicle: VoidHandler?
    
    private var viewModel: JourneyCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
        planetContainer.addGestureRecognizer(selectPlanetGesture)
        vehicleContainer.addGestureRecognizer(selectVehicleGesture)
    }
    
    func setup(with viewModel: JourneyCellVM) {
        self.viewModel = viewModel
        
        destinationTitleLabel.text = viewModel.destinationTitleText
        planetTitleLabel.text = viewModel.planetTitleText
        vehicleTitleLabel.text = viewModel.vehicleTitleText
        
        planetSubtitleLabel.text = viewModel.planetSubtitleText
        vehicleSubtitleLabel.text = viewModel.vehicleSubtitleText
        
        readyStatusIndicator.update(viewModel.readyStatus)
        
        planetImageView.image = UIImage(named: viewModel.planetImageName)
        vehicleImageView.image = UIImage(named: viewModel.vehicleImageName)
    }
    
    @objc
    private func selectPlanetGestureTapped(_ sender: UITapGestureRecognizer) {
        selectPlanet?()
    }
    
    @objc
    private func selectVehicleGestureTapped(_ sender: UITapGestureRecognizer) {
        if !viewModel.isPlanetSelected {
            selectPlanet?()
        } else {
            selectVehicle?()
        }
    }
}
