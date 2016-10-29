//
//  File.swift
//  PokemonDex
//
//  Created by Sun Huanji on 2016/10/27.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokemon {
    fileprivate var _name:String!
    fileprivate var _pokedexId:Int!
    
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvoText:String!
    private var _nextEvoName:String!
    private var _nextEvoId:String!
    private var _nextEvoLevel:String!
    private var _pokemonURL:String!
    
    var nextEvoName:String{
        if _nextEvoName == nil{
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId:String{
        if _nextEvoId == nil{
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLevel:String{
        if _nextEvoLevel == nil{
            _nextEvoLevel = ""
        }
        return _nextEvoLevel
    }
    
    var nextEvoText:String{
        if _nextEvoText == nil{
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    var attack:String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var weight:String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var height:String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var defense:String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var type:String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var description:String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    var name:String{
        return _name
    }
    
    var pokedexId:Int{
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId!)/"
        
    }
    
    
    func downloadPokemonDetail(completed:@escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let values = response.result.value{
                let json = JSON(values)
                let weight = json["weight"].string!
                self._weight = weight
                let height = json["height"].string!
                self._height = height
                let attack = json["attack"].int!
                self._attack = "\(attack)"
                let defense = json["defense"].int!
                self._defense = "\(defense)"
                let types = json["types"].array!
                var name = types[0]["name"].string!
                if types.count > 1{
                    for x in 1..<types.count{
                        name += "/\(types[x]["name"].string!)"
                    }
                }
                self._type = name.capitalized
                //Get description
                let desString = json["descriptions"][0]["resource_uri"].string!
                let desUrl = "\(URL_BASE)\(desString)"
                Alamofire.request(desUrl).responseJSON(completionHandler: { (response) in
                    if let insideValues = response.result.value{
                        let insideJson = JSON(insideValues)
                        let description = insideJson["description"].string!
                        self._description = description
                        completed()
                    }
                })
                //Get evolution information
                let evolutions = json["evolutions"].array!
                if evolutions.count > 0{
                    let nextEvo = evolutions[0]["to"].string
                    if nextEvo?.range(of: "mega") == nil{
                        self._nextEvoName = nextEvo
                        let evoUrl  = evolutions[0]["resource_uri"].string
                        let nextString = evoUrl?.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                        let nextId = nextString?.replacingOccurrences(of: "/", with: "")
                        self._nextEvoId = nextId
                        
                        let nextLevel = evolutions[0]["level"].int
                        if nextLevel == nil{
                         self._nextEvoLevel = ""
                        }else{
                         self._nextEvoLevel = "\(nextLevel!)"
                        }
                        
                    }else{
                       self._nextEvoId = ""
                       self._nextEvoName = ""
                       self._nextEvoLevel = ""
                    }
                    
                }
                print(self._nextEvoLevel)
                print(self._nextEvoName)
                print(self._nextEvoId)
                completed()
            }
            
        }
        
    }
}
