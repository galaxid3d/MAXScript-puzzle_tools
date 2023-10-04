-- Date: 2017-11-(25-26)+2019-10-10+2021-12-03 by galaxid3d
-- This script extrude puzzles by random height

rollout puzzleExtrude_rllt "puzzleExtrude" width:230 height:124 (
	GroupBox 'Extrude_grp' "Extrude" pos:[4,2] width:110 height:60
	spinner 'min_spnr' "min:  " pos:[10,20] width:89 height:16 range:[0,1e+006,1] align:#left
	spinner 'max_spnr' "max: " pos:[10,40] width:88 height:16 range:[0,1e+006,10] align:#left
	spinner 'seed_spnr' "seed: " pos:[8,65] width:94 height:16 range:[0,1e+008,12345] type:#integer align:#left
	checkbox 'isUpdate_chk' "Automatic Update" pos:[5,84] width:107 height:16 checked:true
	button 'Update_btn' "Update" pos:[5,102] width:107 height:18 enabled:false
	checkbox 'isInstansed_chk' "Instansed Bevel" pos:[118,7] width:107 height:16 checked:false
	button 'Extrude_btn' "Start Extrude" pos:[118,25] width:107 height:70
	button 'Clear_btn' "Clear Extrude" pos:[118,102] width:107 height:18
	
	fn deleteModifiers isBevel =
		for puzzle in selection do (
			deleteModifier puzzle (puzzle.modifiers["UVW Map"])
			deleteModifier puzzle (puzzle.modifiers[#Smooth])
			deleteModifier puzzle (puzzle.modifiers[#Bevel])
			if isBevel then (newModifier = Bevel(); newModifier.Level_1_Height = 2; newModifier.Use_Level_2 = 1; newModifier.Level_2_Height = 1; newModifier.Level_2_Outline = -0.5; addModifier puzzle newModifier ui:on)
		)
	
	fn extrudeStart =
		for puzzle in selection do
			puzzle.modifiers[#Bevel].Level_1_Height = random min_spnr.value max_spnr.value
	
	on puzzleExtrude_rllt open do (
		seed_spnr.value = random 0 1e+006
		seed seed_spnr.value
	)
	
	on Extrude_btn pressed do with redraw off ( suspendEditing()
		if selection.count > 0 then (
			if isInstansed_chk.checked then ( --if add Instansed Bevel for Selected (use for tiers height)
				deleteModifiers false
				newModifier = Bevel(); newModifier.Level_1_Height = random min_spnr.value max_spnr.value; newModifier.Use_Level_2 = 1; newModifier.Level_2_Height = 1; newModifier.Level_2_Outline = -0.5
				addModifier selection newModifier
			) else (
				deleteModifiers true
				extrudeStart()
			)
			newModifier = Smooth(); newModifier.autoSmooth = true; newModifier.Threshold = 30
			addModifier selection newModifier ui:on
			addModifier selection (Uvwmap()) ui:on
		)
	resumeEditing() )
	
	on seed_spnr changed val do with redraw off ( suspendEditing()
		seed seed_spnr.value
		extrudeStart()
	resumeEditing() )
	
	on Clear_btn pressed do with redraw off ( suspendEditing()
		if selection.count > 0 then (
			deleteModifiers false
			max modify mode --instead ui:on for each modifier
			newModifier = Bevel(); newModifier.Level_1_Height = 2; newModifier.Use_Level_2 = 1; newModifier.Level_2_Height = 1; newModifier.Level_2_Outline = -0.5
			addModifier selection newModifier
			resumeEditing()
			newModifier = Smooth(); newModifier.autoSmooth = true; newModifier.Threshold = 30
			modPanel.addModToSelection newModifier
			modPanel.addModToSelection (Uvwmap())
		)
	resumeEditing() )
	
	on min_spnr changed val do if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	
	on max_spnr changed val do if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	
	on Update_btn pressed do seed_spnr.changed seed_spnr.value
	
	on isUpdate_chk changed state do Update_btn.enabled = not isUpdate_chk.checked
)
createdialog puzzleExtrude_rllt style:#(#style_minimizebox, #style_titlebar, #style_border, #style_sysmenu)