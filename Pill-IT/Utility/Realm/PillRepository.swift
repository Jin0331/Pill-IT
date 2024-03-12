//
//  PillRepository.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/8/24.
//

//import Foundation
//import RealmSwift
//
//final class RealmRepository {
//    
//    private let realm = try! Realm()
//    
//    func realmLocation() {
//        print(realm.configuration.fileURL!)
//    }
//    
//    
//    //MARK: - CREATE
//    // CREATE
//    func createItem<T:Object>(_ item : T) {
//        
//        // 해당 Table 전체 지웠다가 다시 추가하기.
//        // 데이터를 유지할 필요가 없음
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    // CREATE OR UPDATE
//    ////  Search API
//    func searchCreateOrUpdateItem(coinID : String, coinName : String,
//                                  conSymbol : String, rank : Int?,
//                                  searchKeyword : String?, large : String) {
//        do {
//            try realm.write {
//                realm.create(Search.self, value: ["coinID": coinID, "coinName":coinName,
//                                                  "conSymbol": conSymbol,"rank" : rank,
//                                                  "large": large,"searchKeyword":searchKeyword,"upDate":Date()
//                                                 ], update: .modified) }
//        } catch {
//            print(error)
//        }
//    }
//    
//    //// Market API
//    func searchCreateOrUpdateItem(coinID : String, coinName : String,
//                                  conSymbol : String, symbolImage : String,
//                                  currentPrice : Double, lastUpdated : Date,
//                                  change : CoinChange?, sparkline_in_7d : [Double]) {
//        do {
//            try realm.write {
//                realm.create(Market.self, value: ["coinID": coinID,
//                                                  "coinName":coinName,
//                                                  "conSymbol": conSymbol,
//                                                  "symbolImage": symbolImage,
//                                                  "currentPrice": currentPrice,
//                                                  "lastUpdated" : lastUpdated,
//                                                  "change" : change,
//                                                  "sparkline_in_7d" : sparkline_in_7d,
//                                                  "upDate":Date()
//                                                 ], update: .modified) }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func createEmbeddedItem(_ data : MarketCoin) -> CoinChange {
//        
//        return CoinChange(perprice_change_percentage_24h: data.priceChangePercentage24H,
//                          low_24h: data.low24H,
//                          high_24h: data.high24H,
//                          ath: data.ath,
//                          ath_date: data.athDate.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSz")!,
//                          atl: data.atl,
//                          atl_date: data.atlDate.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSz")!)
//        
//    }
//    
//    func createRelationSearchWithMarket(coinID : String) {
//        
//        
//        
//        guard let currentSearchTable = fetchSearchItem(coinID: coinID)?.first else { return }
//        let currentMarketTable = fetchMarketItem(coinID: coinID)
//        
//        do {
//            try realm.write {
//                currentSearchTable.market.removeAll()
//                currentSearchTable.market.append(currentMarketTable)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    
//    //MARK: - READ
//    // READ
//    func fetchCoinTrendItem() -> [CoinTrend] {
//        let result = realm.objects(CoinTrend.self)
//        
//        return Array(result)
//    }
//    
//    func fetchNFTTrendItem() -> [NFTTrend] {
//        let result = realm.objects(NFTTrend.self)
//        
//        return Array(result)
//    }
//    
//    
//    func fetchSearchItem() -> [Search] {
//        let result = realm.objects(Search.self)
//        
//        return Array(result)
//    }
//    
//    func fetchSearchItem(coinID : String) -> Results<Search>? {
//        let result = realm.objects(Search.self).where { $0.coinID == coinID }
//        
//        return result
//    }
//    
//    func searchFetchItemFilterdSorted(coinID : String) -> [Search] {
//        
//        let result = realm.objects(Search.self)
//            .filter("coinID CONTAINS[cd] %@ AND rank != -999", coinID)
//            .sorted(byKeyPath: "rank", ascending: true)
//            .prefix(25)
//        
//        return Array(result)
//    }
//    
//    func fetchMarketItemExist(coinID : String) -> Bool {
//        let result = realm.objects(Market.self).where { $0.coinID == coinID }.isEmpty
//        
//        return result
//    }
//    
//    func fetchMarketItem(coinID : String) -> Market {
//        let result = realm.objects(Market.self).where { $0.coinID == coinID }
//        
//        return Array(result)[0]
//    }
//    
//    func fetchSearchItemWithFavorite() -> [Search] {
//        let result = realm.objects(Search.self).where {$0.favorite == true }
//            .sorted(byKeyPath: "favoriteRank", ascending: true)
//        
//        return Array(result)
//    }
//    
//    func fetchMultipleMarketItem() -> [Market] { // ,구분자로 된 String
//        let searchFavoriteTrue = fetchSearchItemWithFavorite().map { return $0.market[0] }
//        
//        return searchFavoriteTrue.sorted {
//            ($0.search.first?.favoriteRank!)! < ($1.search.first?.favoriteRank!)!
//        }
//    }
//    
//    //MARK: - UPDATE
//    // FAVORITE TOGGLE
//    func updateFavoriteToggle(_ coinID : String, _ favorite : Bool) {
//        
//        // false -> true, 즐겨찾기가 새롭게 설정되는 경우
//        // 기존의 true 값의 순서를 가져와서 총 개수에 +1을 한다
//        if favorite {
//            
//            let favoriteTrue = realm.objects(Search.self).where {$0.favorite == true }
//                .sorted(byKeyPath: "favoriteRank", ascending: true)
//            
//            do {
//                try realm.write {
//                    realm.create(Search.self, value: ["coinID": coinID, "favorite" : favorite, "favoriteRank": favoriteTrue.count, "upDate":Date()], update: .modified) }
//            } catch {
//                print(error)
//            }
//            // 즐겨찾기가 해제되는 경우, 전체 테이블의 랭크를 초기화 한다
//            // realm.write가 실행된 이후
//        } else {
//            do {
//                try realm.write {
//                    realm.create(Search.self, value: ["coinID": coinID, "favorite" : favorite,  "favoriteRank": nil, "upDate":Date()], update: .modified) }
//            } catch {
//                print(error)
//            }
//            
//            updateFavoriteRankAll()
//            
//        }
//    }
//    
//    func updateFavoriteRankSwitching(_ targetCoinID : String, _ source : IndexPath, _ destination : IndexPath) {
//        
//        print(targetCoinID)
//        print(destination.item)
//        
//        // source가 밑에 있으면 true
//        let flag = source.item - destination.item > 0 ? true : false
//        let favoriteTrue = flag ? realm.objects(Search.self).where {$0.favorite == true }
//            .sorted(byKeyPath: "favoriteRank", ascending: true)
//            .where {
//                $0.favoriteRank.contains(destination.item...source.item)
//            } : realm.objects(Search.self).where {$0.favorite == true }
//            .sorted(byKeyPath: "favoriteRank", ascending: true)
//            .where {
//                $0.favoriteRank.contains(source.item...destination.item)
//            }
//        
//        print(favoriteTrue)
//        
//        // 위로 올라감 ---> destination까지 +1
//        if flag {
//            favoriteTrue.enumerated().forEach { index, value in
//                do {
//                    try realm.write {
//                        value.favoriteRank! += 1
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        } else {
//            favoriteTrue.enumerated().forEach { index, value in
//                do {
//                    try realm.write {
//                        value.favoriteRank! -= 1
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//        
//        // target 업데이트
//        do {
//            try realm.write {
//                realm.create(Search.self, value: ["coinID": targetCoinID, "favoriteRank": destination.item, "upDate":Date()], update: .modified) }
//        } catch {
//            print(error)
//        }
//        
//    }
//    
//    
//    //TODO: - favorite Rank re-order
//    private func updateFavoriteRankAll() {
//        let favoriteTrue = realm.objects(Search.self).where {$0.favorite == true }
//            .sorted(byKeyPath: "favoriteRank", ascending: true)
//        
//        
//        favoriteTrue.enumerated().forEach { index, value in
//            do {
//                try realm.write {
//                    value.favoriteRank = index
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    private func updateFavoriteRank(_ coinID : String, _ rank : Int) {
//        
//        
//        do {
//            try realm.write {
//                realm.create(Search.self, value: ["coinID": coinID, "favoriteRank": rank, "upDate":Date()], update: .modified) }
//        } catch {
//            print(error)
//        }
//    }
//    
//    //MARK: - DELETE
//    
//    func allTableRemove<T:Object>(type : T) {
//        do {
//            try realm.write {
//                let allItem = realm.objects(T.self)
//                realm.delete(allItem)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func allCoinTrendTableRemove() {
//        do {
//            try realm.write {
//                let allItem = realm.objects(CoinTrend.self)
//                realm.delete(allItem)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    
//    func allNFTTrendTableRemove() {
//        do {
//            try realm.write {
//                let allItem = realm.objects(NFTTrend.self)
//                realm.delete(allItem)
//            }
//        } catch {
//            print(error)
//        }
//    }
//}
