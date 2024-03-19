import UIKit

final class PillNotificationContentViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("계속호출되냐!!!🥲🥲🥲🥲🥲")
    }
    
//    convenience init(index: Int) {
//        self.init(title: "View \(index)", content: "\(index)")
//    }

    convenience init(title: String) {
        self.init(title: title, content: title)
    }

    init(title: String, content: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title

        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
        label.textColor = UIColor(red: 95 / 255, green: 102 / 255, blue: 108 / 255, alpha: 1)
        label.textAlignment = .center
        label.text = content
        label.sizeToFit()

        view.addSubview(label)
        view.constrainToEdges(label)
        view.backgroundColor = .white
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function, " - ContentViewController ✅")
    }
}
