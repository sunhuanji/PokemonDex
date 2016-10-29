//
//  ViewController.swift
//  PokemonDex
//
//  Created by Sun Huanji on 2016/10/27.
//  Copyright © 2016年 Sun Huanji. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UISearchBarDelegate{
    @IBOutlet weak var collection: UICollectionView!

    @IBOutlet weak var searchBar: UISearchBar!
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var musicPlayer:AVAudioPlayer!
    
    @IBAction func musicButtonPrased(_ sender: UIButton) {
        if musicPlayer.isPlaying{
          musicPlayer.pause()
          sender.alpha = 0.2
        }else{
          musicPlayer.play()
          sender.alpha = 1.0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done   //?
        parsePokemonCSV()
        initAudio()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
      let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        do{
          let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
             let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                pokemon.append(Pokemon(name: name, pokedexId: pokeId))
            }
        }catch let err as NSError{
          print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCollectionViewCell{
            let poke:Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                
                cell.configureCell(poke)
            }else{
                poke = pokemon[indexPath.row]
                cell.configureCell(poke)
            }
            
           return cell
        }else{
           return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke:Pokemon!
        
        if inSearchMode{
         poke = filteredPokemon[indexPath.row]
        }else{
         poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
         return filteredPokemon.count
        }
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // if we text in the search bar, then we will in the search mode
        if searchBar.text == nil || searchBar.text == "" {
         inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        }else{
         inSearchMode = true
         let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC"{
            if let detailVC = segue.destination as? PokeDetailViewController{
                if let poke = sender as? Pokemon{
                  detailVC.poke = poke
                }
            }
        }
    }
}

