import UIKit

typealias ItemSelectableProviding = ItemProviding & ItemSelectable
typealias UIConfigurableCollectionViewCell = UICollectionViewCell & Configurable

protocol ItemProviding {
    associatedtype Item
    var item: Item { get }
}

protocol ItemSelectable {
    var isSelectable: Bool { get }
}

protocol Configurable {
    associatedtype Item = ItemProviding
    func setup(with viewModel: Item)
}
