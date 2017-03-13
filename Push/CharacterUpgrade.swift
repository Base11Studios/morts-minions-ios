//
//  CharacterUpgrade.swift
//  Merp
//
//  Created by Dan Bellinski on 11/1/15.
//  Copyright © 2015 Dan Bellinski. All rights reserved.
//

import Foundation

enum CharacterUpgrade : String {
    case None = "none"
    
    // Jump
    case Jump = "jump"
    case RubberSneakers = "rubber_sneakers"
    case MoonShoes = "moon_shoes"
    case SuperJump = "superjump"
    case DoubleJump = "double_jump"
    case TripleJump = "triplejump"
    
    // Block
    case Block = "block"
    case SteelShield = "steel_shield"
    case PlatinumShield = "platinum_shield"
    case AdvancedCharging = "advanced_charging"
    case BasicCharging = "basic_charging"
    case SmoothCharging = "smooth_charging"
    case DiamondShield = "diamond_shield"
    
    // Charge
    case Charge = "charge"
    case SpeedBoost = "speedboost"
    case GreatStamina2 = "greatstamina2"
    case GreatStamina = "greatstamina"
    case RagingStrength = "ragingstrength"
    case PowerCharge = "powercharge"
    
    // Throw Boulder
    case ThrowBoulder = "throwboulder"
    case Throw2Boulders = "throw2boulders"
    case Throw3Boulders = "throw3boulders"
    case ThrowMoreOften = "throwmoreoften"
    case ThrowMoreOften2 = "throwmoreoften2"
    case ExplodingBoulders = "explodingboulders"
    
    // Fireball
    case Fireball = "fireball"
    
    // Stomp
    case Stomp = "stomp"
    case HarderStomp = "harderstomp"
    case FasterStomp = "fasterstomp"
    case HarderStomp2 = "harderstomp2"
    case HarderStomp3 = "harderstomp3"
    case Earthquake = "earthquake"
    
    // Health boosting
    case MassageTherapist = "massagetherapist"
    case KaleSmoothie = "kalesmoothie"
    case SteelToedBoots = "steeltoedboots"
    case FirstAidKit = "firstaidkit"
    case BigBandage = "bigbandage"
    case MysteriousLiquid = "mysteriousliquid"
    case FasterRecovery3 = "fasterrecovery3"
    
    // Shoot arrow
    case ShootArrow = "shootarrow"
    case ReducedCooldown = "reducedcooldown"
    case ReducedCooldown2 = "reducedcooldown2"
    case SplitArrow = "splitarrow"
    case SplitArrow2 = "splitarrow2"
    case DoubleShot = "doubleshot"
    
    // Walk with shadows
    case WalkWithShadows = "walkwithshadows"
    case StealthExpert = "stealthexpert"
    case StealthExpert2 = "stealthexpert2"
    case StealthExpert3 = "stealthexpert3"
    case ShadowMeditation = "shadowmeditation"
    case ShadowMeditation2 = "shadowmeditation2"
    
    // Protector of the sky
    case ProtectorOfTheSky = "protectorofthesky"
    case WingStamina = "wingstamina"
    case WingStamina2 = "wingstamina2"
    case WingStamina3 = "wingstamina3"
    case ConfidenceBoost = "confidenceboost"
    case PrimalInstincts = "primalinstincts"
    
    // Health Potion
    case HealthPotion = "healthpotion"
    case IncreasedStock = "increasedstock"
    case BiggerPotions = "biggerpotions"
    case HeartHealthy = "hearthealthy"
    case IncreasedStock2 = "increasedstock2"
    case BiggerPotions2 = "biggerpotions2"
    
    // Dive Bomb
    case DiveBomb = "divebomb"
    case ExpertDiver = "expertdiver"
    case ElectroCharge = "electrocharge"
    case QuantumCharge = "quantumcharge"
    case FasterRegen = "fasterregen"
    case ShockWave = "shockwave"
    
    // Hover
    case Hover = "hover"
    case HoverLonger = "hoverlonger"
    case HoverLonger2 = "hoverlonger2"
    case HoverLonger3 = "hoverlonger3"
    case ProjectileDodge = "projectiledodge"
    case ProjectileDodge2 = "projectiledodge2"
    
    // Ki Strike
    case KiWave = "kiwave"
    case QuickerCooldown = "quickercooldown"
    case MoreEnergy = "moreenergy"
    case MoreEnergy2 = "moreenergy2"
    case ForceBlast = "forceblast"
    case ForceBlast2 = "forceblast2"
    
    // Ki Shield
    case KiShield = "kishield"
    case HeartPower = "heartpower"
    case HeartPower2 = "heartpower2"
    case ShieldPower = "shieldpower"
    case ShieldPower2 = "shieldpower2"
    case ShieldPower3 = "shieldpower3"
    
    // Teleport
    case Teleport = "teleport"
    case DoubleTeleport = "doubleteleport"
    case TripleTeleport = "tripleteleport"
    case TeleCharge = "telecharge"
    case TeleCharge2 = "telecharge2"
    case TeleCharge3 = "telecharge3"
    case TeleportDamageImmunity = "teleimmunity"
    
    // Meter
    case Meteor = "meteor"
    case FasterCooldown = "fastercooldown"
    case MoreMeteors = "moremeteors"
    case MoreMeteors2 = "moremeteors2"
    case MeteorSpeed = "meteorspeed"
    case MeteorBlast = "meteorblast"
    
    // Magic Missle
    case HomingMissle = "homingmissle"
    case MagicMissle = "magicmissle"
    case MagicRange = "magicrange"
    case MagicRange2 = "magicrange2"
    case DoubleMissle = "doublemissle"
    case MissleDamage = "missledamage"
    
    // Force Field
    case ForceField = "forcefield"
    case HeartField = "heartfield"
    case HeartField2 = "heartfield2"
    case ShieldField = "shieldfield"
    case ShieldField2 = "shieldfield2"
    case ShieldField3 = "shieldfield3"
    
    // Time Freeze
    case TimeFreeze = "timefreeze"
    case TimeFreeze2 = "timefreeze2"
    case TimeFreeze3 = "timefreeze3"
    case TimeFreeze4 = "timefreeze4"
    case TimeWarp = "timewarp"
    case TimeWarp2 = "timewarp2"
    
    // Fair Guardian
    case FairyGuardian = "fairyguardian"
    case FairyDefense1 = "fairydefense1"
    case FairyDefense2 = "fairydefense2"
    case FairyDefense3 = "fairydefense3"
    case FairySize1 = "fairysize1"
    case FairySize2 = "fairysize2"
}
