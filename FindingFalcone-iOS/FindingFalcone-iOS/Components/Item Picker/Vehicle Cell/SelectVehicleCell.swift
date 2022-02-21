import UIKit

class SelectVehicleCell: UICollectionViewCell, Configurable {
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var distanceTitleLabel: UILabel!
    @IBOutlet var speedTitleLabel: UILabel!
    @IBOutlet var countTitleLabel: UILabel!
    @IBOutlet var nameValueLabel: UILabel!
    @IBOutlet var distanceValueLabel: UILabel!
    @IBOutlet var speedValueLabel: UILabel!
    @IBOutlet var countValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    func setup(with viewModel: SelectVehicleCellVM) {
        imageView.image = UIImage(named: viewModel.imageName)
        
        distanceTitleLabel.text = viewModel.distanceTitleText
        speedTitleLabel.text = viewModel.speedTitleText
        countTitleLabel.text = viewModel.countTitleText
        
        nameValueLabel.text = viewModel.nameText
        distanceValueLabel.text = viewModel.distanceText
        speedValueLabel.text = viewModel.speedText
        countValueLabel.text = viewModel.countText
        
        self.containerView.alpha = viewModel.isSelectable ? 1 : 0.6
    }
}
