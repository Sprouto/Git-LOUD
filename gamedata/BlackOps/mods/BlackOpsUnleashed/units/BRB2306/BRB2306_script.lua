
local CRadarUnit = import('/lua/cybranunits.lua').CRadarUnit
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = cWeapons.CDFLaserHeavyWeapon
local StunZapperWeapon = import('/mods/BlackOpsUnleashed/lua/BlackOpsweapons.lua').StunZapperWeapon

local CreateAttachedEmitter = CreateAttachedEmitter
local AttachBeamEntityToEntity = AttachBeamEntityToEntity
local ForkThread = ForkThread

BRB2306 = Class(CRadarUnit) { 

	ChargeEffects01 = {
        '/mods/BlackOpsUnleashed/effects/emitters/manticore_charge_laser_flash_01_emit.bp',  #glow
        '/mods/BlackOpsUnleashed/effects/emitters/manticore_charge_laser_muzzle_01_emit.bp',  # sparks
    },

    Weapons = {
        Turret01 = Class(StunZapperWeapon) { 
			
			#-- there is some interesting things going on here - for example - the Stun Weapon is fired whenever the main weapon fires
            OnWeaponFired = function(self)
			
            	StunZapperWeapon.OnWeaponFired(self)
				
            	local wep = self.unit:GetWeaponByLabel('StunWeapon')
				
            	self.targetaquired = self:GetCurrentTargetPos()
				
            	if self.targetaquired then
					wep:SetTargetGround(self.targetaquired)
					self.unit:SetWeaponEnabledByLabel('StunWeapon', true)
					wep:SetTargetGround(self.targetaquired)
					wep:OnFire()
				end
			end,
			

			PlayFxRackSalvoChargeSequence = function(self, muzzle)
			
				StunZapperWeapon.PlayFxRackSalvoChargeSequence(self, muzzle) 
				
            	local wep = self.unit:GetWeaponByLabel('Turret01')
        		local bp = wep:GetBlueprint()
				
        		if bp.Audio.RackSalvoCharge then
            		wep:PlaySound(bp.Audio.RackSalvoCharge)
        		end
				
        		if self.unit.ChargeEffects01Bag then
            		for k, v in self.unit.ChargeEffects01Bag do
                		v:Destroy()
            		end
		    		self.unit.ChargeEffects01Bag = {}
				end
                
                local army = self.unit:GetArmy()
                
        		for k, v in self.unit.ChargeEffects01 do
            		table.insert( self.unit.ChargeEffects01Bag, CreateAttachedEmitter( self.unit, 'FocusBeam01_start', army, v ):ScaleEmitter(0.2))
            		table.insert( self.unit.ChargeEffects01Bag, CreateAttachedEmitter( self.unit, 'FocusBeam02_start', army, v ):ScaleEmitter(0.2))
            		table.insert( self.unit.ChargeEffects01Bag, CreateAttachedEmitter( self.unit, 'FocusBeam01_end', army, v ):ScaleEmitter(0.2))
            		table.insert( self.unit.ChargeEffects01Bag, CreateAttachedEmitter( self.unit, 'FocusBeam02_end', army, v ):ScaleEmitter(0.2))
        		end
				if self.unit.BeamChargeEffects then
					for k, v in self.unit.BeamChargeEffects do
						v:Destroy()
					end
					self.unit.BeamChargeEffects = {}
				end
                
				table.insert( self.unit.BeamChargeEffects, AttachBeamEntityToEntity(self.unit, 'FocusBeam01_start', self.unit, 'FocusBeam01_end', army, '/mods/BlackOpsUnleashed/effects/emitters/manticore_charge_beam_01_emit.bp') )
				table.insert( self.unit.BeamChargeEffects, AttachBeamEntityToEntity(self.unit, 'FocusBeam02_start', self.unit, 'FocusBeam02_end', army, '/mods/BlackOpsUnleashed/effects/emitters/manticore_charge_beam_01_emit.bp') )
				self:ForkThread(self.ArrayEffectsCleanup)
			end,
			
			ArrayEffectsCleanup = function(self)
				WaitTicks(30)
				if self.unit.BeamChargeEffects then
					for k, v in self.unit.BeamChargeEffects do
						v:Destroy()
					end
					self.unit.BeamChargeEffects = {}
				end
				if self.unit.ChargeEffects01Bag then
            		for k, v in self.unit.ChargeEffects01Bag do
                		v:Destroy()
            		end
		    		self.unit.ChargeEffects01Bag = {}
				end
			end,
        },
		
        StunWeapon = Class(CDFLaserHeavyWeapon){
		
			#-- right after firing the stun weapon turns itself off
        	OnWeaponFired = function(self)
                CDFLaserHeavyWeapon.OnWeaponFired(self)
				self:SetWeaponEnabled(false)
            end,
        },
    }, 
	
    OnStopBeingBuilt = function(self,builder,layer)
        CRadarUnit.OnStopBeingBuilt(self,builder,layer)
		self.BeamChargeEffects = {}
		self.ChargeEffects01Bag = {}
		self:SetWeaponEnabledByLabel('StunWeapon', false)
    end,


}
TypeClass = BRB2306