local ConstructionUnit = URL0309
local RegularAIEngineer = import(import( '/lua/game.lua' ).BrewLANLOUDPath() .. '/lua/FieldEngineers.lua').RegularAIEngineer

ConstructionUnit = RegularAIEngineer(ConstructionUnit)

URL0309 = Class(ConstructionUnit) {}

TypeClass = URL0309
