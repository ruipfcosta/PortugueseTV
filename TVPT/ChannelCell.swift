import Foundation
import UIKit

class ChannelCell: UICollectionViewCell {
    
    lazy var label: UILabel = self.makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.center = contentView.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeLabel() -> UILabel {
        let l = UILabel()
        l.textColor = UIColor.blackColor()
        l.backgroundColor = UIColor.blueColor()
        
        return l
    }
    
}
