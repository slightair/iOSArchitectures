import Foundation
import UIKit

public class ColorItemCell: UITableViewCell {
    let colorView = UIView()
    let nameLabel = UILabel()

    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(colorView)
        addSubview(nameLabel)

        colorView.layer.cornerRadius = 3.0
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(with colorItem: ColorItem) {
        colorView.backgroundColor = colorItem.color
        nameLabel.text = colorItem.name
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        colorView.frame = CGRect(x: 8, y: (frame.height - 32) / 2, width: 32, height: 32)
        nameLabel.frame = CGRect(x: colorView.frame.maxX + 8, y: (frame.height - 21) / 2, width: 200, height: 21)
    }
}
