import Foundation

class PlayerProjectile : SKSpriteNode {
    // Type
    var type: EnvironmentObjectType = EnvironmentObjectType.Ignored
    
    // Attributes
    var damage: NSInteger = 0
    var timeAlive: Double = 0.0
    
    // Physics Defaults
    var defaultRestitution: CGFloat = 1.0
    var defaultMass: CGFloat = 11.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var defaultFriction: CGFloat = 0.0
    var defaultLinearDamping: CGFloat = 0.0
    
    // Basic Attributes
    var moveSpeed: CGFloat = 100.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    // Attributes
    var walkSpeed: CGFloat = 100.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    var runSpeed: CGFloat = 120.0// * ScaleBuddy.sharedInstance.getGameScaleAmount(false)
    
    // Physics
    var velocityRate : CGFloat = 1.0;
    
    // Position
    var defaultYPosition: CGFloat = CGFloat()
    var groundYPosition: CGFloat = CGFloat()
    var startingYPosition: CGFloat = 0.0
    
    var walkAction = SKAction()
    var fightAction = SKAction()
    
    // State
    var isFlying: Bool = false
    var needsToExecuteDeath: Bool = false
    
    var numberOfContacts: Int = 1
    
    weak var gameScene: GameScene?
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, scene: GameScene) {
        super.init(texture: texture, color: color, size: size)
        self.gameScene = scene
        
        // Initialize attributes
        self.initializeAttributes()
        
        self.setScale(ScaleBuddy.sharedInstance.getGameScaleAmount(false))
        
        self.defaultYPosition = defaultYPosition + self.size.height / 2
        
        self.setupTraits()
    }
    
    func setupTraits() {
        preconditionFailure("This method must be overriden by the subclass")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeAttributes() {
        self.resetName()
        
        self.damage = 1
        
        self.isFlying = true
        
        self.numberOfContacts = 1
    }
    
    func resetName() {
        self.name = "playerProjectile"
        // Type
        self.type = EnvironmentObjectType.PlayerProjectile
    }
    
    func update(_ timeSinceLast: CFTimeInterval, withPlayer player: Player) {
        // Calc time alive
        self.timeAlive += timeSinceLast
            
        // Move
        self.move(player)
    }
    
    func move(_ player: SKSpriteNode) {
        // Set the enemy velocity. This is opposite of the player to keep them moving forward.
        let relativeVelocity: CGVector = CGVector(dx: self.moveSpeed - self.physicsBody!.velocity.dx, dy: self.physicsBody!.velocity.dy)
        
        // Enemies don't jump (or at least not yet) so Y won't change
        self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx + relativeVelocity.dx * self.velocityRate, dy: self.physicsBody!.velocity.dy)
    }
    
    func updateAfterPhysics() {
        if self.needsToExecuteDeath {
            self.executeDeath()
        }
        
        if self.isFlying {
            self.physicsBody!.velocity = CGVector(dx: self.physicsBody!.velocity.dx, dy: 0.0)
            self.position = CGPoint(x: self.position.x, y: self.defaultYPosition)
        }
    }
    
    func takeHit() {
        self.numberOfContacts -= 1
        
        if self.numberOfContacts <= 0 {
            self.needsToExecuteDeath = true
        }
    }
    
    func executeDeath() {
        self.removeFromParent()
        
        // Remove from worldView array
        /*
        var count = 0
        for projectile in self.gameScene!.worldViewPlayerProjectiles {
            if projectile === self {
                self.gameScene!.worldViewPlayerProjectiles.remove(at: count)
                break
            }
            
            count += 1
        }*/
        
        self.gameScene!.worldViewPlayerProjectiles.remove(at: self.gameScene!.worldViewPlayerProjectiles.index(of: self)!)
    }
    
    func setDefaultPhysicsBodyValues() {
        self.physicsBody!.isDynamic = true
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.usesPreciseCollisionDetection = OptimizerBuddy.sharedInstance.usePreciseCollisionDetection()
        self.physicsBody!.affectedByGravity = false
        
        // Collisions
        self.setDefaultCollisionMasks()
        
        // Physics Body settings
        self.physicsBody!.restitution = self.defaultRestitution
        self.physicsBody!.mass = self.defaultMass
        self.physicsBody!.friction = self.defaultFriction
        self.physicsBody!.linearDamping = self.defaultLinearDamping
    }
    
    func setDefaultCollisionMasks() {
        // Collisions
        self.physicsBody!.categoryBitMask = GameScene.playerProjectileCategory
        self.physicsBody!.contactTestBitMask = GameScene.enemyCategory | GameScene.obstacleCategory
        self.physicsBody!.collisionBitMask = 0//GameScene.enemyCategory | GameScene.obstacleCategory
    }
    
    func contactWithGround() {
        
    }
}
