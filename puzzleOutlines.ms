-- Date: 2018-07-(28-30)+2019-10-10 by galaxid3d
-- This script create outline in selected shapes (puzzles)

rollout puzzleOutlines_rllt "puzzleOutlines" width:240 height:124 (
	GroupBox 'Outline_grp' "Outline" pos:[4,2] width:110 height:96
	spinner 'min_spnr' "min:  " pos:[10,20] width:89 height:16 range:[-1e+006,1e+006,-1.2] align:#left
	spinner 'max_spnr' "max: " pos:[10,40] width:88 height:16 range:[-1e+006,1e+006,-0.6] align:#left
	spinner 'bevel_spnr' "Bevel:" pos:[8,60] width:74 height:16 range:[-1e+006,1e+006,-0.1] align:#left
	checkbox 'isBevelOverride_chk' "" pos:[98,60] width:10 height:16 checked:true tooltip:"Override for Bevel Level 2 Outline"
	checkbox 'isModifiersForAll_chk' "Modifiers for All" pos:[8,80] width:102 height:16 checked:true tooltip:"For all selected puzzles apply one instanse modifiers (it's faster, but if Bevel different for other it make equal)"
	spinner 'seed_spnr' "seed: " pos:[8,103] width:94 height:16 range:[0,1e+008,12345] type:#integer align:#left
	button 'outline_btn' "Create Outlines" pos:[118,4] width:117 height:54
	checkbox 'isUpdate_chk' "Automatic Update" pos:[118,62] width:117 height:16 checked:true
	button 'Update_btn' "Update" pos:[118,80] width:117 height:18 enabled:false
	button 'delete_btn' "Delete Outlines" pos:[118,102] width:117 height:18
	
	fn outlineCreate = (
		objSelect = selection as array /*need because selection is empty after first iteration*/
		for puzzle in objSelect do (
			modifiersArr = #(puzzle.modifiers[3], puzzle.modifiers[2], puzzle.modifiers[1]) --#Bevel, #Smooth, "UVW Map"
			for i = 3 to 1 by -1 do deleteModifier puzzle modifiersArr[i] /*need because applyOffset work only EditSpline*/
			applyOffset puzzle (random min_spnr.value max_spnr.value)
			for i in modifiersArr do addModifier puzzle i
			if isBevelOverride_chk.checked then puzzle.modifiers[3].Level_2_Outline = bevel_spnr.value
		)
		select objSelect
	)
	
	fn outlineCreateAll = (
		objSelect = selection as array /*need because selection is empty after first iteration*/
		modifiersArr = #(objSelect[1].modifiers[3], objSelect[1].modifiers[2], objSelect[1].modifiers[1])
		for i = 3 to 1 by -1 do deleteModifier objSelect modifiersArr[i] /*need because applyOffset work only EditSpline*/
		for puzzle in objSelect do applyOffset puzzle (random min_spnr.value max_spnr.value)
		select objSelect
		resumeEditing()
		for i in modifiersArr do modPanel.addModToSelection i
		if isBevelOverride_chk.checked then objSelect[1].modifiers[3].Level_2_Outline = bevel_spnr.value
	)
	
	fn outlineDelete = (
		max modify mode
		objSelect = selection as array
		for puzzle in objSelect do (
			modPanel.setCurrentObject puzzle.baseObject
			subObjectLevel = 3
			if numSplines puzzle > 1 then (
				setSplineSelection puzzle #(2)
				actionMan.executeAction 0 "40020" -- Edit: Delete Objects. "splineOps.delete $" not work
			)
			subObjectLevel = 0
		)
		select objSelect
	)
	
	on puzzleOutlines_rllt open do (
		seed_spnr.value = random 0 1e+006
		seed seed_spnr.value
	)
	
	on outline_btn pressed do with redraw off ( suspendEditing()
		if selection.count > 0 then (
			max modify mode
			if isModifiersForAll_chk.checked then outlineCreateAll()
			else outlineCreate()
		)
	resumeEditing() )
	
	on seed_spnr changed val do with redraw off (
		seed seed_spnr.value
		outlineDelete()
		outline_btn.pressed()
	)
	
	on delete_btn pressed do with redraw off
		outlineDelete()
	
	on isBevelOverride_chk changed state do bevel_spnr.enabled = isBevelOverride_chk.checked
	
	on min_spnr changed val do if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	
	on max_spnr changed val do if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	
	on bevel_spnr changed val do if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	
	on Update_btn pressed do seed_spnr.changed seed_spnr.value
	
	on isUpdate_chk changed state do Update_btn.enabled = not isUpdate_chk.checked
)
createdialog puzzleOutlines_rllt style:#(#style_minimizebox, #style_titlebar, #style_border, #style_sysmenu)