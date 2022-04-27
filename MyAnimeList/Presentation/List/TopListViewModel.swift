//
//  TopListViewModel.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/13.
//

import Foundation

public enum MALTypeEnum: String {
    case anime = "Anime"
    case manga = "Manga"
    case favorite = "Favorite"
}

// Input
public protocol TopListVMInput {
    var fetchDataTrigger: Box<()> { get }
    var saveDataTrigger: Box<TopEntity> { get }
}
// Output
public protocol TopListVMOutput {
    var isLoading: Box<Bool> { get }
    var isSubTypeHidden: Box<Bool> { get }
    var subtypeData: Box<[(String,Bool)]> { get }
    var listData: Box<[TopEntity]> { get }
    var typeIndex: Box<Int> { get }
    var scrollToTop: Box<()> { get }
    var scrollToLeft: Box<()> { get }
    var typeNames: [MALTypeEnum] { get }
    func typeClick(index: Int)
    func subtypeClick(index: Int)
    func gotoWebVC(entity: TopEntity)
    func upadteFavorite(entity: TopEntity)
}
// Manager
public protocol TopListVMManager {
    var input: TopListVMInput { get }
    var output: TopListVMOutput { get }
}

public final class TopListViewModel: TopListVMInput, TopListVMOutput, TopListVMManager {
    
    public weak var delegate: AppCoordinatorDelegate?
    var usecase: TopListUseCase?
    public var typeNames: [MALTypeEnum] = [.anime, .manga, .favorite]
    let typeSubtype = ["anime":["airing","upcoming","tv","movie","ova","special","bypopularity","favorite"],"manga":["manga","novels","oneshots","doujin","manhwa","manhua","bypopularity","favorite"],"favorite":[]]
    private var subtypeNames: [String] = [String]()
    private var page = 0
    private var subtypeIndex = 0
    
    public init(_ usecase: TopListUseCase) {
        self.usecase = usecase
        self.bindingInOut()
    }
    
    public var input: TopListVMInput {
        return self
    }
    public var output: TopListVMOutput {
        return self
    }
    
    // input
    public var fetchDataTrigger: Box<()> = Box(())
    public var saveDataTrigger: Box<TopEntity> = Box(nil)
    
    //output
    public var isLoading: Box<Bool> = Box(false)
    public var isSubTypeHidden: Box<Bool> = Box(false)
    public var subtypeData: Box<[(String,Bool)]> = Box([(String,Bool)]())
    public var listData: Box<[TopEntity]> = Box([TopEntity]())
    public var typeIndex: Box<Int> = Box(nil)
    public var scrollToTop: Box<()> = Box(())
    public var scrollToLeft: Box<()> = Box(())
}

extension TopListViewModel {
    private func bindingInOut() {
        fetchDataTrigger.binding(trigger: false) { [weak self]_, _ in
            guard let self = self else { return }
            let type = self.typeNames[self.typeIndex.value ?? 0]
            let page = self.page
            let subtype = self.subtypeData.value?[self.subtypeIndex].0 ?? ""
            self.isLoading.value = true
            self.usecase?.fetchTop(queryString: "/\(type)/\(page)/\(subtype)", with: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.value = false
                switch result {
                case .success(let entities):
                    self.listData.value?.append(contentsOf: entities)
                    self.page += 1
                    
                case.failure(let error):
                    fatalError("error:\(error)")
                }
            })
        }
        
        saveDataTrigger.binding(trigger: false) { [weak self] newValue, _ in
            guard let self = self, let entity = newValue else { return }
            
            self.usecase?.updateFavoriteTop(entity: entity)
            // TODO: listData also change isFavorite flag
        }
    }
}


extension TopListViewModel {
    public func typeClick(index: Int) {
        self.typeIndex.value = index
        if let subtypes = self.typeSubtype["\(self.typeNames[index])"], !subtypes.isEmpty {
            self.subtypeData.value = subtypes.map { ($0,false) }
            self.scrollToLeft.value = ()
            self.subtypeClick(index: 0)
            self.isSubTypeHidden.value = false
        } else {
            self.subtypeData.value = nil
            self.isSubTypeHidden.value = true
            self.scrollToTop.value = ()
            self.listData.value = self.usecase?.getLocalTopData()
        }
    }
    
    public func subtypeClick(index: Int) {
        guard var tmpSubtypeData = self.subtypeData.value else {
            return
        }
        self.subtypeIndex = index
        self.page = 1
        self.scrollToTop.value = ()
        tmpSubtypeData = tmpSubtypeData.map{ ($0.0,false) }
        tmpSubtypeData[index].1 = true
        
        self.subtypeData.value = tmpSubtypeData
        self.listData.value = [TopEntity]()
        self.fetchDataTrigger.value = ()
    }
    
    public func upadteFavorite(entity: TopEntity) {
        guard let tmpListData = self.listData.value, let firstIndex = tmpListData.firstIndex(where: {$0.malID == entity.malID}) else { return }
        self.listData.value?[firstIndex].isFavorite = entity.isFavorite
        
        self.usecase?.updateFavoriteTop(entity: entity)
        // in favorite list, refresh data
        if self.subtypeData.value == nil {
            self.listData.value = self.usecase?.getLocalTopData()
        }
    }
}

extension TopListViewModel {
    public func gotoWebVC(entity: TopEntity) {
        self.delegate?.gotoWebVC(entity: entity)
    }
}
