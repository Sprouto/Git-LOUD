local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit

local TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon

local WeaponsFile = import ('/lua/seraphimweapons.lua')
local SDFExperimentalPhasonProj = WeaponsFile.SDFExperimentalPhasonProj
local SDFUnstablePhasonBeam = WeaponsFile.SDFUnstablePhasonBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')

tcba0401 = Class( AShieldStructureUnit ) {

    ShieldEffects = {
            '/effects/emitters/cybran_shield_05_generator_02_emit.bp',
            '/effects/emitters/cybran_shield_05_generator_03_emit.bp',
            '/effects/emitters/cybran_shield_05_generator_04_emit.bp',
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
	
        AShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
		
		self.ShieldEffectsBag = {}
		
    end,

    OnShieldEnabled = function(self)
	
		AShieldStructureUnit.OnShieldEnabled(self)
	
        if self.ShieldEffectsBag then
		
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
			
		    self.ShieldEffectsBag = {}
			
		end
		
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ) )
        end
		
    end,

    OnShieldDisabled = function(self)
	
        AShieldStructureUnit.OnShieldDisabled(self)
		
        if self.ShieldEffectsBag then
		
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
			
		    self.ShieldEffectsBag = {}
			
		end
		
    end,
	
    Weapons = {
	
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
        Lightning = Class(SDFUnstablePhasonBeam) { FxMuzzleFlash = EffectTemplate.SDFSinnutheWeaponMuzzleFlash },
        PhasonBeam = Class(SDFExperimentalPhasonProj) {},
		
    },
	
}

TypeClass = tcba0401