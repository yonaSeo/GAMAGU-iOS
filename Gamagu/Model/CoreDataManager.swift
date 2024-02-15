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
        
        let category = Category(context: context)
        category.name = "샘플 카테고리"
        category.alarmCycleDayCount = 7
        category.alarmPushCount = 7
        category.createdDate = Date()
        category.orderNumber = 0
        category.isAlarmActive = true
        
        let samples = [
            (title: "🥳세 번째 샘플🥳", content: "샘플 내용입니다💫"),
            (title: "🎊두 번째 샘플🎊", content: "샘플 내용입니다⭐️"),
            (title: "✨첫 번째 샘플✨", content: "샘플 내용입니다💖"),
        ]
        let items = samples.map { (title: String, content: String) in
            let item = Item(context: context)
            item.title = title
            item.content = content
            item.category = category
            item.createdDate = Date()
            return item
        }
        
        category.addToItems(NSSet(array: items))
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
    
    func getCategory(name: String) -> Category {
        guard let categories else { fatalError() }
        return categories.filter { $0.name == name }.first!
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
    
    func getItem(title: String) -> Item {
        guard let items else { fatalError() }
        return items.filter { $0.title == title }.first!
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
}
