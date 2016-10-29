//
//  PokeCollectionViewCell.swift
//  PokemonDex
//
//  Created by Sun Huanji on 2016/10/28.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit

class PokeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon:Pokemon!
    
    required init?(coder aDecoder:NSCoder){
     super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configureCell(_ pokemon:Pokemon){
     self.pokemon = pokemon
     thumbImage.image = UIImage(named: "\(self.pokemon.pokedexId)")
     nameLabel.text = self.pokemon.name.capitalized
    }
}
