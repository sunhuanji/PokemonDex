//
//  PokeDetailViewController.swift
//  PokemonDex
//
//  Created by Sun Huanji on 2016/10/28.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit

class PokeDetailViewController: UIViewController {

    @IBAction func backButtonPrased(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var pokeIdLabel: UILabel!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    var poke:Pokemon!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = poke.name.capitalized
        
        let img = UIImage(named: "\(poke.pokedexId)")
        mainImage.image = img
        currentEvoImage.image = img
        pokeIdLabel.text = "\(poke.pokedexId)"
        
        poke.downloadPokemonDetail {
            self.upadeUI()
        }
    }
    
    func upadeUI(){
      attackLabel.text = poke.attack
      defenseLabel.text = poke.defense
      heightLabel.text = poke.height
      weightLabel.text = poke.weight
        typeLabel.text = poke.type
        descriptionLabel.text = poke.description
        if poke.nextEvoId == ""{
         evoLabel.text = "No Evolutions"
         nextEvoImage.isHidden = true
        }else{
            nextEvoImage.isHidden = false
            nextEvoImage.image = UIImage(named: poke.nextEvoId)
            let str = "Next Evolution:\(poke.nextEvoName) - LVL\(poke.nextEvoLevel)"
            evoLabel.text = str
        }
        
    }
    // Do any additional setup after loading the view.
}


