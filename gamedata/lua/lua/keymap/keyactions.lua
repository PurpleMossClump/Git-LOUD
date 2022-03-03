-- describes the common set of actions that will be bound to keys
-- format is:
--  action - the console command to execute when the key is pressed
--  category - the category to list this action under in the key assign dialog
--  order - the sort order to list this action under its category

keyActions = {
    ['escape'] = {action = 'UI_Lua import("/lua/ui/uimain.lua").EscapeHandler()',
        category = 'ui', order = 1,},
    ['toggle_lifebars'] = {action = 'UI_RenderUnitBars',
        category = 'ui', order = 2,},
    ['pause'] = {action = 'UI_Lua import("/lua/ui/game/tabs.lua").TogglePause()',
        category = 'ui', order = 3,},
    ['cap_frame'] = {action = 'Dump_Frame',
        category = 'ui', order = 4,},
    ['tog_military'] = {action = 'UI_Lua import("/lua/ui/game/multifunction.lua").ToggleMilitary()',
        category = 'ui', order = 5,},
    ['tog_defense'] = {action = 'UI_Lua import("/lua/ui/game/multifunction.lua").ToggleDefense()',
        category = 'ui', order = 6,},
    ['tog_econ'] = {action = 'UI_Lua import("/lua/ui/game/multifunction.lua").ToggleEconomy()',
        category = 'ui', order = 7,},
    ['toggle_key_bindings'] = {action = 'UI_Lua import("/lua/ui/dialogs/keybindings.lua").CreateUI()',
        category = 'ui', order = 8,},
    ['toggle_score_screen'] = {action = 'UI_Lua import("/lua/ui/game/tabs.lua").ToggleScore()',
        category = 'ui', order = 9,},
    ['rename'] = {action = 'UI_ShowRenameDialog',
        category = 'ui', order = 10,},
    ['quick_save'] = {action = 'UI_Lua import("/lua/ui/game/gamemain.lua").QuickSave(LOC("<LOC QuickSave>QuickSave"))',
        category = 'ui', order = 11,},
    ['toggle_diplomacy_screen'] = {action = 'UI_Lua import("/lua/ui/game/tabs.lua").ToggleTab("diplomacy")',
        category = 'ui', order = 12,},
    ['split_screen_enable'] = {action = 'UI_Lua import("/lua/ui/game/borders.lua").SplitMapGroup(true)',
        category = 'ui', order = 13,},
    ['split_screen_disable'] = {action = 'UI_Lua import("/lua/ui/game/borders.lua").SplitMapGroup(false)',
        category = 'ui', order = 14,},
    ['switch_layout_up'] = {action = 'UI_RotateLayout +',
        category = 'ui', order = 15,},
    ['switch_layout_down'] = {action = 'UI_RotateLayout -',
        category = 'ui', order = 16,},
    ['switch_skin_down'] = {action = 'UI_RotateSkin -',
        category = 'ui', order = 17,},
    ['switch_skin_up'] = {action = 'UI_RotateSkin +',
        category = 'ui', order = 18,},
    ['ping_alert'] = {action = 'UI_Lua import("/lua/ui/game/ping.lua").DoPing("alert")',
        category = 'ui', order = 19,},
    ['ping_move'] = {action = 'UI_Lua import("/lua/ui/game/ping.lua").DoPing("move")',
        category = 'ui', order = 20,},
    ['ping_attack'] = {action = 'UI_Lua import("/lua/ui/game/ping.lua").DoPing("attack")',
        category = 'ui', order = 21,},
    ['ping_marker'] = {action = 'UI_Lua import("/lua/ui/game/ping.lua").DoPing("marker")',
        category = 'ui', order = 22,},
    ['toggle_main_menu'] = {action = 'UI_Lua import("/lua/ui/game/tabs.lua").ToggleTab("main")',
        category = 'ui', order = 23,},
    ['toggle_disconnect_screen'] = {action = 'UI_Lua import("/lua/ui/game/connectivity.lua").CreateUI()',
        category = 'ui', order = 24,},
    ['toggle_markers_screen'] = {action = 'UI_Lua import("/lua/ui/dialogs/marker_utils_view.lua").OpenWindow()',
        category = 'ui', order = 25,},
    ['show_fps'] = {action = 'UI_Lua import("/lua/debug/uidebug.lua").ShowFPS()',
        category = 'ui', order = 26,},
    ['toggle_profiler'] = {action = 'UI_Lua import("/lua/ui/game/Profiler.lua").ToggleProfiler()',
        category = 'debug', order = 27},
    ['toggle_profiler_window'] = {action = 'UI_Lua import("/lua/ui/game/Profiler.lua").OpenWindow()',
        category = 'debug', order = 28},

    ['group1'] = {action = 'UI_ApplySelectionSet 1',
        category = 'selection', order = 1,},
    ['group2'] = {action = 'UI_ApplySelectionSet 2',
        category = 'selection', order = 2,},
    ['group3'] = {action = 'UI_ApplySelectionSet 3',
        category = 'selection', order = 3,},
    ['group4'] = {action = 'UI_ApplySelectionSet 4',
        category = 'selection', order = 4,},
    ['group5'] = {action = 'UI_ApplySelectionSet 5',
        category = 'selection', order = 5,},
    ['group6'] = {action = 'UI_ApplySelectionSet 6',
        category = 'selection', order = 6,},
    ['group7'] = {action = 'UI_ApplySelectionSet 7',
        category = 'selection', order = 7,},
    ['group8'] = {action = 'UI_ApplySelectionSet 8',
        category = 'selection', order = 8,},
    ['group9'] = {action = 'UI_ApplySelectionSet 9',
        category = 'selection', order = 9,},
    ['group0'] = {action = 'UI_ApplySelectionSet 0',
        category = 'selection', order = 10,},
    ['set_group1'] = {action = 'UI_MakeSelectionSet 1',
        category = 'selection', order = 11,},
    ['set_group2'] = {action = 'UI_MakeSelectionSet 2',
        category = 'selection', order = 12,},
    ['set_group3'] = {action = 'UI_MakeSelectionSet 3',
        category = 'selection', order = 13,},
    ['set_group4'] = {action = 'UI_MakeSelectionSet 4',
        category = 'selection', order = 14,},
    ['set_group5'] = {action = 'UI_MakeSelectionSet 5',
        category = 'selection', order = 15,},
    ['set_group6'] = {action = 'UI_MakeSelectionSet 6',
        category = 'selection', order = 16,},
    ['set_group7'] = {action = 'UI_MakeSelectionSet 7',
        category = 'selection', order = 17,},
    ['set_group8'] = {action = 'UI_MakeSelectionSet 8',
        category = 'selection', order = 18,},
    ['set_group9'] = {action = 'UI_MakeSelectionSet 9',
        category = 'selection', order = 19,},
    ['set_group0'] = {action = 'UI_MakeSelectionSet 0',
        category = 'selection', order = 20,},
    ['append_group1'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(1)',
        category = 'selection', order = 21,},
    ['append_group2'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(2)',
        category = 'selection', order = 22,},
    ['append_group3'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(3)',
        category = 'selection', order = 23,},
    ['append_group4'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(4)',
        category = 'selection', order = 24,},
    ['append_group5'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(5)',
        category = 'selection', order = 25,},
    ['append_group6'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(6)',
        category = 'selection', order = 26,},
    ['append_group7'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(7)',
        category = 'selection', order = 27,},
    ['append_group8'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(8)',
        category = 'selection', order = 28,},
    ['append_group9'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(9)',
        category = 'selection', order = 29,},
    ['append_group0'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").AppendSetToSelection(0)',
        category = 'selection', order = 30,},
    ['fac_group1'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(1)',
        category = 'selection', order = 31,},
    ['fac_group2'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(2)',
        category = 'selection', order = 32,},
    ['fac_group3'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(3)',
        category = 'selection', order = 33,},
    ['fac_group4'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(4)',
        category = 'selection', order = 34,},
    ['fac_group5'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(5)',
        category = 'selection', order = 35,},
    ['fac_group6'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(6)',
        category = 'selection', order = 36,},
    ['fac_group7'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(7)',
        category = 'selection', order = 37,},
    ['fac_group8'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(8)',
        category = 'selection', order = 38,},
    ['fac_group9'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(9)',
        category = 'selection', order = 39,},
    ['fac_group0'] = {action = 'UI_Lua import("/lua/ui/game/selection.lua").FactorySelection(0)',
        category = 'selection', order = 40,},
    ['select_air'] = {action = 'UI_SelectByCategory +excludeengineers AIR MOBILE',
        category = 'selection', order = 41,},
    ['select_groundattack'] =  {action = 'UI_SelectByCategory AIR BOMBER, GROUNDATTACK',
        category = 'selection', order = 42,},
    ['select_transport'] =  {action = 'UI_SelectByCategory AIR TRANSPORTFOCUS',
        category = 'selection', order = 44,},
    ['select_naval'] = {action = 'UI_SelectByCategory +excludeengineers NAVAL MOBILE',
        category = 'selection', order = 45,},
    ['select_land'] = {action = 'UI_SelectByCategory +excludeengineers LAND MOBILE',
        category = 'selection', order = 46,},
    ['select_all_units_of_same_type'] = {action = 'UI_ExpandCurrentSelection',
        category = 'selection', order = 47,},
    ['select_engineers'] = {action = 'UI_SelectByCategory ENGINEER',
        category = 'selection', order = 48,},
    ['goto_engineer'] = {action = 'UI_SelectByCategory +nearest +idle +goto ENGINEER',
        category = 'selection', order = 49,},
    ['select_idle_engineer'] = {action = 'UI_SelectByCategory +nearest +idle ENGINEER',
        category = 'selection', order = 50,},
    ['cycle_engineers'] = {action = 'UI_Lua import("/lua/ui/game/avatars.lua").GetEngineerGeneric()',
        category = 'selection', order = 51,},
    ['goto_commander'] = {action = 'UI_SelectByCategory +nearest +goto COMMAND',
        category = 'selection', order = 52,},
    ['select_commander'] = {action = 'UI_SelectByCategory +nearest COMMAND',
        category = 'selection', order = 53,},
    ['select_all'] = {action = 'UI_SelectByCategory ALLUNITS',
        category = 'selection', order = 54,},
    ['select_all_onscreen'] = {action = 'UI_SelectByCategory +inview ALLUNITS',
        category = 'selection', order = 55,},
    ['select_all_eng_onscreen'] = {action = 'UI_SelectByCategory +inview ENGINEER',
        category = 'selection', order = 56,},
    ['select_all_factory_onscreen'] = {action = 'UI_SelectByCategory +inview FACTORY',
        category = 'selection', order = 57,},
    ['select_nearest_factory'] = {action = 'UI_SelectByCategory +nearest FACTORY',
        category = 'selection', order = 58,},
    ['select_nearest_land_factory'] = {action = 'UI_SelectByCategory +nearest LAND FACTORY',
        category = 'selection', order = 59,},
    ['select_nearest_air_factory'] = {action = 'UI_SelectByCategory +nearest AIR FACTORY',
        category = 'selection', order = 60,},
    ['select_nearest_naval_factory'] = {action = 'UI_SelectByCategory +nearest NAVAL FACTORY',
        category = 'selection', order = 61,},
    ['create_build_template'] = {action = 'UI_Lua import("/lua/ui/game/build_templates.lua").CreateBuildTemplate()',
        category = 'selection', order = 62},

    ['next_cam_position'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").RecallCameraPos()',
        category = 'camera', order = 1,},
    ['add_cam_position'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").SaveCameraPos()',
        category = 'camera', order = 2,},
    ['rem_cam_position'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").RemoveCamPos()',
        category = 'camera', order = 3,},
    ['zoom_in'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").ZoomIn(.1)',
        category = 'camera', order = 4, keyRepeat = true,},
    ['zoom_out'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").ZoomOut(.1)',
        category = 'camera', order = 5, keyRepeat = true,},
    ['zoom_in_fast'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").ZoomIn(.75)',
        category = 'camera', order = 6,},
    ['zoom_out_fast'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").ZoomOut(1)',
        category = 'camera', order = 7,},
    ['track_unit'] = {action = 'UI_TrackUnit WorldCamera',
        category = 'camera', order = 8,},
    ['track_unit_minimap'] = {action = 'UI_TrackUnit MiniMap',
        category = 'camera', order = 9,},
    ['track_unit_second_mon'] = {action = 'UI_TrackUnit CameraHead2',
        category = 'camera', order = 10,},
    ['reset_camera'] = {action = 'UI_Lua import("/lua/ui/game/zoomslider.lua").ToggleWideView()',
        category = 'camera', order = 11,},
    ['cam_free'] = {action = 'Cam_Free',
        category = 'camera', order = 13,},

    ['repair'] = {action = 'StartCommandMode order RULEUCC_Repair',
        category = 'orders', order = 1,},
    ['reclaim'] = {action = 'StartCommandMode order RULEUCC_Reclaim',
        category = 'orders', order = 2,},
    ['patrol'] = {action = 'StartCommandMode order RULEUCC_Patrol',
        category = 'orders', order = 3,},
    ['attack'] = {action = 'StartCommandMode order RULEUCC_Attack',
        category = 'orders', order = 4,},
    ['capture'] = {action = 'StartCommandMode order RULEUCC_Capture',
        category = 'orders', order = 5,},
    ['stop'] = {action = 'IssueCommand Stop',
        category = 'orders', order = 6,},
    ['dive'] = {action = 'UI_Lua import("/lua/ui/game/orders.lua").ToggleDiveOrder()',
        category = 'orders', order = 7,},
    ['ferry'] = {action = 'StartCommandMode order RULEUCC_Ferry',
        category = 'orders', order = 8,},
    ['guard'] = {action = 'StartCommandMode order RULEUCC_Guard',
        category = 'orders', order = 9,},
    ['transport'] = {action = 'StartCommandMode order RULEUCC_Transport',
        category = 'orders', order = 10,},
    ['launch_tactical'] = {action = 'StartCommandMode order RULEUCC_Tactical',
        category = 'orders', order = 11,},
    ['overcharge'] = {action = 'UI_Lua import("/lua/ui/game/orders.lua").EnterOverchargeMode()',
        category = 'orders', order = 12,},
    ['move'] = {action = 'StartCommandMode order RULEUCC_Move',
        category = 'orders', order = 13,},
    ['nuke'] = {action = 'StartCommandMode order RULEUCC_Nuke',
        category = 'orders', order = 14,},
    ['shift_repair'] = {action = 'StartCommandMode order RULEUCC_Repair',
        category = 'orders', order = 15,},
    ['shift_reclaim'] = {action = 'StartCommandMode order RULEUCC_Reclaim',
        category = 'orders', order = 16,},
    ['shift_patrol'] = {action = 'StartCommandMode order RULEUCC_Patrol',
        category = 'orders', order = 17,},
    ['shift_attack'] = {action = 'StartCommandMode order RULEUCC_Attack',
        category = 'orders', order = 18,},
    ['shift_capture'] = {action = 'StartCommandMode order RULEUCC_Capture',
        category = 'orders', order = 19,},
    ['shift_stop'] = {action = 'IssueCommand Stop',
        category = 'orders', order = 20,},
    ['shift_dive'] = {action = 'UI_Lua import("/lua/ui/game/orders.lua").ToggleDiveOrder()',
        category = 'orders', order = 21,},
    ['shift_ferry'] = {action = 'StartCommandMode order RULEUCC_Ferry',
        category = 'orders', order = 22,},
    ['shift_guard'] = {action = 'StartCommandMode order RULEUCC_Guard',
        category = 'orders', order = 23,},
    ['shift_transport'] = {action = 'StartCommandMode order RULEUCC_Transport',
        category = 'orders', order = 24,},
    ['shift_launch_tactical'] = {action = 'StartCommandMode order RULEUCC_Tactical',
        category = 'orders', order = 25,},
    ['shift_overcharge'] = {action = 'UI_Lua import("/lua/ui/game/orders.lua").EnterOverchargeMode()',
        category = 'orders', order = 26,},
    ['shift_move'] = {action = 'StartCommandMode order RULEUCC_Move',
        category = 'orders', order = 27,},
    ['shift_nuke'] = {action = 'StartCommandMode order RULEUCC_Nuke',
        category = 'orders', order = 28,},
    ['toggle_build_mode'] = {action = 'UI_Lua import("/lua/ui/game/buildmode.lua").ToggleBuildMode()',
        category = 'orders', order = 29,},
    ['pause_unit'] = {action = 'UI_Lua import("/lua/ui/game/construction.lua").ToggleUnitPause()',
        category = 'orders', order = 30,},
    ['mode'] = {action = 'UI_Lua import("/lua/ui/game/orders.lua").CycleRetaliateStateUp()',
        category = 'orders', order = 31,}, -- Cut?
    ['suicide'] = {action = 'UI_Lua import("/lua/ui/game/confirmunitdestroy.lua").ConfirmUnitDestruction()',
        category = 'orders', order = 32,},
    ['area_reclaim'] = {action = 'UI_Lua import("/lua/ui/game/gamemain.lua").AreaReclaim()', 
        category = 'orders', order = 33, },
    ['spreadattack'] = {action = 'UI_Lua import("/lua/spreadattack.lua").SpreadAttack()',
        category = 'orders', order = 34, },

    ['decrease_game_speed'] = {action = 'UI_Lua import("/lua/ui/uimain.lua").DecreaseGameSpeed()',
        category = 'game', order = 1,},
    ['increase_game_speed'] = {action = 'UI_Lua import("/lua/ui/uimain.lua").IncreaseGameSpeed()',
        category = 'game', order = 2,},
    ['reset_game_speed'] = {action = 'WLD_ResetSimRate',
        category = 'game', order = 3,},

    ['chat_page_up'] = {action = 'UI_Lua import("/lua/ui/game/chat.lua").ChatPageUp(10)',
        category = 'chat', order = 1,},
    ['chat_page_down'] = {action = 'UI_Lua import("/lua/ui/game/chat.lua").ChatPageDown(10)',
        category = 'chat', order = 2,},
    ['chat_line_up'] = {action = 'UI_Lua import("/lua/ui/game/chat.lua").ChatPageUp(1)',
        category = 'chat', order = 3,},
    ['chat_line_down'] = {action = 'UI_Lua import("/lua/ui/game/chat.lua").ChatPageDown(1)',
        category = 'chat', order = 4,},
}

debugKeyActions = {
    ['debug_navpath'] = {action = 'dbg navpath',
        category = 'debug', order = 1,},
    ['debug_create_unit'] = {action = 'PopupCreateUnitMenu',
        category = 'debug', order = 1,},
    ['debug_teleport'] = {action = 'TeleportSelectedUnits',
        category = 'debug', order = 1,},
    ['debug_run_opponent_AI'] = {action = 'AI_RunOpponentAI',
        category = 'debug', order = 1,},
    ['debug_blingbling'] = {action = 'BlingBling',
        category = 'debug', order = 1,},
    ['debug_destroy_units'] = {action = 'DestroySelectedUnits',
        category = 'debug', order = 1,},
    ['debug_graphics_fidelity_0'] = {action = 'graphics_Fidelity 0',
        category = 'debug', order = 1,},
    ['debug_graphics_fidelity_2'] = {action = 'graphics_Fidelity 2',
        category = 'debug', order = 1,},
    ['debug_scenario_method_f3'] = {action = 'ScenarioMethod OnF3',
        category = 'debug', order = 1,},
    ['debug_scenario_method_shift_f3'] = {action = 'ScenarioMethod OnShiftF3',
        category = 'debug', order = 1,},
    ['debug_scenario_method_ctrl_f3'] = {action = 'ScenarioMethod OnCtrlF3',
        category = 'debug', order = 1,},
    ['debug_scenario_method_shift_f4'] = {action = 'ScenarioMethod OnShiftF4',
        category = 'debug', order = 1,},
    ['debug_scenario_method_ctrl_f4'] = {action = 'ScenarioMethod OnCtrlF4',
        category = 'debug', order = 1,},
    ['debug_scenario_method_ctrl_alt_f3'] = {action = 'ScenarioMethod OnCtrlAltF4',
        category = 'debug', order = 1,},
    ['debug_scenario_method_f4'] = {action = 'ScenarioMethod OnF4',
        category = 'debug', order = 1,},
    ['debug_scenario_method_f5'] = {action = 'ScenarioMethod OnF5',
        category = 'debug', order = 1,},
    ['debug_scenario_method_shift_f5'] = {action = 'ScenarioMethod OnShiftF5',
        category = 'debug', order = 1,},
    ['debug_scenario_method_ctrl_f5'] = {action = 'ScenarioMethod OnCtrlF5',
        category = 'debug', order = 1,},
    ['debug_scenario_method_ctrl_alt_f5'] = {action = 'ScenarioMethod OnCtrlAltF5',
        category = 'debug', order = 1,},
    ['debug_campaign_instawin'] = {action = 'ui_lua import("/lua/ui/campaign/campaignmanager.lua").InstaWin()',
        category = 'debug', order = 1,},
    ['debug_create_entity'] = {action = 'SC_CreateEntityDialog',
        category = 'debug', order = 1,},
    ['debug_show_stats'] = {action = 'ShowStats',
        category = 'debug', order = 1,},
    ['debug_show_army_stats'] = {action = 'ShowArmyStats',
        category = 'debug', order = 1,},
    ['debug_toggle_log_window'] = {action = 'WIN_ToggleLogDialog',
        category = 'debug', order = 1,},
    ['debug_open_lua_debugger'] = {action = 'SC_LuaDebugger',
        category = 'debug', order = 1,},
    ['debug_show_frame_stats'] = {action = 'ShowStats frame',
        category = 'debug', order = 1,},
    ['debug_render_wireframe'] = {action = 'ren_ShowWireframe tog',
        category = 'debug', order = 1,},
    ['debug_weapons'] = {action = 'dbg weapons',
        category = 'debug', order = 1,},
    ['debug_grid'] = {action = 'dbg grid',
        category = 'debug', order = 1,},
    ['debug_show_focus_ui_control'] = {action = 'UI_ShowControlUnderMouse tog',
        category = 'debug', order = 1,},
    ['debug_dump_focus_ui_control'] = {action = 'UI_DumpControlsUnderCursor',
        category = 'debug', order = 1,},
    ['debug_dump_ui_controls'] = {action = 'UI_DumpControls',
        category = 'debug', order = 1,},
    ['debug_skeletons'] = {action = 'Ren_Showskeletons',
        category = 'debug', order = 1,},
    ['debug_bones'] = {action = 'Ren_ShowBoneNames',
        category = 'debug', order = 1,},
    ['debug_redo_console_command'] = {action = 'CON_ExecuteLastCommand',
        category = 'debug', order = 1,},
    ['debug_copy_units'] = {action = 'CopySelectedUnitsToClipboard',
        category = 'debug', order = 1,},
    ['debug_paste_units'] = {action = 'ExecutePasteBuffer',
        category = 'debug', order = 1,},
    ['debug_nodamage'] = {action = 'Nodamage',
        category = 'debug', order = 1,},
    ['debug_show_emmitter_window'] = {action = 'EFX_CreateEmitterWindow',
        category = 'debug', order = 1,},
    ['debug_sally_shears'] = {action = 'SallyShears',
        category = 'debug', order = 1,},
    ['debug_collision'] = {action = 'dbg Collision',
        category = 'debug', order = 1,},
    ['debug_pause_single_step'] = {action = 'WLD_SingleStep',
        category = 'game', order = 1,},
    ['debug_restart_session'] = {action = 'UI_Lua RestartSession()',
        category = 'debug', order = 1,},
    ['debug_toggle_panels'] = {action = 'UI_ToggleGamePanels',
        category = 'debug', order = 2,},
}