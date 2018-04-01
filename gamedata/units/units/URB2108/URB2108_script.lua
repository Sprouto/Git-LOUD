
local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CIFMissileLoaTacticalWeapon = import('/lua/cybranweapons.lua').CIFMissileLoaTacticalWeapon

URB2108 = Class(CStructureUnit) {
    Weapons = {
        CruiseMissile = Class(CIFMissileLoaTacticalWeapon) {},
    },
}
TypeClass = URB2108