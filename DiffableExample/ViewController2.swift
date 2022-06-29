import UIKit

struct TopItem: Hashable {
    let title: String
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Post: Hashable {
    let title: String
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct BottomItem: Hashable {
    let title: String
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

class ViewController2: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    typealias DataSource = UITableViewDiffableDataSource<Section, AnyHashable>

    @IBOutlet weak var tableView: UITableView!

    enum Section: CaseIterable {
        case top
        case post
        case bottom
    }
    
    var dataSource: DataSource!
    
    var topItem = TopItem(title: "탑 메세지")
    var bottomItem = BottomItem(title: "바텀 메세지")
    
    var posts: [Post] = [
        Post(title: "포스팅 1"),
        Post(title: "포스팅 2"),
        Post(title: "포스팅 3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        applyInitialSnapshot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.replaceTopMessage()
        }
    }
    
    private func setupTableView() {
        let cellProvider = { (tableView: UITableView, indexPath: IndexPath, item: AnyHashable) -> UITableViewCell? in
            if let post = item as? Post {
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = post.title
                return cell
            }
            
            if let top = item as? TopItem {
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = top.title
                return cell
            }
            
            if let bottom = item as? BottomItem {
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = bottom.title
                return cell
            }
            
            return nil
        }
        
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([topItem], toSection: .top)
        snapshot.appendItems(posts, toSection: .post)
        snapshot.appendItems([bottomItem], toSection: .bottom)
        dataSource.defaultRowAnimation = .none
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func replaceTopMessage() {
        topItem = TopItem(title: "새로운 탑 메세지")
        
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.top])
        
        dataSource.defaultRowAnimation = .none
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
