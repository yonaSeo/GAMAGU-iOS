# [🐦 까마구 GAMAGU](https://apps.apple.com/kr/app/%EA%B9%8C%EB%A7%88%EA%B5%AC-gamagu/id6478485140)
![All](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/8fc2cd0b-beef-46d5-bb54-0e22063d278d)


## 📦 사용 기술
### `CoreData`
- `CoreData`의 `Relationship` 사용하여 엔티티 간의 1:N 관계 설정
<br>

### `UICollectionViewCompositionalLayout`
- `UICollectionViewCompositionalLayout` 사용하여 동적 크기 캐러셀 구현
- `NSCollectionLayoutSection`에 `boundarySupplementaryItems`과 `decorationItems` 속성 사용하여 헤더와 백그라운드 구현
<br>

### `UNUserNotificationCenter`
- 사용자 설정한 알림 주기에 따라 `UNNotificationRequest` 랜덤 배치
- `UNUserNotificationCenterDelegate` 프로토콜의 메서드로 푸시 알림 클릭 시 해당 셀로 이동
<br>


## 🛠️ 기술적 난제
> ### `CoreData` 엔티티 간 관계 설정
#### 💥 *Issue: 카테고리과 이에 속한 아이템 간의 1:N 포함 관계를 설정해야 함*
#### ✅ Solution: `CoreData`의 각 엔티티의 `Relationship` 속성을 설정한다.
<details>
    <summary>xcdatamodel 파일 설정</summary><br>
    <img width="1036" alt="스크린샷 2024-02-28 오후 8 03 42" src="https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/9c9c6274-d0bd-4a09-8b68-50e8ed2fc8b2">
    <img width="1036" alt="스크린샷 2024-02-28 오후 8 01 33" src="https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/1e98a92c-7f9e-420a-a9f9-ff92a2fce51a">
</details>
<details>
  <summary>대상 Relationship이 복수일 경우 추가/삭제 시 extension으로 구현된 메서드 사용</summary><br>
  
  ```swift
  // NSManagedObject
  extension Category {
  
      @objc(addItemsObject:)
      @NSManaged public func addToItems(_ value: Item) // 아이템 1개 추가 시 사용
  
      @objc(removeItemsObject:)
      @NSManaged public func removeFromItems(_ value: Item)
  
      @objc(addItems:)
      @NSManaged public func addToItems(_ values: NSSet)
  
      @objc(removeItems:)
      @NSManaged public func removeFromItems(_ values: NSSet) // 아이템 N개 추가 시 사용
  
  }
  ```
  ```swift
  let itemsList = samples.map { (title: String, content: String) in
      let item = Item(context: context)
      item.title = title
      item.content = content
      item.category = category1
      item.createdDate = Date()
      return item
  }
  
  category1.addToItems(NSSet(array: itemsList)) // 아이템 N개 추가
  ```
</details>
<br>

> ### 동적 크기 캐러셀 구현
#### 💥 *Issue: 케러셀의 카드 셀과 연동하여 해당 카테고리의 배경이 동적으로 변경되는 뷰를 구현해야 함*
#### ✅ Solution: `UICollectionViewCompositionalLayout`의 `decorationItems` 속성을 사용하여 백그라운드를 구현한다.
<details>
  <summary>컬렉션뷰 생성 시 NSCollectionLayoutDecorationItem 백그라운드 재사용 뷰 추가</summary><br>
  
  ```swift
  public let collectionView: UICollectionView = {
      let layout = UICollectionViewCompositionalLayout { _, _ in
          // item, group, 설정...
    
          let section = NSCollectionLayoutSection(group: horizontalGroup)

          // 섹션 객체의 decorationItems에 백그라운드 재사용 뷰 추가
          section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: HomeCollectionBackgroundView.identifier)]
    
          return section
      }
      // 레이아웃 객체에 백그라운드 재사용 뷰 등록
      layout.register(HomeCollectionBackgroundView.self, forDecorationViewOfKind: HomeCollectionBackgroundView.identifier)
      
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      return collectionView
  }()
  ```
</details>
<details>
  <summary>백그라운드 UICollectionReusableView 안에 실제로 사용될 백그라운드 UIView 설정</summary><br>
  
  ```swift
  // 백그라운드 재사용 뷰
  final class HomeCollectionBackgroundView: UICollectionReusableView {
      static let identifier = "CollectionBackgroundView"
      
      private let backgroundView: UIView = { // 실제 백그라운드로 사용되는 뷰
          let view = UIView()
          view.backgroundColor = .primary80
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          addSubview(backgroundView)
          NSLayoutConstraint.activate([
              backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 48),
              backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48),
              backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
              backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
              
          ])
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
  }
  ```
</details>
<br>

> ### 푸시 알림 모달 클릭 시 해당 셀로 이동
#### 💥 *Issue: 푸시 알림을 클릭하면 디폴트 값인 홈 ViewController의 가장 상위 좌표로 이동함*
#### ✅ Solution: `SceneDelegate` 파일에 `UNUserNotificationCenterDelegate`의 프로토콜을 채택하여 이동 로직을 구현한다.
<details>
  <summary>userNotificationCenter(_:didReceive:withCompletionHandler:)메서드에서 홈 ViewController 접근하여 스크롤</summary><br>
  
  ```swift
  func  userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      // 해당 알림의 제목을 키워드로 아이템 조회
      guard let item = CoreDataManager.shared.getItem(title: response.notification.request.content.title) else { return }

      // 해당 알림의 아이템이 속한 카테고리 및 아이템의 인덱스를 추출
      let categoryIndex = CoreDataManager.shared.getCategoryIndex(category: item.category!) ?? 0
      let itemIndex = CoreDataManager.shared.getItemIndexOfCategory(item: item) ?? 0

      // SceneDelegate 객체의 window 객체로부터 홈 ViewController 추출하여 컬렉션 뷰와 테이블 뷰 해당 아이템의 셀 위치로 스크롤
      if let tabBarController = window?.rootViewController as? UITabBarController {
          tabBarController.selectedIndex = 0
          if let navigationController = tabBarController.viewControllers?.first as? UINavigationController,
             let homeVC = navigationController.viewControllers.first as? HomeViewController {
              homeVC.collectionView.scrollToItem(
                  at: IndexPath(item: itemIndex, section: categoryIndex),
                  at: [.centeredHorizontally, .centeredVertically],
                  animated: true
              )
              homeVC.tableView.scrollToRow(
                  at: IndexPath(item: itemIndex, section: categoryIndex),
                  at: .middle,
                  animated: true
              )
          }
      }
  }
  ```
</details>
<br>

## 사용 GIF
![Simulator Screen Recording - iPhone 15 - 2024-02-29 at 00 33 31](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/078ec8fb-a170-49b2-8d54-02f211eb8163)
![Simulator Screen Recording - iPhone 15 - 2024-02-29 at 01 03 07](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/bd13b8b0-3bef-4b9f-955b-981ca3b29f83)
![Simulator Screen Recording - iPhone 15 - 2024-02-29 at 00 43 39](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/d5cecef3-e2d0-4ba9-b48f-c8ac427d3d9d)
![Simulator Screen Recording - iPhone 15 - 2024-02-29 at 01 05 45](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/48c3b9c1-9583-4bf2-9033-679fe4f16c93)
![Simulator Screen Recording - iPhone 15 - 2024-02-29 at 01 07 24](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/44669614-e31c-400c-873b-e96773918a42)
![Simulator Screen Recording - iPhone 15 - 2024-02-29 at 01 20 11](https://github.com/yonaSeo/GAMAGU-iOS/assets/116647009/9446e89a-6392-4d8e-a37e-6b465280eb67)

## 🎨 디자인
 [Figma file](https://www.figma.com/file/t6IQZqETQfYeGlcyvf0mAX/GAMAGU?type=design&node-id=28-3238&mode=design&t=6sWf1leocnY5Sh34-0)
