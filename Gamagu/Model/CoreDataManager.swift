//
//  CoreDataManager.swift
//  Gamagu
//
//  Created by yona on 2/11/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    var items: [Item]?
    var categories: [Category]?
    var userSetting: UserSetting?
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GamaguCoreDataModel")
        persistentContainer.loadPersistentStores { discription, error in
            if let error { print("Failed to load CoreData: \(error.localizedDescription)") }
            // else { print("Sccess to load CoreData") }
        }
        context = persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do { try context.save() }
            catch { print("Failed to save data: \(error.localizedDescription)") }
        }
    }
    
    func fetchData() {
        fetchUserSetting()
        fetchItems()
        fetchCategories()
    }
    
    // MARK: - 초기 데이터 셋업
    func initialDataSetup() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let setting = UserSetting(context: context)
        
        setting.alarmStartTime = dateFormatter.date(from: "09:00")
        setting.alarmEndTime = dateFormatter.date(from: "21:00")
        setting.alarmContentType = AlarmContentType.titleAndContent.rawValue
        setting.alarmSoundType = AlarmSoundType.crowA.rawValue
        setting.isAlarmSoundActive = true
        setting.isCardViewActive = true
        
        let category1 = Category(context: context)
        category1.name = "아이템 설정 🔮"
        category1.alarmCycleDayCount = 1
        category1.alarmPushCount = 1
        category1.createdDate = Date()
        category1.orderNumber = 0
        category1.isAlarmActive = true
        
        let samples1 = [
            (title: "❌아이템 삭제", content: "수정 화면의 삭제 버튼 또는 Table 뷰에서 항목을 왼쪽 ⏪ 방향으로 밀어 나오는 버튼으로 삭제합니다."),
            (title: "✏️아이템 수정", content: "Card 뷰의 카드 또는 Table 뷰의 항목을 탭하면 수정 화면으로 이동하며, 카테고리 또는 아이템을 수정한 뒤 저장합니다."),
            (title: "💡아이템 추가", content: "우상단의 추가 버튼 ➡️ 카테고리를 선택하고 제목, 내용을 입력한 뒤 저장합니다.\n(카테고리가 하나도 없을 경우는 먼저 카테고리를 생성해야 합니다)"),
        ]
        
        let items1 = samples1.map { (title: String, content: String) in
            let item = Item(context: context)
            item.title = title
            item.content = content
            item.category = category1
            item.createdDate = Date()
            return item
        }
        
        let category2 = Category(context: context)
        category2.name = "카테고리 및 기타 설정 📦"
        category2.alarmCycleDayCount = 7
        category2.alarmPushCount = 7
        category2.createdDate = Date()
        category2.orderNumber = 1
        category2.isAlarmActive = true
        
        let samples2 = [
            (title: "🔧사용자 설정 변경", content: "설정 탭 화면에서 알림 시간 범위, 알림 방식, 카테고리를 설정합니다."),
            (title: "♻️카테고리 변경 및 삭제", content: "설정 탭 ➡️ 카테고리 관리 화면으로 이동하여 카테고리의 이름, 알림 활성화 여부, 알림 사이클, 표시 위치를 변경하거나 카테고리를 삭제합니다.\n(설정 변경 시 알림이 사이클에 따라 랜덤 재배치됩니다)"),
            (title: "✨카테고리 생성", content: "설정 탭 ➡️ 카테고리 관리 ➡️ ➕버튼을 탭하면 카테고리 이름을 입력하여 새 카테고리를 생성합니다."),
        ]
        
        let items2 = samples2.map { (title: String, content: String) in
            let item = Item(context: context)
            item.title = title
            item.content = content
            item.category = category1
            item.createdDate = Date()
            return item
        }
        
        category1.addToItems(NSSet(array: items1))
        category2.addToItems(NSSet(array: items2))
        save()
    }
    
    // MARK: - 사용자 설정 데이터 관련
    func fetchUserSetting() {
        let request = UserSetting.fetchRequest()
        
        do { userSetting = try context.fetch(request).first }
        catch { print(error.localizedDescription) }
    }
    
    func getUserSetting() -> UserSetting {
        guard let userSetting else { return UserSetting() }
        return userSetting
    }
    
    // MARK: - 카테고리 데이터 관련
    func fetchCategories() {
        let request = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderNumber", ascending: true)]
        
        do { categories = try context.fetch(request) }
        catch { print(error.localizedDescription) }
    }
    
    func getAllCategories() -> [Category] {
        guard let categories else { return [] }
        return categories
    }
    
    func getCategoriesWithoutNoItem() -> [Category] {
        guard let categories else { return [] }
        return categories.filter { $0.items?.count != 0 }
    }
    
    func getCategory(name: String) -> Category? {
        guard let categories else { fatalError() }
        return categories.filter { $0.name == name }.first
    }
    
    func setCategory(name: String) {
        guard let categories else { return }
        let category = Category(context: context)
        
        category.items = []
        category.name = name
        category.alarmCycleDayCount = 1
        category.alarmPushCount = 1
        category.createdDate = Date()
        category.isAlarmActive = true
        category.orderNumber =
        categories.isEmpty ? 0 : getMaxOrderNumberCategory() + 1
        
        save()
        fetchCategories()
    }
    
    func deleteCategory(deleteCategory: Category) {
        context.delete(deleteCategory)
        
        save()
        fetchCategories()
    }
    
    func getMinOrderNumberCategory() -> Int64 {
        guard let categories else { return 0 }
        return categories.min { $0.orderNumber < $1.orderNumber }?.orderNumber ?? 0
    }
    
    func getMaxOrderNumberCategory() -> Int64 {
        guard let categories else { return 0 }
        return categories.max { $0.orderNumber < $1.orderNumber }?.orderNumber ?? 0
    }
    
    func getCategoryIndex(category: Category) -> Int? {
        return categories?.firstIndex(where: { $0.name == category.name })
    }
    
    // MARK: - 아이템 데이터 관련
    func fetchItems() {
        let request = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        
        do { items = try context.fetch(request) }
        catch { print(error.localizedDescription) }
    }
    
    func getItems() -> [Item] {
        guard let items else { return [] }
        return items
    }
    
    func getItem(title: String) -> Item? {
        guard let items else { fatalError() }
        return items.filter { $0.title == title }.first
    }
    
    func getItemsOfCategory(category: Category) -> [Item] {
        var itemList: [Item] = []
        
        let request = Item.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do { itemList = try context.fetch(request) }
        catch { print(error.localizedDescription) }
        
        return itemList
    }
    
    func setItem(title: String, content: String, category: Category) {
        let item = Item(context: context)
        
        item.title = title
        item.content = content
        item.category = category
        item.createdDate = Date()
        
        save()
    }
    
    func deleteItem(deleteItem: Item) {
        context.delete(deleteItem)
        
        save()
        fetchItems()
    }
    
    func getItemIndexOfCategory(item: Item) -> Int? {
        let items = getItemsOfCategory(category: item.category!)
        return items.firstIndex(where: { $0.title == item.title })
    }
}
