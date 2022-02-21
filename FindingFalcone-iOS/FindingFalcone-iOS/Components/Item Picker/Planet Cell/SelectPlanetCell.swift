import UIKit

class SelectPlanetCell: UICollectionViewCell, Configurable {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var distanceTitleLabel: UILabel!
    @IBOutlet private var nameValueLabel: UILabel!
    @IBOutlet private var distanceValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    func setup(with viewModel: SelectPlanetCellVM) {
        imageView.image = UIImage(named: viewModel.imageName)
        
        distanceTitleLabel.text = viewModel.distanceTitleText
        
        nameValueLabel.text = viewModel.nameText
        distanceValueLabel.text = viewModel.distanceText
    }
}
