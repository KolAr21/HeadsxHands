import UIKit

// MARK: - Structure Message

struct Message {
    enum logMessage {
        case attack(String, String, Int)
        case notAttack(String)
        case heal(String, Int)
        case dead(String)
        case error
    }
    
    func printMessage(message: logMessage) {
        switch message {
        case .attack(let firstName, let secondName, let damage):
            print("\(firstName) нанес \(secondName) \(damage) урона")
        case .notAttack(let name):
            print("\(name) промахнулся")
        case .heal(let name, let health):
            print("\(name) полечился. Теперь его здоровье: \(health)")
        case .dead(let name):
            print("\(name) помер")
        case .error:
            print("ERROR!!! Проверь входные данные")
        }
    }
    
}

// MARK: - General Class

class Entity {
    var message = Message()
    
    var name: String
    var attack: Int
    var defense: Int
    var damageRange: ClosedRange<Int>
    var health: Int
    
    func attackTarget(target: Entity) {
        var modifierAttack = self.attack - target.defense + 1
        var countDices = modifierAttack < 1 ? 1 : modifierAttack
        var hit: Bool = tossingDices(countDices)
        if hit {
            var randomDamage: Int = Int.random(in: self.damageRange)
            message.printMessage(message: .attack(name, target.name, randomDamage))
            target.takeDamage(randomDamage)
        } else {
            message.printMessage(message: .notAttack(name))
        }
    }
    
    func takeDamage(_ damage: Int) {
        if damage > health {
            self.health = 0
            message.printMessage(message: .dead(self.name))
        } else {
            self.health -= damage
        }
    }
    
    func isAlive() -> Bool {
        return health > 0
    }
        
    private func tossingDices(_ countCubes: Int) -> Bool {
        for _ in 1...countCubes {
            var random = Int.random(in: 1...6)
            if random >= 5 {
                return true
            }
        }
        return false
    }
    
    init?(name: String, attack: Int, defense: Int, health: Int, damageRange: ClosedRange<Int>) {
        self.name = name
        self.attack = attack
        self.defense = defense
        self.health = health
        self.damageRange = damageRange
    }
    
}

final class Player: Entity {
    var messagePlayer = Message()
    var countHealth = 0
    
    func healPlayer() {
        if countHealth < 4 {
            self.health += Int(Double(self.health) * 0.3)
            countHealth += 1
            messagePlayer.printMessage(message: .heal(self.name, self.health))
        }
    }
    
    override init?(name: String, attack: Int, defense: Int, health: Int, damageRange: ClosedRange<Int>) {
        guard attack > 0 && attack <= 30,
              defense > 0 && defense <= 30,
              health >= 0 else {
            messagePlayer.printMessage(message: .error)
            return nil
        }
        
        super.init(name: name, attack: attack, defense: defense, health: health, damageRange: damageRange)
    }
    
}

final class Monster: Entity {
    var messageMonster = Message()
    
    override init?(name: String, attack: Int, defense: Int, health: Int, damageRange: ClosedRange<Int>) {
        guard attack > 0 && attack <= 30,
              defense > 0 && defense <= 30,
              health >= 0 else {
            messageMonster.printMessage(message: .error)
            return nil
        }
        
        super.init(name: name, attack: attack, defense: defense, health: health, damageRange: damageRange)
    }
}

//MARK: - Application Example

let player = Player(name: "Боб", attack: 7, defense: 5, health: 100, damageRange: 5...8)
let monster = Monster(name: "Мурлок", attack: 6, defense: 6, health: 50, damageRange: 1...6)

if let player = player, let monster = monster {
    while player.isAlive() && monster.isAlive() {
        player.attackTarget(target: monster)
        if monster.isAlive() {
            monster.attackTarget(target: player)
        }
        
        player.healPlayer()
    }
    
    if player.isAlive() {
        print("Игрок победил!")
    } else {
        print("Монстр победил!")
    }
}


let playerOne = Player(name: "Боб", attack: 40, defense: 5, health: 100, damageRange: 5...8)
let monsterOne = Monster(name: "Мурлок", attack: 8, defense: 50, health: 50, damageRange: 1...6)
