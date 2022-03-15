-- /lua/ai/Loud_AI_Engineer_Defense_Builders.lua

-- Constructs All Base Defenses and Shields

local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local LUTL = '/lua/loudutilities.lua'

-- Just a note -- many of these builders use the 'BasePerimeterSelection = true' function
-- This will direct the AI to build only one of these positions at a time -- selecting randomly
-- from the available positions (which depends upon the BasePerimeterOrientation)
-- This keeps the AI in check when building these expensive items rather than building
-- all the positions in a single go 
-- the only exception is the shields which, when they meet conditions, all positions will be produced

-- this function will turn a builder off if the enemy is not active in the water
local IsEnemyNavalActive = function(self,aiBrain,manager)

	if aiBrain.NavalRatio and (aiBrain.NavalRatio > .01 and aiBrain.NavalRatio <= 10) then
	
		return self.Priority, false	-- standard naval priority -- 

	end

	return 10, true
	
end

local IsPrimaryBase = function(self,aiBrain,manager)
	
	if aiBrain.BuilderManagers[manager.LocationType].PrimarySeaAttackBase then
		return self.Priority, false
	end

	return 10, true
end

-- this function will remove the builder if this is not a NAVAL map (water - but no naval markers)
local IsNavalMap = function( self, aiBrain, manager)

    if aiBrain.IsNavalMap then
        return self.Priority, false
    end
    
    return 0, false

end

-- These 2 functions need some consideration - as they force the priority up to 850 - which seems like a guess
-- Review the Engineer Builders priorities, 850 blows pretty much all others out of the water
-- you may wish to consider that it may override some very important tasks (like reclaim or energy)

-- These 2 New Functions will enable LOUD to prioritize defenses if land ratio below a certain value
-- This is mostly for the players that rush him but this should also effect how prepared his bases are.
local IsEnemyCrushingLand = function( builder, aiBrain, unit )

    if aiBrain.LandRatio <= 1.0 and aiBrain.CycleTime > 300 then
	
		return builder.Priority + 100, true	

    end
    
    local IMAPblocks = math.floor( 96/ScenarioInfo.IMAPSize )

    if aiBrain:GetThreatAtPosition( unit:GetPosition(), IMAPblocks, true, 'AntiSurface' ) > 30 then
    
        LOG("*AI DEBUG "..aiBrain.Nickname.." Threat at "..unit.LocationType.." IMAPblocks "..IMAPblocks.." range > 30")

        return builder.Priority + 100, true
        
    end
    
    return builder.Priority, false
end

local IsEnemyCrushingAir = function( builder, aiBrain, unit )

    if aiBrain.AirRatio <= 1.0 and aiBrain.CycleTime > 300 then
	
		return builder.Priority + 100, true	

    end
    
    return builder.Priority, false
end

---------------------
--- THE MAIN BASE ---
---------------------
--- CORE ---
BuilderGroup {BuilderGroupName = 'Engineer Base Defense Construction - Core',
    BuildersType = 'EngineerBuilder',

    Builder {BuilderName = 'T1 Base Defense - PD',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 760,
		
		PriorityFunction = function(self, aiBrain)
		
			if self.Priority != 0 then

				-- remove after 30 minutes
				if aiBrain.CycleTime > 1800 then
					return 0, false
				end
				
			end
			
			return self.Priority
			
		end,
		
        BuilderConditions = {
			{ EBC, 'GreaterThanEnergyIncome', { 300 }},
            
			{ EBC, 'GreaterThanEconStorageCurrent', { 175, 1750 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
			
			-- dont build if we have built any advanced power -- obsolete
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ENERGYPRODUCTION * categories.STRUCTURE - categories.TECH1 }},
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE, 30, 50}},
        },
		
        BuilderType = { 'T1' },
		
        BuilderData = {
            Construction = {
				Radius = 36,
                NearBasePerimeterPoints = true,
				ThreatMax = 50,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,	-- pick a random point from the 9 FRONT rotations

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {
                    'T1AADefense',
					'T1GroundDefense',
					'T1Artillery',
				},
            }
        }
    },	

--[[
    Builder {BuilderName = 'T1 Base Defense - AA',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 760,
		
		PriorityFunction = function(self, aiBrain)
		
			if self.Priority != 0 then

				-- remove after 30 minutes
				if aiBrain.CycleTime > 1800 then
					return 0, false
				end
				
			end
			
			return self.Priority
			
		end,
		
        BuilderConditions = {
            { EBC, 'GreaterThanEnergyIncome', { 300 }},
            
			{ EBC, 'GreaterThanEconStorageCurrent', { 175, 1750 }},

            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
			
			-- dont build if we have built any advanced power -- obsolete
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ENERGYPRODUCTION * categories.STRUCTURE - categories.TECH1 }},
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE, 30, 50}},
        },
		
        BuilderType = { 'T1' },
		
        BuilderData = {
            Construction = {
				Radius = 36,
                NearBasePerimeterPoints = true,
				ThreatMax = 50,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,	-- pick a random point from the 9 FRONT rotations

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {
					'T1AADefense',
				},
            }
        }
    },
--]]

    Builder {BuilderName = 'T2 Base PD - Base Template',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 751,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .65 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            

			{ EBC, 'GreaterThanEconStorageCurrent', { 250, 2500 }},

            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 20, categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH2, 15, 42 }},
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
            DesiresAssist = true,
            NumAssistees = 1,
            
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 50,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T2GroundDefense'},
            }
        }
    },

    Builder {BuilderName = 'T2 Base TMD - Base Template',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},

			{ EBC, 'GreaterThanEconStorageCurrent', { 250, 2500 }},
            
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 10, categories.STRUCTURE * categories.ANTIMISSILE * categories.TECH2, 14, 42 }},
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
                
				ThreatMax = 50,				
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T2MissileDefense' },
            }
        }
    },

    Builder {BuilderName = 'T3 Base PD - Base Template',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.7, 12, 1, 1.01 }},
			
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH3, 15, 42 }},
        },
		
        BuilderType = { 'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 2,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
				ThreatMax = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T3GroundDefense'},
            }
        }
    },

    Builder {BuilderName = 'T3 Base AA - Base Template',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750, 

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 4200 }},
            
            { LUTL, 'AirStrengthRatioLessThan', { 4.5 } }, 
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.7, 12, 1, 1.01 }},
			
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 12, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 15, 42 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
		
			DesiresAssist = true,
            NumAssistees = 2,
			
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
				BuildStructures = {'T3AADefense' },
            }
        }
    },
	
    Builder {BuilderName = 'T2 Base AA - Base Template',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .65 } },
            
            { LUTL, 'AirStrengthRatioLessThan', { 3 } }, 
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ EBC, 'GreaterThanEconStorageCurrent', { 175, 1750 }},

            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.ANTIAIR, 15, 42 }},
        },
		
        BuilderType = {'T2'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 50,				
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T2AADefense'},
            }
        }
    },
    
    -- this artillery is built in the defense boxes - not the core
    Builder {BuilderName = 'T2 Artillery - Base Template - Boxes',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 745,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 10, 1.02, 1.02 }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.ARTILLERY * categories.STRUCTURE * categories.TECH2, 21, 42 }},			
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
                
				ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T2Artillery'},
            }
	    }
    },		

    -- this artillery is built in the core - not the defense boxes
    Builder {BuilderName = 'T2 Artillery - Base Template - Core',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 745,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 10, 1.02, 1.02 }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 10, categories.ARTILLERY * categories.STRUCTURE * categories.TECH2, 10, 20 }},			
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'SupportLayout',
				
                BuildStructures = {'T2Artillery'},
            }
	    }
    },
	
    Builder {BuilderName = 'T2 TML - Base Template - Core',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 745,

        PriorityFunction = IsEnemyCrushingLand,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 10, 1, 1 }}, 
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 6, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE, 10, 20 }},			
        },
		
        BuilderType = {'T2','T3','SubCommander' },
		
        BuilderData = {
            Construction = {
                NearBasePerimeterPoints = true,
				
				ThreatMax = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'SupportLayout',
				
                BuildStructures = {'T2StrategicMissile'},
            }
        }
    },

    Builder {BuilderName = 'T3 Teleport Jamming',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 745,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.ANTITELEPORT * categories.STRUCTURE * categories.TECH3 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
		
			Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 35,				

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
                
                BuildStructures = {'T3TeleportJammer'},
            }
        }
    },	
	
    Builder {BuilderName = 'T3 Tactical Artillery - Boxes',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 745,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.ARTILLERY * categories.TACTICAL }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
		
			DesiresAssist = true,
            NumAssistees = 2,

			Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 100,				

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
                
                BuildStructures = {'T3TacticalArtillery'},
            }
        }
    },	

	-- setup so that we always build one
    Builder {BuilderName = 'AntiNuke',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 900,
		
        BuilderConditions = {
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},        
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 2, categories.FACTORY - categories.TECH1 }},
		    { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3 }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				BasePerimeterOrientation = 'FRONT',			
				NearBasePerimeterPoints = true,
				ThreatMax = 50,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T3StrategicMissileDefense'},
            }
        }
    },
	
	-- and build more if enemy has more than 1
    Builder {BuilderName = 'AntiNuke - Response',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 910,
		
        BuilderConditions = {
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},        
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3, 5, 45 }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategoryAndAlliance', { 1, categories.NUKE * categories.SILO + categories.SATELLITE, 'Enemy' }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T3StrategicMissileDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'Experimental PD',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.EXPERIMENTAL * categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE, 10, 42 }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 4,
			
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 100,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T4GroundDefense'},
            }
        }
    },

    Builder {BuilderName = 'Experimental AA Defense',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 750,
        
        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},			
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.EXPERIMENTAL * categories.DEFENSE * categories.STRUCTURE * categories.ANTIAIR, 10, 40 }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 3,
			
            Construction = {
				NearBasePerimeterPoints = true,
				ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'BaseDefenseLayout',
				
                BuildStructures = {'T4AADefense'},
            }
        }
    },
}

BuilderGroup {BuilderGroupName = 'Engineer Shield Construction',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Shields - Core',
    
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 820,

        PriorityFunction = IsEnemyCrushingLand,

        InstanceCount = 1,
        
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            
            { LUTL, 'UnitCapCheckLess', { .95 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},			
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 12, 1.01, 1.02 }},

			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 3, categories.FACTORY * categories.STRUCTURE}},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
        },
		
        BuilderType = {'T2','T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayoutInner',
                BuildStructures = {
                    'T2ShieldDefense',
					'EnergyStorage',
					'EnergyStorage',
					'EnergyStorage',
                },
            }
        }
    },
	
    Builder {BuilderName = 'Shields - Outer',
    
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,
		
		InstanceCount = 1,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.005, 1.012 }},
            
			-- must have 4 inner shields
			{ UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
            
			-- and less than 8 shields in the Base - Outer ring
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 16, 45 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
                BuildStructures = {
                    'T3ShieldDefense',
					'EnergyStorage',
					'EnergyStorage',
					'EnergyStorage',
                },
            }
        }
    },

	Builder {BuilderName = 'Shield Augmentations',
    
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 745,
		
		InstanceCount = 2,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},			
            
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 1.05, 1.1 }},
            
			{ UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 10, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0,45 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
                
                BuildStructures = {'EnergyStorage'},
            }
        }
    },

    Builder {BuilderName = 'T3 Artillery Defense Shield - UEF',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        FactionIndex = 1,
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.005, 1.012 }},

			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.ANTIARTILLERY }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
				
                BuildStructures = {'T3ArtilleryDefenseShield'},
            }
        }
    },
    
    Builder {BuilderName = 'T3 Artillery Defense Shield - Aeon',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        FactionIndex = 2,
        
        Priority = 800,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.012, 1.02 }},

			-- must have at least 1 Experimental level defense ?
			--{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.EXPERIMENTAL * categories.DEFENSE * categories.STRUCTURE }},
            
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.ANTIARTILLERY }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
				
                BuildStructures = {'T3ArtilleryDefenseShield'},
            }
        }
    },
    
    Builder {BuilderName = 'T3 Artillery Defense Shield - Cybran',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        FactionIndex = 3,
        
        Priority = 800,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.005, 1.012 }},
            
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.ANTIARTILLERY }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
				
                BuildStructures = {'T3ArtilleryDefenseShield'},
            }
        }
    },
}

BuilderGroup {BuilderGroupName = 'Engineer Shield Construction - LOUD_IS',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Shields - Core - IS ',
    
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,

		InstanceCount = 1,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            
            { LUTL, 'UnitCapCheckLess', { .95 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},			
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 12, 1.01, 1.02 }},

			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 3, categories.FACTORY * categories.STRUCTURE}},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
        },
		
        BuilderType = {'T2','T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 90,
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayoutInner',
                
                BuildStructures = {'T2ShieldDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'Shields - Outer - IS',
    
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,
		
		InstanceCount = 1,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.005, 1.012 }},
            
			-- must have 4 inner shields
			{ UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
            
			-- and less than 8 shields in the Base - Outer ring
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 16, 45 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
                
                BuildStructures = {'T3ShieldDefense'},
            }
        }
    },

    Builder {BuilderName = 'T3 Artillery Defense Shield - UEF - IS',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        FactionIndex = 1,
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.005, 1.012 }},

			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.ANTIARTILLERY }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
				
                BuildStructures = {'T3ArtilleryDefenseShield'},
            }
        }
    },
    
    Builder {BuilderName = 'T3 Artillery Defense Shield - Aeon - IS',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        FactionIndex = 2,
        
        Priority = 800,
		
        BuilderConditions = {

            { LUTL, 'UnitCapCheckLess', { .90 } },
            
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.012, 1.02 }},

			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.ANTIARTILLERY }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
				
                BuildStructures = {'T3ArtilleryDefenseShield'},
            }
        }
    },
    
    Builder {BuilderName = 'T3 Artillery Defense Shield - Cybran - IS',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        FactionIndex = 3,
        
        Priority = 800,
		
        BuilderConditions = {

            { LUTL, 'UnitCapCheckLess', { .90 } },

			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 25, 1.005, 1.012 }},
            
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.ANTIARTILLERY }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayout',
				
                BuildStructures = {'T3ArtilleryDefenseShield'},
            }
        }
    },
}

BuilderGroup {BuilderGroupName = 'Engineer T4 Shield Construction',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Experimental Shield',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },

		-- this should turn this off if there is less than 30 minutes left in the game
		PriorityFunction = function(self, aiBrain)
			
			if aiBrain.VictoryTime then
			
				if aiBrain.VictoryTime < ( aiBrain.CycleTime + ( 60 * 45 ) ) then	-- less than 45 minutes left
				
					return 0, true
					
				end

			end
			
			return self.Priority, false
		
		end,
		
        Priority = 745,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            { LUTL, 'UnitCapCheckLess', { .90 } },
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
			
			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 6, categories.ENERGYPRODUCTION * categories.TECH3 }},

			-- must have at least 1 Experimental level defense ?
			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.EXPERIMENTAL * categories.DEFENSE * categories.STRUCTURE }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.EXPERIMENTAL * categories.SHIELD }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 3,
			
            Construction = {
				NearBasePerimeterPoints = true,
				MaxThreat = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'ShieldLayoutInner',
				
                BuildStructures = {'T4ShieldDefense'},
            }
        }
    },

}

-- AIRSTAGING, etc. --
BuilderGroup {BuilderGroupName = 'Engineer Misc Construction',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Air Staging',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 850,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
            
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.AIRSTAGINGPLATFORM }},
        },
		
        BuilderType = {'T2','T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = false,
			
			Construction = {
				Radius = 50,			
                NearBasePerimeterPoints = true,
				
				ThreatMax = 50,
				
				BasePerimeterOrientation = 'REAR',
				BasePerimeterSelection = 2,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'T3AirStagingComplex',
				
                BuildStructures = {'T2AirStagingPlatform'},
            }
        }
    },	
}

-- this tucks the Airpad in tighter at the back centre of the base - next to the Gate
BuilderGroup {BuilderGroupName = 'Engineer Misc Construction - Small',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Air Staging - Small Base',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 850,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
            
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.AIRSTAGINGPLATFORM }},
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
			DesiresAssist = false,
			
			Construction = {
				Radius = 26,			
                NearBasePerimeterPoints = true,
                
                ThreatMax = 50,
				
				BasePerimeterOrientation = 'REAR',
				BasePerimeterSelection = 2,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'T3AirStagingComplex',
				
                BuildStructures = {'T2AirStagingPlatform'},
            }
        }
    },	
	
}

--- PERIMETER -- 
BuilderGroup {BuilderGroupName = 'Engineer Base Defense Construction - Perimeter',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T1 Perimeter PD - Small Map',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 795,
		
		
		PriorityFunction = function(self, aiBrain)
			
			if self.Priority != 0 then
			
				if (ScenarioInfo.size[1] >= 1028 or ScenarioInfo.size[2] >= 1028) then
					return 0, false
				end
				
				-- remove after 30 minutes
				if aiBrain.CycleTime > 1800 then
					return 0, false
				end
				
			end
			
			return self.Priority
			
		end,
		
        BuilderConditions = {
			{ EBC, 'GreaterThanEnergyIncome', { 480 }},
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			-- dont have any advanced power built -- makes this gun obsolete
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ENERGYPRODUCTION * categories.STRUCTURE - categories.TECH1 }},
			-- the 12 accounts for the 12 T1 Base PD that may get built in this ring
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 12, categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE, 50, 75}},
        },
		
        BuilderType = { 'T1' },
		
        BuilderData = {
            Construction = {
			
				Radius = 51,
                NearBasePerimeterPoints = true,
				
				BasePerimeterOrientation = 'ALL',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {	'T1GroundDefense','T1Artillery' },
            }
        }
    },

    Builder {BuilderName = 'T1 Perimeter PD - Large Map',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 700,
		
		PriorityFunction = function(self, aiBrain)

			if self.Priority != 0 then
			
				if (ScenarioInfo.size[1] <= 1028 or ScenarioInfo.size[2] <= 1028) then
					return 0, false
				end
				
				-- remove after 30 minutes
				if aiBrain.CycleTime > 1800 then
					return 0, false
				end
				
			end
			
			return self.Priority		
			
		end,
		
        BuilderConditions = {
			{ EBC, 'GreaterThanEnergyIncome', { 480 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
			-- dont have any advanced units
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.STRUCTURE - categories.TECH1 }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 12, categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE}},
        },
		
        BuilderType = { 'T1' },
		
        BuilderData = {
		
            Construction = {
				Radius = 51,
                NearBasePerimeterPoints = true,
				
				BasePerimeterSelection = true,
				BasePerimeterOrientation = 'FRONT',
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {
					'T1GroundDefense',
				},
            }
        }
    },
	
    Builder {BuilderName = 'T1 Perimeter - AA',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 10,

		PriorityFunction = function(self, aiBrain)
		
			-- remove after 30 minutes
			if aiBrain.CycleTime > 1800 then
				return 0, false
			end
			
			-- turn on after 8 minutes
			if aiBrain.CycleTime > 480 then
				return 800, false
			end
			
			return self.Priority
			
		end,
		
        BuilderConditions = {
            { LUTL, 'AirStrengthRatioLessThan', { 4.5 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            
			-- dont have any advanced units
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.STRUCTURE - categories.TECH1 }},
            
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.ANTIAIR, 45, 75}},
        },
		
        BuilderType = { 'T1' },
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 2,
			
            Construction = {
				Radius = 51,
                NearBasePerimeterPoints = true,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T1AADefense'},
            }
        }
    },

    Builder {BuilderName = 'T2 Perimeter TMD',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 740,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },

			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},
            
			-- check for less than 18 T2 TMD 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.ANTIMISSILE * categories.TECH2, 45, 85 }},
        },
		
		BuilderType = { 'T2','T3' },

        BuilderData = {
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T2MissileDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T2 Perimeter Artillery',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
        
        Priority = 740,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .90 } },
			{ LUTL, 'LandStrengthRatioLessThan', { 1.1 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.01, 1.02 }},
			-- check for less than 27 Arty structures in perimeter
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 27, categories.STRUCTURE * categories.ARTILLERY * categories.TECH2, 45, 85 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 2,
            
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T2Artillery'},
            }
        }
    },

    Builder {BuilderName = 'T3 Perimeter PD',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 2,
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
			{ LUTL, 'UnitCapCheckLess', { .95 } },
			{ LUTL, 'LandStrengthRatioLessThan', { 1.1 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.012, 1.02 }}, 
			-- check outer perimeter for maximum T3 PD
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 45, categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH3, 55, 95 }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 2,
			
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
				ThreatMax = 100,	

				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T3GroundDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T3 Perimeter AA',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 2,
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
            
			{ LUTL, 'AirStrengthRatioLessThan', { 3 }},
            
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
            
			-- check outer perimeter for maximum T3 AA
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 36, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 55, 88 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
				ThreatMax = 60,	
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T3AADefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T3 Perimeter Shields',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
			{ LUTL, 'LandStrengthRatioLessThan', { 1.1 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 18900 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
			-- check the outer perimeter for shields
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 60, 88 }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T3ShieldDefense'},
            }
        }
    },

    Builder {BuilderName = 'T4 Perimeter AA',
	
        PlatoonTemplate = 'EngineerBuilder',		
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 730,

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
            
			{ LUTL, 'AirStrengthRatioLessThan', { 3 }},
            
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.STRUCTURE * categories.EXPERIMENTAL * categories.ANTIAIR, 50, 88 }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 4,
			
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
                ThreatMax = 75,

				BasePerimeterOrientation = 'FRONT',				
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T4AADefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T4 Perimeter PD',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 730,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .90 } },
			{ LUTL, 'LandStrengthRatioLessThan', { 1.1 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.STRUCTURE * categories.EXPERIMENTAL * categories.DIRECTFIRE, 50, 88 }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 5,
			
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
                ThreatMax = 100,

				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T4GroundDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'AntiNuke Perimeter',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 730,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3, 50, 88 }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategoryAndAlliance', { 3, categories.NUKE * categories.SILO + categories.SATELLITE, 'Enemy' }},
        },
		
		BuilderType = { 'SubCommander' },
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 4,
			
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,
                
                ThreatMax = 60,

				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'T3StrategicMissileDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'Sera Perimeter Restoration Field',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		FactionIndex = 4,

        Priority = 730,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .80 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.bsb4205, 50, 88 }},
        },
		
		BuilderType = { 'T3','SubCommander' },
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 1,
			
            Construction = {
				Radius = 68,
                NearBasePerimeterPoints = true,

				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {'RestorationField'},
            }
        }
    },
}

BuilderGroup {BuilderGroupName = 'Engineer Shield Augmentation - Perimeter',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T3 Perimeter Shield Augmentation',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
		InstanceCount = 1,
        
        Priority = 745,
		
        BuilderConditions = {
			{ LUTL, 'LandStrengthRatioLessThan', { 1.1 } },
            { LUTL, 'UnitCapCheckLess', { .75 } },
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},			
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
			-- check the outer perimeter for shields
			{ UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 6, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 60, 80 }},
			-- check outer perimeter for storage
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 54, categories.ENERGYSTORAGE * categories.TECH3, 60, 80 }}, 
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            Construction = {
			
				Radius = 68,
                NearBasePerimeterPoints = true,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = {
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
					'T3Storage',
                },
            }
        }
    },
}

--- PICKET LINE -- the most exterior belt of defense - usually AA
BuilderGroup {BuilderGroupName = 'Engineer Base Defense Construction - Picket Line',
	BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T3 Picket AA',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
		InstanceCount = 1,
        
        Priority = 745,

        PriorityFunction = IsEnemyCrushingAir,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            { MIBC, 'BaseInPlayableArea', { 'LocationType' }},			
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
			-- must have less than 27 T3 AA in picket positions
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 36, (categories.STRUCTURE * categories.ANTIAIR) * categories.TECH3, 90, 120 }},
        },
		
		BuilderType = { 'T3' },

        BuilderData = {
            Construction = {
			
				Radius = 100,
                NearBasePerimeterPoints = true,
				
				BasePerimeterOrientation = 'ALL',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseTemplates',
				
                BuildStructures = { 'T3AADefense','T3AADefense','T3AADefense' },
            }
        }
    },			
}

-- DEFEND LOCAL MASS POINTS
BuilderGroup {BuilderGroupName = 'Engineer Mass Point Defense Construction',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T2 Extractor Defense',
	
        PlatoonTemplate = 'EngineerGeneral',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        PlatoonAIPlan = 'EngineerBuildMassDefenseAdjacencyAI',
		
        Priority = 750,
		
        BuilderConditions = {
		
            { LUTL, 'UnitCapCheckLess', { .75 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 4200 }},
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 12, 1.01, 1.02 }},
			{ UCBC, 'MassExtractorHasStorageAndLessDefense', { 'LocationType', 150, 1000, 2, 4, categories.STRUCTURE * categories.DEFENSE }},

        },
		
        BuilderType = {'T2'},
		
        BuilderData = {
		
            Construction = {
			
				LoopBuild = true,
				
				MinRadius = 150,
				Radius = 1000,
				
				MinStructureUnits = 2,
				MaxDefenseStructures = 4,
				MaxDefenseCategories = categories.STRUCTURE * categories.DEFENSE,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'MassAdjacencyDefense',
				
                BuildStructures = {
                    'T2AADefense',
					'T2GroundDefense',
                    'T2AADefense',
					'T2GroundDefense',
                }
            }
        }
    },
	
    Builder {BuilderName = 'T3 Extractor Defense',
	
        PlatoonTemplate = 'EngineerGeneral',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        PlatoonAIPlan = 'EngineerBuildMassDefenseAdjacencyAI',
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'NeedTeamMassPointShare', {}},
            { LUTL, 'UnitCapCheckLess', { .75 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 12, 1.01, 1.02 }},
			{ UCBC, 'MassExtractorHasStorageAndLessDefense', { 'LocationType', 150, 1000, 3, 3, categories.STRUCTURE * categories.DEFENSE * categories.TECH3 }},
        },
		
        BuilderType = {'T3'},
		
        BuilderData = {
		
            Construction = {
			
				MinRadius = 150,
				Radius = 1000,
				
				MinStructureUnits = 3,
				MaxDefenseStructures = 3,
				MaxDefenseCategories = categories.STRUCTURE * categories.DEFENSE * categories.TECH3,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'MassAdjacencyDefense',
				
                BuildStructures = {
                    'T3AADefense',
					'T3GroundDefense',
					'T3AADefense',
                    'T2MissileDefense',
					'T1MassCreation',
					'T3ShieldDefense',
                }
            }
        }
    },
	
}


-----------------------
--- LAND EXPANSIONS ---
-----------------------
--- CORE ---
BuilderGroup {BuilderGroupName = 'Engineer Base Defense Construction - Core - Expansions',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T2 Base PD - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 760,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
			--{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 12, 1.01, 1.02 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 16, categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH2, 14, 48 }},
        },
		
        BuilderType = {'T2'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
                
				ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T2GroundDefense'},
            }
        }
    },

    Builder {BuilderName = 'T2 Base AA - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 760,

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 12, 1.01, 1.02 }}, 
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.ANTIAIR * categories.TECH2, 14, 48 }},
        },
		
        BuilderType = {'T2'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
				
				ThreatMax = 60,				
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T2AADefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T2 Base TMD - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 760,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 0.8, 15, 1.01, 1.02 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.ANTIMISSILE * categories.TECH2, 15, 48 }},
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
            Construction = {
				NearBasePerimeterPoints = true,
				
				ThreatMax = 75,				
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T2MissileDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T2 TML - Expansions',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 710,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE, 15, 48 }},			
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
            Construction = {
                NearBasePerimeterPoints = true,
				
				ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T2StrategicMissile'},
            }
        }
    },

    Builder {BuilderName = 'T3 Base AA - Expansions',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 755, 

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 15, 48 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 3,
			
            Construction = {
				NearBasePerimeterPoints = true,
				
				ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
				BuildStructures = {'T3AADefense'},
            }
        }
    },

    Builder {BuilderName = 'T3 Base PD - Expansions',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 755,
        
        PriorityFunction = IsEnemyCrushingLand,

        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 12, categories.STRUCTURE * categories.TECH3 * categories.DIRECTFIRE, 15, 48 }},
        },
		
        BuilderType = { 'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 4,
			
            Construction = {
				Radius = 1,			
				NearBasePerimeterPoints = true,
				
				ThreatMax = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T3GroundDefense'},
            }
        }
    },
    
    Builder {BuilderName = 'T3 Tactical Artillery - Expansions',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.ARTILLERY * categories.TACTICAL }},
        },
		
        BuilderType = { 'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 4,
			
            Construction = {
				Radius = 1,			
				NearBasePerimeterPoints = true,
				
				ThreatMax = 90,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T3TacticalArtillery'},
            }
        }
    },    

    Builder {BuilderName = 'AntiNuke - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 900,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 2, categories.FACTORY - categories.TECH1 }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3 }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
		
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
                ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T3StrategicMissileDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'Experimental PD - Expansions',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingLand,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.EXPERIMENTAL * categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 4,
            Construction = {
				NearBasePerimeterPoints = true,
				
				ThreatMax = 100,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T4GroundDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'Experimental AA Defense - Expansions',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        PriorityFunction = IsEnemyCrushingAir,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.EXPERIMENTAL * categories.DEFENSE * categories.STRUCTURE * categories.ANTIAIR }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 3,
			
            Construction = {
				NearBasePerimeterPoints = true,
				
				ThreatMax = 90,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T4AADefense'},
            }
        }
    },
	
}

BuilderGroup {BuilderGroupName = 'Engineer Shield Construction - Expansions',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Shields - Inner - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,

		InstanceCount = 1,
        
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},

			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 1, categories.FACTORY * categories.STRUCTURE}},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
        },
		
        BuilderType = {'T2','T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
                
				MaxThreat = 75,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
                
                BuildStructures = {
                    'T2ShieldDefense',
					'EnergyStorage',
					'EnergyStorage',
					'EnergyStorage',
                },
            }
        }
    },

    Builder {BuilderName = 'Shields - Outer - Outer',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,
		
		InstanceCount = 1,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
			-- must have 4 inner shields
			{ UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
			-- and less than 8 shields in the Base - Outer ring
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 16, 45 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
                
				MaxThreat = 45,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
                
                BuildStructures = {
                    'T3ShieldDefense',
					'EnergyStorage',
					'EnergyStorage',
					'EnergyStorage',
                },
            }
        }
    },
}

BuilderGroup {BuilderGroupName = 'Engineer Shield Construction - Expansions - LOUD_IS',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Shields - Inner - Expansion - IS ',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,

        PriorityFunction = IsEnemyCrushingLand,

		InstanceCount = 1,
        
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},

			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 1, categories.FACTORY * categories.STRUCTURE}},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
        },
		
        BuilderType = {'T2','T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
                
				MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T2ShieldDefense'},
            }
        }
    },	
	
    Builder {BuilderName = 'Shields - Outer - Expansion - IS',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 800,
		
		InstanceCount = 1,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
			-- must have 4 inner shields
			{ UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 5, 16 }},
			-- and less than 8 shields in the Base - Outer ring
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 16, 45 }},
        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            Construction = {
				NearBasePerimeterPoints = true,
                
				MaxThreat = 60,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
                
                BuildStructures = {'T3ShieldDefense'},
            }
        }
    },	
}

BuilderGroup {BuilderGroupName = 'Engineer T4 Shield Construction - Expansions',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Experimental Shield - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
			{ LUTL, 'UnitsGreaterAtLocation', { 'LocationType', 8, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY }},
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 60, 1.02, 1.04 }},
			
			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 6, categories.ENERGYPRODUCTION * categories.TECH3 }},

			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.EXPERIMENTAL * categories.SHIELD }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 3,
            
            Construction = {
				NearBasePerimeterPoints = true,
                
				MaxThreat = 60,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
                
                BuildStructures = {'T4ShieldDefense'},
            }
        }
    },
}

--- PERIMETER ---
BuilderGroup {BuilderGroupName = 'Engineer Base Defense Construction - Perimeter - Expansions',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T2 Perimeter PD - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
		InstanceCount = 1,
        
        Priority = 710,

        PriorityFunction = IsEnemyCrushingLand,
        
        BuilderConditions = {
			{ LUTL, 'LandStrengthRatioLessThan', { 1.1 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .75 } },
			
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            
			-- check perimeter for less than 18 T2 PD
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH2, 46, 75 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },		

        BuilderData = {
            Construction = {
			
				AddRotations = 1,			
				Radius = 55,
                
                NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
				MaxThreat = 60,

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseExpansionTemplates',
				
                BuildStructures = {
                    'T2GroundDefense',
					'T2GroundDefense',
                },
            }
        }
    },
	
    Builder {BuilderName = 'T2 Perimeter AA - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
		InstanceCount = 1,
        
        Priority = 710,

        PriorityFunction = IsEnemyCrushingAir,
        
        BuilderConditions = {
        
			{ LUTL, 'AirStrengthRatioLessThan', { 4.5 }},
            
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            
            { LUTL, 'UnitCapCheckLess', { .75 } },

			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            
			-- check perimeter for less than 18 T2 AA
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.ANTIAIR * categories.TECH2, 46, 75 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
            Construction = {
			
				AddRotations = 1,
				Radius = 55,

                NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
				MaxThreat = 45,
                
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseExpansionTemplates',
				
                BuildStructures = {
					'T2AADefense',
                    'T2AADefense',
					'T2MissileDefense',
                },
            }
        }
    },
	
    Builder {BuilderName = 'T2 Perimeter TMD - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
		InstanceCount = 1,
        
        Priority = 710,

        PriorityFunction = IsEnemyCrushingLand,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },

			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            
			-- check perimeter for less than 9 T2 TMD
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.STRUCTURE * categories.ANTIMISSILE * categories.TECH2, 46, 75 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
            Construction = {
			
				AddRotations = 1,
				Radius = 55,

                NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
				MaxThreat = 50,

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseExpansionTemplates',
				
                BuildStructures = {'T2MissileDefense'},
            }
        }
    },
	
    Builder {BuilderName = 'T3 Perimeter PD - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 710,

        PriorityFunction = IsEnemyCrushingLand,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 3, categories.FACTORY - categories.TECH1 }},

			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            
			-- check outer perimeter for maximum T3 PD
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.DIRECTFIRE * categories.STRUCTURE * categories.TECH3, 46, 75 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 2,
            Construction = {
			
				AddRotations = 1,
				Radius = 55,

                NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
                MaxThreat = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseExpansionTemplates',
				
                BuildStructures = {
					'T3GroundDefense',
                    'T3GroundDefense',
                },
            }
        }
    },
	
    Builder {BuilderName = 'T3 Perimeter AA - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 710,

        PriorityFunction = IsEnemyCrushingAir,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 3, categories.FACTORY - categories.TECH1 }},

			{ TBC, 'ThreatCloserThan', { 'LocationType', 450, 35, 'Air' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
            
			-- check outer perimeter for maximum T3 AA
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, (categories.STRUCTURE * categories.ANTIAIR) * categories.TECH3, 46, 75 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
			
				AddRotations = 1,
				Radius = 55,
				
                NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
                MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseExpansionTemplates',
				
                BuildStructures = {
					'T3AADefense',
                    'T3AADefense',
                },
            }
        }
    },

    Builder {BuilderName = 'T3 Perimeter Shields - Expansion',
    
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 710,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },			
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 3, categories.FACTORY - categories.TECH1 }},
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
            
			-- check outer perimeter for maximum T3 PD
			{ UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.SHIELD * categories.STRUCTURE, 46, 75 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 2,
            Construction = {
			
				AddRotations = 1,
				Radius = 55,

                NearBasePerimeterPoints = true,
				BasePerimeterOrientation = 'FRONT',
                
                MaxThreat = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'PerimeterDefenseExpansionTemplates',
				
                BuildStructures = {'T3ShieldDefense'},
            }
        }
    },

}

-- AIRSTAGING, etc.
BuilderGroup {BuilderGroupName = 'Engineer Misc Construction - Expansions',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Air Staging - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 775,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.AIRSTAGINGPLATFORM }},
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
			DesiresAssist = true,
			Construction = {
                NearBasePerimeterPoints = true,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
                
                MaxThreat = 75,
				
                BuildStructures = {'T2AirStagingPlatform'},
            }
        }
    },	
	
    Builder {BuilderName = 'T2 Radar Jamming - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 745,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.COUNTERINTELLIGENCE * categories.STRUCTURE }},
        },
		
        BuilderType = {'T2','T3'},
		
        BuilderData = {
			Construction = {
			
				Radius = 1,			
				NearBasePerimeterPoints = true,
				
				MaxThreat = 30,
				
				BasePerimeterOrientation = 'FRONT',

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T2RadarJammer'},
            }
        }
    },
	
    Builder {BuilderName = 'T3 Teleport Jamming - Expansion',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 0,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
			-- trigger this build if enemy has an Aeon scry device
			--{ LUTL, 'HaveGreaterThanUnitsWithCategoryAndAlliance', { 0, categories.AEON * categories.OPTICS * categories.STRUCTURE, 'Enemy' }},
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.ANTITELEPORT * categories.STRUCTURE * categories.TECH3 }},

        },
		
        BuilderType = {'T3','SubCommander'},
		
        BuilderData = {
		
			Construction = {
			
				Radius = 1,
				NearBasePerimeterPoints = true,
				
				BasePerimeterOrientation = 'FRONT',

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'ExpansionLayout_II',
				
                BuildStructures = {'T3TeleportJammer'},
            }
        }
    },	
	
}


------------------------
--- NAVAL EXPANSIONS ---
------------------------
BuilderGroup {BuilderGroupName = 'Engineer Base Defense Construction - Naval',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'T1 Defenses Naval',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 800,
		
		PriorityFunction = function(self, aiBrain)
		
			if self.Priority != 0 then

				-- remove after 40 minutes
				if aiBrain.CycleTime > 2400 then
					return 0, false
				end
				
			end
			
			return self.Priority
			
		end,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .65 } },
            
            -- obsolete once T2 or better available
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, categories.FACTORY - categories.TECH1 }},
            
			{ EBC, 'GreaterThanEconStorageCurrent', { 175, 1750 }},

            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.STRUCTURE * categories.ANTINAVY, 50, 85 }},
        },
		
		BuilderType = { 'T1','T2'},

        BuilderData = {
            Construction = {
			
				Radius = 63,
				AddRotations = 1,
                NearBasePerimeterPoints = true,
                
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
                
				ThreatMax = 90,

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'NavalPerimeterDefenseTemplate',
				
                BuildStructures = {
					'T1NavalDefense',
                },
            }
        }
    },
	
    Builder {BuilderName = 'T2 Defenses Naval',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,
		
		PriorityFunction = IsEnemyNavalActive,		
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.FACTORY - categories.TECH1 }},

			--{ TBC, 'ThreatCloserThan', { 'LocationType', 450, 30, 'Naval' }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 18, categories.STRUCTURE * categories.ANTINAVY * categories.TECH2, 50, 85 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander'},

        BuilderData = {
            Construction = {
			
				Radius = 63,
				AddRotations = 1,
                NearBasePerimeterPoints = true,
                
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
                
				ThreatMax = 90,

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'NavalPerimeterDefenseTemplate',
				
                BuildStructures = {
					'T2NavalDefense',
                },
            }
        }
    },

    Builder {BuilderName = 'T2 AA Defenses - Naval',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.FACTORY - categories.TECH1 }},
            
			{ EBC, 'GreaterThanEconStorageCurrent', { 250, 2500 }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.STRUCTURE * categories.ANTIAIR * categories.TECH2, 50, 85 }},
        },
		
		BuilderType = { 'T2','T3' },

        BuilderData = {
        
            DesireAssist = true,
            
            Construction = {
			
				Radius = 63,
				AddRotations = 1,
                NearBasePerimeterPoints = true,
                
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
                
				ThreatMax = 60,

				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'NavalPerimeterDefenseTemplate',
				
                BuildStructures = {
					'T2AADefenseAmphibious',
					'T2MissileDefense',					
                },
            }
        }
    },
	
    Builder {BuilderName = 'T3 Defenses Naval',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,
		
		PriorityFunction = IsEnemyNavalActive,		
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 2, categories.FACTORY - categories.TECH1 }},

			{ EBC, 'GreaterThanEconStorageCurrent', { 250, 2500 }},

            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 9, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 50, 85 }},
        },
		
		BuilderType = { 'T3','SubCommander'},

        BuilderData = {
		
			DesiresAssist = true,
			
            Construction = {
			
				Radius = 63,
				AddRotations = 1,
                NearBasePerimeterPoints = true,
				
				ThreatMax = 100,
				
				BasePerimeterOrientation = 'FRONT',
				BasePerimeterSelection = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/loud_perimeter_defense_templates.lua',
				BaseTemplate = 'NavalPerimeterDefenseTemplate',
				
                BuildStructures = {
					'T3AADefense',
					'T3NavalDefense',
				},
            }
        }
    },
	
    Builder {BuilderName = 'T3 Base AA - Naval',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,

        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.FACTORY - categories.TECH1 }},

			{ EBC, 'GreaterThanEconStorageCurrent', { 250, 2500 }},

            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 1, 40 }},
        },
		
		BuilderType = { 'T3','SubCommander'},

        BuilderData = {
        
			DesiresAssist = true,
			
            Construction = {
                NearBasePerimeterPoints = true,
				
				ThreatMax = 75,

				BasePerimeterSelection = true,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'NavalExpansionBase',
				
                BuildStructures = {'T3AADefense'},
            }
        }
    },	

    Builder {BuilderName = 'Naval AntiNuke',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 850,

        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            
			{ LUTL, 'FactoryGreaterAtLocation', { 'LocationType', 3, categories.FACTORY - categories.TECH1 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 30, 1.02, 1.02 }},
            
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3 }},
        },
		
        BuilderType = {'SubCommander'},
		
        BuilderData = {
        
			DesiresAssist = true,
			
            Construction = {
                NearBasePerimeterPoints = true,
                
				ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'NavalExpansionBase',
				
                BuildStructures = {'T3StrategicMissileDefense'},
            }
        }
    },
	
}

BuilderGroup {BuilderGroupName = 'Engineer Misc Construction - Naval',
    BuildersType = 'EngineerBuilder',
	
    Builder {BuilderName = 'Naval AirStaging',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.AIRSTAGINGPLATFORM }},
        },
		
		BuilderType = { 'T2','T3' },

        BuilderData = {
            Construction = {
                NearBasePerimeterPoints = true,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_Expansion_Base_Templates.lua',
				BaseTemplate = 'NavalExpansionBase',
                
                MaxThreat = 75,
				
                BuildStructures = {'T2AirStagingPlatform' },
            }
        }
    },	
	
}


------------------------
--- DEFENSIVE POINTS ---
------------------------
BuilderGroup {BuilderGroupName = 'Engineer Defenses DP Standard',
	BuildersType = 'EngineerBuilder',

    Builder {BuilderName = 'DP STD Radar',
	
        PlatoonTemplate = 'EngineerBuilder',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,

        BuilderConditions = {
            { LUTL, 'UnitsLessAtLocation', { 'LocationType', 1, categories.STRUCTURE * categories.OVERLAYRADAR * categories.INTELLIGENCE }},
            { LUTL, 'UnitCapCheckLess', { .95 } },
			
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 			
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 50,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
                
                BuildStructures = {	'T2Radar' }
            }
        }
    },
	
    Builder {BuilderName = 'T2 DP STD Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        
        Priority = 750,
		
		PriorityFunction = IsPrimaryBase,
		
        BuilderConditions = {
		
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},
            { LUTL, 'UnitCapCheckLess', { .85 } },
			
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 			
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 8, categories.STRUCTURE * categories.DEFENSE * categories.TECH2 * categories.DIRECTFIRE, 0, 24 }},
			
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
		
			DesiresAssist = true,
			
            Construction = {
			
				NearBasePerimeterPoints = true,

                ThreatMin = 20,
                ThreatMax = 75,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
				
                BuildStructures = {
					'T2GroundDefense',
					'T2GroundDefense',
					'T2AADefense',
					'T2AADefense',
					'T2GroundDefense',
					'T2GroundDefense',
					'T2GroundDefense',
					'T2GroundDefense',
					'T2AADefense',
					'T2AADefense',
					'T2GroundDefense',
					'T2GroundDefense',
                }
            }
        }
		
    },
	
    Builder {BuilderName = 'T2 DP STD Auxiliary Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            { UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 0, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},			
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 1, categories.ENERGYPRODUCTION - categories.TECH1, 0, 28 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 90,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
                
                BuildStructures = {
					'T2RadarJammer',
					'T2AirStagingPlatform',
					'T2MissileDefense',
					'T2MissileDefense',
					'T2EnergyProduction',
					'T1MassCreation',
					'T1MassCreation',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
					'Wall',
                }
            }
        }
    },	

    Builder {BuilderName = 'T3 DP STD Shields',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
                
                BuildStructures = {
					'T3ShieldDefense',
					'T3ShieldDefense',
                    'T1MassCreation',
                }
            }
        }
    },

    Builder {BuilderName = 'T3 DP STD AA Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 0, 24 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 90,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
                
                BuildStructures = {
					'T3AADefense',
                    'T3AADefense',
					'T3AADefense',
                    'T3AADefense',
                }
            }
        }
    },

    Builder {BuilderName = 'T3 DP STD Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.DEFENSE * categories.TECH3 * categories.DIRECTFIRE, 0, 24 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 100,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
                
                BuildStructures = {
                    'T3GroundDefense',
					'T3GroundDefense',
                    'T1MassCreation',
                }
            }
        }
    },
	
    Builder {BuilderName = 'T2 DP STD TML',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			--{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE }},			
        },
		
        BuilderType = {'T2','T3','SubCommander' },
		
        BuilderData = {
            Construction = {
                NearBasePerimeterPoints = true,
				
				ThreatMax = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
				
                BuildStructures = {'T2StrategicMissile'},
            }
        }
    },
        
    Builder {BuilderName = 'T3 DP STD Tactical Artillery',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ARTILLERY * categories.TACTICAL }},
        },
		
        BuilderType = { 'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 4,
			
            Construction = {
				Radius = 1,
				NearBasePerimeterPoints = true,

				ThreatMax = 100,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',

                BuildStructures = {'T3TacticalArtillery'},
            }
        }
    },    
    
    Builder {BuilderName = 'T4 DP STD AA Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
		PriorityFunction = IsPrimaryBase,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 450, 35, 'Air' }},
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 60, 1.02, 1.04 }},
			-- must have shields here
            { UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 0, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.ANTIAIR * categories.EXPERIMENTAL, 0, 24 }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 2,

            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 90,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
				
                BuildStructures = {'T4AADefense'}
            }
        }
    },
	
    Builder {BuilderName = 'T4 DP STD Antinuke Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
		PriorityFunction = IsPrimaryBase,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
            
			-- must have shields here
            { UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 0, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategoryAndAlliance', { 0, categories.NUKE + categories.ANTIMISSILE - categories.TECH2, 'Enemy' }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',
				
                BuildStructures = {'T3StrategicMissileDefense'}
            }
        }
    },
	
}

BuilderGroup {BuilderGroupName = 'Engineer Defenses DP Small',
	BuildersType = 'EngineerBuilder',

    Builder {BuilderName = 'DP SML Radar',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 751,

        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
            { LUTL, 'UnitsLessAtLocation', { 'LocationType', 1, categories.STRUCTURE * categories.OVERLAYRADAR * categories.INTELLIGENCE }},
			
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 			
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {
                    'T2Radar',
                    'T2MissileDefense',
                }
            }
        }
    },

    Builder {BuilderName = 'T2 DP SML Auxiliary Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 1, categories.AIRSTAGINGPLATFORM - categories.MOBILE, 0, 28 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {
					'T2AirStagingPlatform',
					'T2MissileDefense',
					'T2RadarJammer',                    
                }
            }
        }
    },	

    Builder {BuilderName = 'T3 DP SML AA Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 4, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 0, 24 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {
					'T3AADefense',
                }
            }
        }
    },

    Builder {BuilderName = 'T2 DP SML Shields',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 12600 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }},
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 1, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 100,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {	'T2ShieldDefense' }
            }
        }
    },

    Builder {BuilderName = 'T3 DP SML Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
			{ LUTL, 'GreaterThanEnergyIncome', { 16800 }},
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 30, 1.02, 1.04 }}, 
            
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.DEFENSE * categories.TECH3 * categories.DIRECTFIRE, 0, 24 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 100,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {
                    'T3GroundDefense',
                }
            }
        }
    },
	
    Builder {BuilderName = 'T2 DP SML TML',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,

        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
            
			--{ TBC, 'ThreatCloserThan', { 'LocationType', 400, 75, 'Land' }},

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE }},			
        },
		
        BuilderType = {'T2','T3','SubCommander' },
		
        BuilderData = {
            Construction = {
                NearBasePerimeterPoints = true,
				
				ThreatMax = 100,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
				
                BuildStructures = {'T2StrategicMissile'},
            }
        }
    },
    
    Builder {BuilderName = 'T3 DP SML Tactical Artillery',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }},
            
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ARTILLERY * categories.TACTICAL }},
        },
		
        BuilderType = { 'T3','SubCommander'},
		
        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 4,
			
            Construction = {
				Radius = 1,
				NearBasePerimeterPoints = true,

				ThreatMax = 100,

				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointStandard',

                BuildStructures = {'T3TacticalArtillery'},
            }
        }
    },    

    Builder {BuilderName = 'T4 DP SML AA Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
		PriorityFunction = IsPrimaryBase,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },

			{ TBC, 'ThreatCloserThan', { 'LocationType', 450, 35, 'Air' }},
            
			{ EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 60, 1.02, 1.04 }},
            
			-- must have shields here
            { UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 0, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 1, categories.STRUCTURE * categories.ANTIAIR * categories.EXPERIMENTAL, 0, 24 }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			NumAssistees = 2,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 90,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {'T4AADefense'}
            }
        }
    },
	
    Builder {BuilderName = 'T4 DP SML Antinuke Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 850,
		
		PriorityFunction = IsPrimaryBase,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 21000 }},
			
		    { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3 }},			

			-- must have shields here
            { UCBC, 'UnitsGreaterAtLocationInRange', { 'LocationType', 0, categories.STRUCTURE * categories.SHIELD - categories.ANTIARTILLERY, 0, 24 }},
			{ UCBC, 'HaveGreaterThanUnitsWithCategoryAndAlliance', { 0, categories.NUKE + categories.ANTIMISSILE - categories.TECH2, 'Enemy' }},
        },
		
		BuilderType = { 'SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 60,
                
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'DefensivePointSmall',
                
                BuildStructures = {'T3StrategicMissileDefense'}
            }
        }
    },
	
}

BuilderGroup {BuilderGroupName = 'Engineer Defenses DP Naval',
	BuildersType = 'EngineerBuilder',

    Builder {BuilderName = 'Naval DP Sonar',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 760,

		PriorityFunction = IsNavalMap,
        
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
			{ LUTL, 'UnitsLessAtLocation', { 'LocationType', 1, categories.STRUCTURE * categories.OVERLAYSONAR * categories.INTELLIGENCE }},
			{ LUTL, 'UnitsLessAtLocation', { 'LocationType', 1, categories.MOBILESONAR * categories.INTELLIGENCE * categories.TECH3 }},
			
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 			
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {
                    'T2Sonar',
                    'T2MissileDefense',
                }
            }
        }
    },

    Builder {BuilderName = 'Naval DP Airstaging',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 760,

        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 1, categories.AIRSTAGINGPLATFORM - categories.MOBILE, 0, 28 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
            
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {
					'T2AirStagingPlatform',
					'T2MissileDefense',
				}
            }
        }
    },	

    Builder {BuilderName = 'Naval DP T2 AA Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 700,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.ANTIAIR * categories.TECH2, 0, 24 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {'T2AADefenseAmphibious'}
            }
        }
    },

    Builder {BuilderName = 'Naval DP T2 Surface Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 700,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .75 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.DEFENSE * categories.DIRECTFIRE, 0, 24 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 50,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {'T2GroundDefenseAmphibious'}
            }
        }
    },
	
    Builder {BuilderName = 'Naval DP T2 Naval Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 700,
        
		PriorityFunction = IsNavalMap,		        
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.ANTINAVY * categories.TECH2, 0, 24 }},
        },
		
		BuilderType = { 'T2','T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 60,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {'T2NavalDefense'}
            }
        }
    },

    Builder {BuilderName = 'Naval DP T3 AA Defenses',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
        Priority = 750,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .85 } },

            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 1, 15, 1.012, 1.025 }}, 
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 2, categories.STRUCTURE * categories.ANTIAIR * categories.TECH3, 0, 24 }},
        },
		
		BuilderType = { 'T3','SubCommander' },

        BuilderData = {
			DesiresAssist = true,
			
            Construction = {
				NearBasePerimeterPoints = true,
                
                ThreatMax = 75,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {'T3AADefense'}
            }
        }
    },
	
    Builder {BuilderName = 'Naval DP Antinuke',
	
        PlatoonTemplate = 'EngineerBuilder',
        
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
		
		InstanceCount = 1,
		
        Priority = 900,
		
        BuilderConditions = {
            { LUTL, 'UnitCapCheckLess', { .95 } },
			{ LUTL, 'GreaterThanEnergyIncome', { 50000 }},
            
            { EBC, 'GreaterThanEconTrendEfficiencyOverTime', { 2, 60, 1.02, 1.04 }},
            { UCBC, 'UnitsLessAtLocationInRange', { 'LocationType', 1, categories.ANTIMISSILE * categories.SILO * categories.STRUCTURE * categories.TECH3, 0, 15 }},
        },
		
		BuilderType = { 'SubCommander' },
		
        BuilderData = {
			DesiresAssist = true,
            NumAssistees = 2,
			
            Construction = {
                NearBasePerimeterPoints = true,
                
                ThreatMax = 50,
				
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_DP_Templates.lua',
				BaseTemplate = 'NavalDefensivePoint',
				
                BuildStructures = {'T3StrategicMissileDefense'},
            }
        }
    },	
}

