//
//  TopListViewModel.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/13.
//

import Foundation

enum MALTypeEnum: String {
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
    //    var alertMsg: Box<(String, String)> { get }
    var isLoading: Box<Bool> { get }
    var isSubTypeHidden: Box<Bool> { get }
    var subtypeData: Box<[(String,Bool)]> { get }
    var listData: Box<[TopEntity]> { get }
    var typeIndex: Box<Int> { get }
//    var subtypeIndex: Box<Int> { get }
}
// Manager
public protocol TopListVMManager {
    var input: TopListVMInput { get }
    var output: TopListVMOutput { get }
}

public final class TopListViewModel: TopListVMInput, TopListVMOutput, TopListVMManager {
    
    var usecase: TopListUseCase?
    let typeNames: [MALTypeEnum] = [.anime, .manga, .favorite]
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
//    public var subtypeIndex: Box<Int> = Box(nil)
}

extension TopListViewModel {
    private func bindingInOut() {
        fetchDataTrigger.binding(trigger: false) { [weak self]_, _ in
            guard let self = self else { return }
            print("fetchDataTrigger typeIndex=\(self.typeIndex.value)")
//            print("subtypeIndex=\(self.subtypeIndex.value)")
            var params = [String: String]()
            params["type"] = "\(self.typeNames[self.typeIndex.value ?? 0])"
            params["subtype"] = ""
            params["page"] = "\(self.page)"
            self.isLoading.value = true
            self.usecase?.fetchTop(queryParams: params, with: { [weak self] result in
                guard let self = self else { return }
                self.isLoading.value = false
                switch result {
                case .success(let entities):
                    self.listData.value = entities
                    self.page += 1
                    
                case.failure(let error):
                    //                    self.alertMsg.value = (error.description.title, error.description.msg)
                    fatalError("error:\(error)")
                }
            })
        }
        
        saveDataTrigger.binding(trigger: false) { [weak self] newValue, _ in
            guard let self = self, let entity = newValue else { return }
            
            self.usecase?.saveFavoriteTop(entity: entity)
            // TODO: listData also change isFavorite flag
        }
    }
}


extension TopListViewModel {
    // button add target how to set index to func
    public func typeClick(index: Int) {
        self.typeIndex.value = index
        if let subtypes = self.typeSubtype["\(self.typeNames[index])"], !subtypes.isEmpty {
            self.subtypeData.value = subtypes.map { ($0,false) }
            self.subtypeClick(index: 0)
            self.isSubTypeHidden.value = false
        } else {
            self.subtypeData.value = nil
            self.isSubTypeHidden.value = true
        }
    }
    
    public func subtypeClick(index: Int) {
        guard var tmpSubtypeData = self.subtypeData.value else {
            return
        }
        self.subtypeIndex = index
        tmpSubtypeData = tmpSubtypeData.map{ ($0.0,false) }
        tmpSubtypeData[index].1 = true
        
        self.subtypeData.value = tmpSubtypeData
        self.fetchDataTrigger.value = ()
    }
    
    public func goToWebView(url: String) {
        // TODO: use coordinator
    }
    
    
    
}
