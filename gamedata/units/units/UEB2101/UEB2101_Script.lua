local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TDFLightPlasmaCannonWeapon = import('/lua/terranweapons.lua').TDFLightPlasmaCannonWeapon

UEB2101 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TDFLightPlasmaCannonWeapon) {}
    },
}

TypeClass = UEB2101