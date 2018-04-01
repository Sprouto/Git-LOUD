
local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TMWeaponsFile = import('/mods/TotalMayhem/lua/TMAeonWeapons.lua')
local TMAmizurabluelaserweapon = TMWeaponsFile.TMAmizurabluelaserweapon


BROT1EXPD = Class(TStructureUnit) {
    Weapons = {
        laserblue = Class(TMAmizurabluelaserweapon) {
		},
    },
}

TypeClass = BROT1EXPD