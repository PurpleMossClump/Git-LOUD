-- Maps specific key combinations to console commands
-- Key combos should be seperated by -'s
-- See keyNames.lua for key names! Key names for modifiers are as follows and must be followed by a dash ('-')
-- Shift = 0x10
-- Ctrl = 0x11
-- Alt = 0x12
keyDescriptions = {
    ['escape'] = 'Deselects current selection or cancels current action',
    ['pause'] = 'Toggles Game Pause',
    ['cap_frame'] = 'Take a screen shot',
    ['show_fps'] = "Toggle the display of frames rendered per second",
    ['toggle_markers_screen'] = "Toggle AI Marker Debug Utilities Screen",
    ['toggle_profiler'] = 'Toggle Profiler',
    ['toggle_profiler_window'] = 'Toggle Profiler Window',
    
    ['group1'] = 'Recall Group 1',
    ['group2'] = 'Recall Group 2',
    ['group3'] = 'Recall Group 3',
    ['group4'] = 'Recall Group 4',
    ['group5'] = 'Recall Group 5',
    ['group6'] = 'Recall Group 6',
    ['group7'] = 'Recall Group 7',
    ['group8'] = 'Recall Group 8',
    ['group9'] = 'Recall Group 9',
    ['group0'] = 'Recall Group 10',
    ['toggle_lifebars'] = 'Toggle life bars',

    ['set_group1'] = 'Set Group 1',
    ['set_group2'] = 'Set Group 2',
    ['set_group3'] = 'Set Group 3',
    ['set_group4'] = 'Set Group 4',
    ['set_group5'] = 'Set Group 5',
    ['set_group6'] = 'Set Group 6',
    ['set_group7'] = 'Set Group 7',
    ['set_group8'] = 'Set Group 8',
    ['set_group9'] = 'Set Group 9',
    ['set_group0'] = 'Set Group 10',
    
    ['append_group1'] = 'Append Group 1 to current selection',
    ['append_group2'] = 'Append Group 2 to current selection',
    ['append_group3'] = 'Append Group 3 to current selection',
    ['append_group4'] = 'Append Group 4 to current selection',
    ['append_group5'] = 'Append Group 5 to current selection',
    ['append_group6'] = 'Append Group 6 to current selection',
    ['append_group7'] = 'Append Group 7 to current selection',
    ['append_group8'] = 'Append Group 8 to current selection',
    ['append_group9'] = 'Append Group 9 to current selection',
    ['append_group0'] = 'Append Group 10 to current selection',
    
    ['fac_group1'] = 'Select only factories from Group 1',
    ['fac_group2'] = 'Select only factories from Group 2',
    ['fac_group3'] = 'Select only factories from Group 3',
    ['fac_group4'] = 'Select only factories from Group 4',
    ['fac_group5'] = 'Select only factories from Group 5',
    ['fac_group6'] = 'Select only factories from Group 6',
    ['fac_group7'] = 'Select only factories from Group 7',
    ['fac_group8'] = 'Select only factories from Group 8',
    ['fac_group9'] = 'Select only factories from Group 9',
    ['fac_group0'] = 'Select only factories from Group 10',

    ['next_cam_position'] 	= 'Go to the next saved Camera Position',
    ['add_cam_position'] 	= 'Save a Camera Position',
    ['rem_cam_position'] 	= 'Delete current Camera Position',
    
    ['zoom_in'] 			= 'Zoom your View in',
    ['zoom_out'] 			= 'Zoom your View out',
    ['zoom_in_fast'] 		= 'Zoom your View in fast',
    ['zoom_out_fast'] 		= 'Zoom your View out fast',
    ['tog_military'] 		= 'Toggle Military Overlay',
    ['tog_defense'] 		= 'Toggle Unit Color',
    ['tog_econ'] 			= 'Toggle Economy Overlay',
    ['tog_intel'] 			= 'Toggle Intel Overlay',
    ['track_unit'] 			= 'Track a unit in the Primary view',
    ['track_unit_minimap'] 	= 'Track a unit in the Strategic view',
    ['track_unit_second_mon'] = 'Track a unit on the Second Monitor',
    ['select_air'] 			= 'Select all Air units',
    ['select_naval'] 		= 'Select all Naval units',
	['select_groundattack']	= 'Select all Gunships and Bombers',
	['select_transport'] 	= 'Select all Air Transports',
    ['cap_frames'] 			= 'Capture Frames',
    ['pause_unit'] 			= 'Pause',
    ['suicide'] 			= 'Self-Destruct',
    ['select_land'] 		= 'Select all Land units',
    ['select_all_units_of_same_type'] = 'Select all units similar to those selected',
    ['reset_camera'] 		= 'Reset the Camera',
	
    -- ['build'] = '<LOC key_desc_0061>Silo Build mode',
	
    ['select_engineers'] 	= 'Select all Engineers',
    ['repair'] 				= 'Repair',
    ['reclaim'] 			= 'Reclaim',
    ['patrol'] 				= 'Patrol',
    ['attack'] 				= 'Attack',
    ['capture'] 			= 'Capture',
    ['stop'] 				= 'Stop and cancel all Orders',
    ['dive'] 				= 'Dive',
    ['ferry'] 				= 'Ferry',
    ['guard'] 				= 'Assist',
    ['transport'] 			= 'Transport',
    ['launch_tactical'] 	= 'Launch a Tactical Missile',
    ['overcharge'] 			= 'Overcharge',
    ['move'] 				= 'Move',
    ['nuke'] 				= 'Nuke',
    ['mode'] 				= 'Cycle through all of the available fire states.',
    ['shift_repair'] 		= 'Repair',
    ['shift_reclaim'] 		= 'Reclaim',
    ['shift_patrol'] 		= 'Patrol',
    ['shift_attack'] 		= 'Attack',
    ['shift_capture'] 		= 'Capture',
    ['shift_stop'] 			= 'Stop and cancel all Orders',
    ['shift_dive'] 			= 'Dive',
    ['shift_ferry'] 		= 'Ferry',
    ['shift_guard'] 		= 'Assist',
    ['shift_transport'] 	= 'Transport',
    ['shift_launch_tactical'] = 'Launch a Tactical Missile',
    ['shift_overcharge'] 	= 'Overcharge',
    ['shift_move'] 			= 'Move',
    ['shift_nuke'] 			= 'Nuke',
    ['rename'] 				= 'Rename the selected unit',
    ['goto_engineer'] 		= 'Go to the nearest idle Engineer',
    ['select_idle_engineer'] = 'Select the nearest idle Engineer',
    ['cycle_engineers'] 	= 'Cycle through all Engineers',
    ['goto_commander'] 		= 'Go to your ACU',
    ['select_commander'] 	= 'Select your ACU',
    ['select_all'] 			= 'Select all units',
    ['select_all_onscreen'] = 'Select all units on the screen',
    ['select_all_eng_onscreen'] = 'Select all Engineers on the screen',
    ['select_all_factory_onscreen'] = 'Select all Factories on the screen',
    ['select_nearest_factory'] = 'Select the nearest Factory',
    ['select_nearest_land_factory'] = 'Select the nearest Land Factory',
    ['select_nearest_air_factory'] = 'Select the nearest Air Factory',
    ['select_nearest_naval_factory'] = 'Select the nearest Naval Factory',
    ['toggle_build_mode'] 	= 'Toggles keyboard build command mode on and off',
    ['area_reclaim'] = 'Reclaim Everything Around Cursor',

    ['decrease_game_speed'] = 'Decrease game speed',
    ['increase_game_speed'] = 'Increase game speed',
    ['reset_game_speed'] 	= 'Reset game speed to 0 (Normal Speed)',
    ['focus_window_primary'] = 'Set focus to the Primary Monitor',
    ['focus_window_secondary'] = 'Set focus to the Secondary Monitor',

    ['split_screen_enable'] = 'Enable split screen',
    ['split_screen_disable'] = 'Disable split screen',
    ['pause_single_step'] 	= 'While paused, step forward one tick',
    ['chat_page_up'] 		= 'Chat page up',
    ['chat_page_down'] 		= 'Chat page down',
    ['chat_line_up'] 		= 'Chat line up',
    ['chat_line_down'] 		= 'Chat line down',

    ['switch_skin_up'] 		= 'Rotate skins up',
    ['switch_skin_down'] 	= 'Rotate skins down',
    ['switch_layout_up'] 	= 'Rotate layouts up',
    ['switch_layout_down'] 	= 'Rotate layouts down',
    
    ['toggle_main_menu'] 	= 'Toggles the main menu',
    ['toggle_score_screen'] = 'Toggles the Score Overlay',
    ['toggle_objective_screen'] = 'Toggles the Objective Window',
    ['toggle_transmission_screen'] = 'Toggles the Transmission Window',
    ['toggle_diplomacy_screen'] = 'Toggles the Diplomacy Window',
    ['toggle_disconnect_screen'] = 'Toggles the Connectivity Screen',
    ['toggle_key_bindings'] = 'Toggles the Key Bindings Screen',
    ['ping_alert'] 			= 'Create an alert ping at the mouse location',
    ['ping_attack'] 		= 'Create an attack ping at the mouse location',
    ['ping_move'] 			= 'Create a move ping at the mouse location',
    ['ping_marker'] 		= 'Create a marker at the mouse location',
    ['toggle_map_control'] 	= "Toggles the map control window",
    ['cam_free'] 			= "Toggles camera free mode",
    
    ['quick_save'] 			= "Save the game to a special quick save file",
    ['mouse_help'] 			= "Turn the mouse button help icon on/off",

    ['create_build_template'] = "Create a build template based on the current selection", 

    ['debug_navpath'] 				= "Toggles pathfinding debugger",
    ['debug_create_unit'] 			= "Shows a dialog that allows you to create units",
    ['debug_teleport'] 				= "Teleports selected unit to the current cursor position",
    ['debug_run_opponent_AI'] 		= "Toggles opponent AI",
    ['debug_blingbling'] 			= "Provides lots of resources",
    ['debug_destroy_units'] 		= "Destroys selected units with no confirmation",
    ['debug_graphics_fidelity_0'] 	= "Set the graphics fidelity to minimum",
    ['debug_graphics_fidelity_2'] 	= "Set the graphics fidelity to maximum",
    ['debug_scenario_method_f3'] 	= "Run the scenario method OnF3",
    ['debug_scenario_method_shift_f3'] 	= "Run the scenario method OnShiftF3",
    ['debug_scenario_method_ctrl_f3'] 	= "Run the scenario method OnCtrlF3",
    ['debug_scenario_method_shift_f4'] 	= "Run the scenario method OnShiftF4",
    ['debug_scenario_method_ctrl_f4'] 	= "Run the scenario method OnCtrlF4",
    ['debug_scenario_method_ctrl_alt_f3'] = "Run the scenario method OnCtrlAltF4",
    ['debug_scenario_method_f4'] 	= "Run the scenario method OnF4",
    ['debug_scenario_method_f5'] 	= "Run the scenario method OnF5",
    ['debug_scenario_method_shift_f5'] 	= "Run the scenario method OnShiftF5",
    ['debug_scenario_method_ctrl_f5'] 	= "Run the scenario method OnCtrlF5",
    ['debug_scenario_method_ctrl_alt_f5'] = "Run the scenario method OnCtrlAltF5",
    ['debug_campaign_instawin'] 	= "Marks all campaign missions as won",
    ['debug_create_entity'] 		= "Shows a dialog that allows you to create entities",
    ['debug_show_stats'] 			= "Toggle a dialog that shows game statistics",
    ['debug_show_army_stats'] 		= "Toggle a dialog that shows army statistics",
    ['debug_toggle_log_window'] 	= "Toggles the debugging log window",
    ['debug_open_lua_debugger'] 	= "Opens the lua debugging window",
    ['debug_show_frame_stats'] 		= "Toggle a dialog that shows performance statistics",
    ['debug_render_wireframe'] 		= "Toggle the rendering of all geometry in wireframe mode",
    ['debug_weapons'] 				= "Toggles the weapon arc debug information",
    ['debug_grid'] 					= "Toggles the debugging o grid",
    ['debug_show_focus_ui_control'] = "Toggles the display of a rectangle around the focus UI control",
    ['debug_dump_focus_ui_control'] = "Dumps info about UI controls under mouse to log window",
    ['debug_dump_ui_controls'] 		= "Dumps info about all UI controls to the log window",
    ['debug_skeletons'] 			= "Toggles wireframe skeletons for all units",
    ['debug_bones'] 				= "Toggles bone display for all units",
    ['debug_redo_console_command'] 	= "Re-runs the last console command",
    ['debug_copy_units'] 			= "Remember all unit types in the paste buffer",
    ['debug_paste_units'] 			= "Paste a copy of all units in the paste buffer",
    ['debug_cam_zoom_far'] 			= "Quickly zoom the camera out",
    ['debug_cam_zoom_near'] 		= "Quickly zoom the camera in",
    ['debug_nodamage'] 				= "Toggle unit damage",
    ['debug_show_emmitter_window'] 	= "Display the emitter adjustment dialog",
    ['debug_sally_shears'] 			= "Remove fog of war",
    ['debug_collision'] 			= "Toggle collision debug information",
    ['debug_pause_single_step'] 	= "Single step the simulation while game is paused",
    ['debug_restart_session'] 		= "Restart the current session using the same parameters",
    ['debug_toggle_flavah'] 		= "Toggle the world flavor text on/off",
    ['debug_ssmode'] 				= 'Toggles Screen Shot mode',
    ['debug_toggle_panels'] 		= 'Toggle UI panels on/off',
}

    -- additions from GAZ UI
    keyDescriptions['toggle_repeat_build'] = 'Toggle factory repeat build'
    keyDescriptions['show_enemy_life'] = 'Show enemy life bars'
    keyDescriptions['show_network_stats'] = 'Show network stats window'
    keyDescriptions['scu_upgrade_marker'] = 'Place SCU auto-upgrade marker'
    keyDescriptions['toggle_shield'] = 'Toggle unit shield'
    keyDescriptions['toggle_weapon'] = 'Toggle unit weapon'
    keyDescriptions['toggle_jamming'] = 'Toggle unit jamming'
    keyDescriptions['toggle_intel'] = 'Toggle unit intel'
    keyDescriptions['toggle_production'] = 'Toggle unit production'
    keyDescriptions['toggle_stealth'] = 'Toggle unit stealth'
    keyDescriptions['toggle_generic'] = 'Toggle unit generic'
    keyDescriptions['toggle_special'] = 'Toggle unit special'
    keyDescriptions['toggle_cloak'] = 'Toggle unit cloak'
    keyDescriptions['toggle_all'] = 'Toggle all unit abilities'
    keyDescriptions['teleport'] = 'Teleport'
    keyDescriptions['military_overlay'] = 'Show all weapon ranges'
    keyDescriptions['intel_overlay'] = 'Show all intel ranges'
    keyDescriptions['select_all_idle_eng_onscreen'] = 'Select idle engineers on screen'
    keyDescriptions['select_all_similar_units'] = 'Select all similarly upgraded units'
    keyDescriptions['select_next_land_factory'] = 'Select next land factory'
    keyDescriptions['select_next_air_factory'] = 'Select next air factory'
    keyDescriptions['select_next_naval_factory'] = 'Select next naval factory'
    keyDescriptions['toggle_selectedinfo'] = 'Toggle single unit selected info'
    keyDescriptions['toggle_selectedrings'] = 'Toggle single unit selected rings'
    keyDescriptions['toggle_cloakjammingstealth'] = 'Toggle all counter-intelligence abilities'
    keyDescriptions['toggle_intelshield'] = 'Toggle intel and shield'
    keyDescriptions['toggle_mdf_panel'] = 'Toggle MFD panel'
    keyDescriptions['toggle_tab_display'] = 'Toggle options tab'
    keyDescriptions['zoom_pop'] = 'One-key zoom-pop'
    keyDescriptions['select_inview_idle_mex'] = 'Select onscreen idle mass extractors.'
    keyDescriptions['select_all_mex'] = 'Select all mass extractors.'
    keyDescriptions['select_nearest_idle_lt_mex'] = 'Select nearest onscreen lowest tech idle mass extractor.'

    keyDescriptions['acu_select_cg'] = 'Select ACU (control group)'
    keyDescriptions['acu_append_cg'] = 'Append ACU to selection (control group)'
    keyDescriptions['select_nearest_idle_eng_not_acu'] = 'Select nearest idle engineer (not ACU)'
    keyDescriptions['add_nearest_idle_engineers_seq'] = 'Select/Add nearest idle engineers'
    keyDescriptions['cycle_idle_factories'] = 'Cycle through idle factories'
    keyDescriptions['cycle_unit_types_in_sel'] = 'Cycle through unit types in selection (Land, Sea, Air)'

    keyDescriptions['create_template_factory'] = 'Create build template (Factory)'

    keyDescriptions['select_gunships'] = 'Select all Gunships'
    keyDescriptions['select_anti_air_fighters'] = 'Select all Air Fighters'
    keyDescriptions['select_all_tml'] = 'Select all TML'
    keyDescriptions['select_all_stationdrones'] = 'Select all Drones'
    keyDescriptions['select_all_t2_podstations'] = 'Select all T2 Engineering Podstations'
    keyDescriptions['select_all_air_exp'] = 'Select all Air Experimentals'
    keyDescriptions['select_all_antinavy_subs'] = 'Select all anti-Navy Submarines'
    keyDescriptions['select_all_land_exp'] = 'Select all Land Experimentals'
    keyDescriptions['select_all_land_indirectfire'] = 'Select all Land Indirect-Fire units'
    keyDescriptions['select_all_land_directfire'] = 'Select all Land Direct-Fire units'
    keyDescriptions['select_all_air_factories'] = 'Select all Air Factories'
    keyDescriptions['select_all_land_factories'] = 'Select all Land Factories'
    keyDescriptions['select_all_naval_factories'] = 'Select all Naval Factories'
    keyDescriptions['select_all_t1_engineers'] = 'Select all T1 Engineers'
    keyDescriptions['select_all_battleships'] = 'Select all Battleships'

    keyDescriptions['Render_SelectionSet_Names'] = 'Toggles display of group names'
    keyDescriptions['Render_Custom_Names'] = 'Toggles display of custom names'
    keyDescriptions['Render_Unit_Bars'] = 'Toggle display of names and bars of any kind'
    keyDescriptions['Render_Icons'] = 'Toggle display of Strategic Icons'
    keyDescriptions['Always_Render_Strategic_Icons'] = 'Toggle strategic icon cutoff'
    keyDescriptions['Kill_Selected_Units'] = 'Immediately kill selected units'
    keyDescriptions['Kill_All'] = 'Immediately kill all of your units'
    keyDescriptions['Show_Bandwidth_Usage'] = 'Show bandwith usage window'
    keyDescriptions['Execute_Paste_Buffer'] = '[Debug] Execute Paste Buffer'
