-- Date: 2017-07-15+2019-09-14(newButtons)+2019-10-10(Update)+2020-04-09(🔒) by galaxid
-- This sript create offsets (Z axis) and rotate (X/Y axis) selected objects (puzzles)

rollout puzzleOffsets_rllt "puzzleOffsets" width:277 height:207 (
	GroupBox 'X_Angle_grp' "X Angle Offset" pos:[4,2] width:133 height:80
	checkbox 'isX_Angle_chk' "Offset X Angle" pos:[10,20] width:103 height:16 checked:true
	checkButton 'X_Lock_chkBtn' "🔓" pos:[115,22] width:18 height:16 tooltip:"When '🔓':\n        min ≠ max\nWhen '🔒':\n        min = max" --new feature 2020-04-10 (🔒)
	spinner 'X_max_spnr' "X max:" pos:[10,40] width:86 height:16 range:[-360,360,2] align:#left
	checkButton 'X_mirror_chkBtn' "+" pos:[115,40] width:18 height:16 tooltip:"Wnen '+':\n        range = [min; max]\nWhen '-':\n        range = [-max; max]"
	spinner 'X_min_spnr' "X min: " pos:[10,60] width:86 height:16 range:[-360,360,-2] align:#left
	checkButton 'X_abs_chkBtn' "▢" pos:[115,60] width:18 height:16 tooltip:"Wnen '▢':\n        range = [min; max]\nWhen '▣':\n        range = [-|max|; -|min|] ⋃ [|min|; |max|]"
	GroupBox 'Y_Angle_grp' "Y Angle Offset" pos:[140,2] width:133 height:80
	checkbox 'isY_Angle_chk' "Offset Y Angle" pos:[146,20] width:103 height:16 checked:true
	checkButton 'Y_Lock_chkBtn' "🔓" pos:[251,22] width:18 height:16 tooltip:"When '🔓':\n        min ≠ max\nWhen '🔒':\n        min = max" --new feature 2020-04-10 (🔒)
	spinner 'Y_max_spnr' "Y max:" pos:[146,40] width:86 height:16 range:[-360,360,2] align:#left
	checkButton 'Y_mirror_chkBtn' "+" pos:[251,40] width:18 height:16 tooltip:"Wnen '+':\n        range = [min; max]\nWhen '-':\n        range = [-max; max]"
	spinner 'Y_min_spnr' "Y min: " pos:[146,60] width:86 height:16 range:[-360,360,1] align:#left
	checkButton 'Y_abs_chkBtn' "▢" pos:[251,60] width:18 height:16 checked:true tooltip:"Wnen '▢':\n        range = [min; max]\nWhen '▣':\n        range = [-|max|; -|min|] ⋃ [|min|; |max|]"
	checkbox 'isUpdate_chk' "Automatically Update" pos:[4,166] width:133 height:16 checked:true
	button 'Update_btn' "Update" pos:[4,184] width:133 height:18
	GroupBox 'Z_Pos_grp' "Z Postion Offset" pos:[4,83] width:133 height:80
	checkbox 'isZ_Pos_chk' "Offset Z Position" pos:[9,101] width:103 height:16 checked:true
	checkButton 'Z_Lock_chkBtn' "🔓" pos:[115,103] width:18 height:16 tooltip:"When '🔓':\n        min ≠ max\nWhen '🔒':\n        min = max" --new feature 2020-04-10 (🔒)
	spinner 'Z_max_spnr' "Z max:" pos:[10,121] width:86 height:16 range:[-999,999,1] align:#left
	checkButton 'Z_mirror_chkBtn' "+" pos:[115,121] width:18 height:16 checked:true tooltip:"Wnen '+':\n        range = [min; max]\nWhen '-':\n        range = [-max; max]"
	spinner 'Z_min_spnr' "Z min: " pos:[10,141] width:86 height:16 range:[-999,999,-1] align:#left
	checkButton 'Z_abs_chkBtn' "▢" pos:[115,141] width:18 height:16 tooltip:"Wnen '▢':\n        range = [min; max]\nWhen '▣':\n        range = [-|max|; -|min|] ⋃ [|min|; |max|]"
	spinner 'seed_spnr' "Rand seed:" pos:[146,86] width:98 height:16 range:[0,1e+007,12345] type:#integer align:#left
	label 'Mode_lbl' "Mode: " pos:[146,106] width:30 height:16 align:#left
	radioButtons 'Mode_rBtn' "" pos:[186,106] columns:2 labels: #("Add ", "Set ")
	button 'Offset_btn' "Start Offsets" pos:[140,124] width:133 height:54
	button 'Clear_btn' "Clear Offsets" pos:[140,184] width:133 height:18
	
	local last_seed = undefined
	
	fn randomRange minValue maxValue isLock isMirror isAbs =
		if isLock then (
			if isMirror then
				if (random 0.0 1.0) < 0.5 then -maxValue
				else maxValue
			else if (random 0.0 1.0) < 2 then maxValue --"if (random 0.0 1.0) < 2 then" need because count of number calls function random
		) else (
			if isMirror then (if (random 0.0 1.0) < 2 then (random -maxValue maxValue))
			else if isAbs then (
				if (random 0.0 1.0) < 0.5 then (-random (abs(minValue)) (abs(maxValue))) --random 0.0 1.0 more accurate than random 0 1
				else (random (abs(minValue)) (abs(maxValue)))
			) else if (random 0.0 1.0) < 2 then (random minValue maxValue)
		)
	
	fn offsetsStart sign isSet = (
		for puzzle in selection do (
			tmp = randomRange X_min_spnr.value X_max_spnr.value X_lock_chkBtn.checked X_mirror_chkBtn.checked X_abs_chkBtn.checked
			if isX_Angle_chk.checked then
				if isSet then puzzle.rotation.x_rotation = tmp
				else puzzle.rotation.x_rotation += sign * tmp
			tmp = randomRange Y_min_spnr.value Y_max_spnr.value Y_lock_chkBtn.checked Y_mirror_chkBtn.checked Y_abs_chkBtn.checked
			if isY_Angle_chk.checked then
				if isSet then puzzle.rotation.y_rotation = tmp
				else puzzle.rotation.y_rotation += sign * tmp
			tmp = randomRange Z_min_spnr.value Z_max_spnr.value Z_lock_chkBtn.checked Z_mirror_chkBtn.checked Z_abs_chkBtn.checked
			if isZ_Pos_chk.checked then
				if isSet then puzzle.Pos.Z = tmp
				else puzzle.Pos.Z += sign * tmp
		)
	)
	
	fn chkClick is_chk min_spnr max_spnr lock_btn mirror_btn abs_btn = (
		max_spnr.enabled = mirror_btn.enabled = lock_btn.enabled = is_chk.checked
		min_spnr.enabled = abs_btn.enabled = is_chk.checked and not lock_btn.checked and not mirror_btn.checked
		if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	)
		
	fn lock_btnClick is_chk min_spnr lock_btn mirror_btn abs_btn = (
		if lock_btn.checked then (
			lock_btn.caption = "🔒"
			min_spnr.enabled = abs_btn.enabled = false
			mirror_btn.tooltip = "Wnen '+':\n        range = [max]\nWhen '-':\n        range = [-max] ⋃ [max]"
		) else (
			lock_btn.caption = "🔓"
			min_spnr.enabled = abs_btn.enabled = not mirror_btn.checked and is_chk.checked and is_chk.enabled
			mirror_btn.tooltip = "Wnen '+':\n        range = [min; max]\nWhen '-':\n        range = [-max; max]"
		)
		if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	)
	
	fn mirror_btnClick is_chk min_spnr lock_btn mirror_btn abs_btn = (
		if mirror_btn.checked then (
			mirror_btn.caption = "-"
			min_spnr.enabled = abs_btn.enabled = false
		) else (
			mirror_btn.caption = "+"
			min_spnr.enabled = abs_btn.enabled = not lock_btn.checked and is_chk.checked
		)
		if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	)
	
	fn abs_btnClick abs_btn = (
		if abs_btn.checked then abs_btn.caption = "▣" else abs_btn.caption = "▢"
		if isUpdate_chk.checked then seed_spnr.changed seed_spnr.value
	)
	
	on puzzleOffsets_rllt open do (
		seed_spnr.value = random 0 1e+006
		last_seed = seed_spnr.value
		seed seed_spnr.value
		Z_mirror_chkBtn.changed true
		Mode_rBtn.changed 1
	)
	
	on Mode_rBtn changed stat do (
		isUpdate_chk.enabled = Update_btn.enabled = Mode_rBtn.state == 2
		if Update_btn.enabled then Update_btn.enabled = not isUpdate_chk.checked
	)
	
	on Offset_btn pressed do with redraw off ( suspendEditing()
		last_seed = seed_spnr.value	
		seed last_seed	
		offsetsStart 1 (Mode_rBtn.state == 2)
	resumeEditing() )
	
	on seed_spnr changed val do with redraw off ( suspendEditing()
		if last_seed == undefined then last_seed = puzzleOffsets_rllt.seed_spnr.value
		seed last_seed
		if Mode_rBtn.state == 1 then offsetsStart -1 false --without Set Mode Update and AutoUpdate not working
		Offset_btn.pressed()
	resumeEditing() )
	
	on Clear_btn pressed do with redraw off ( suspendEditing()
		for puzzle in selection do
			puzzle.rotation.x_rotation = puzzle.rotation.y_rotation = puzzle.Pos.Z = 0
	resumeEditing() )
	
	on isX_Angle_chk changed state do chkClick isX_Angle_chk X_min_spnr X_max_spnr X_lock_chkBtn X_mirror_chkBtn X_abs_chkBtn
	
	on X_lock_chkBtn changed state do lock_btnClick isX_Angle_chk X_min_spnr X_lock_chkBtn X_mirror_chkBtn X_abs_chkBtn
	
	on X_mirror_chkBtn changed state do mirror_btnClick isX_Angle_chk X_min_spnr X_lock_chkBtn X_mirror_chkBtn X_abs_chkBtn
	
	on X_abs_chkBtn changed state do abs_btnClick X_abs_chkBtn
	
	on isY_Angle_chk changed state do chkClick isY_Angle_chk Y_min_spnr Y_max_spnr Y_lock_chkBtn Y_mirror_chkBtn Y_abs_chkBtn
	
	on Y_lock_chkBtn changed state do lock_btnClick isY_Angle_chk Y_min_spnr Y_lock_chkBtn Y_mirror_chkBtn Y_abs_chkBtn
	
	on Y_mirror_chkBtn changed state do mirror_btnClick isY_Angle_chk Y_min_spnr Y_lock_chkBtn Y_mirror_chkBtn Y_abs_chkBtn
	
	on Y_abs_chkBtn changed state do abs_btnClick Y_abs_chkBtn
	
	on isZ_Pos_chk changed state do chkClick isZ_Pos_chk Z_min_spnr Z_max_spnr Z_lock_chkBtn Z_mirror_chkBtn Z_abs_chkBtn
	
	on Z_lock_chkBtn changed state do lock_btnClick isZ_Pos_chk Z_min_spnr Z_lock_chkBtn Z_mirror_chkBtn Z_abs_chkBtn
	
	on Z_mirror_chkBtn changed state do mirror_btnClick isZ_Pos_chk Z_min_spnr Z_lock_chkBtn Z_mirror_chkBtn Z_abs_chkBtn
	
	on Z_abs_chkBtn changed state do abs_btnClick Z_abs_chkBtn
	
	on X_max_spnr changed val do if isUpdate_chk.checked and isUpdate_chk.enabled then seed_spnr.changed seed_spnr.value
	
	on X_min_spnr changed val do if isUpdate_chk.checked and isUpdate_chk.enabled then seed_spnr.changed seed_spnr.value
	
	on Y_max_spnr changed val do if isUpdate_chk.checked and isUpdate_chk.enabled then seed_spnr.changed seed_spnr.value
	
	on Y_min_spnr changed val do if isUpdate_chk.checked and isUpdate_chk.enabled then seed_spnr.changed seed_spnr.value
	
	on Z_max_spnr changed val do if isUpdate_chk.checked and isUpdate_chk.enabled then seed_spnr.changed seed_spnr.value
	
	on Z_min_spnr changed val do if isUpdate_chk.checked and isUpdate_chk.enabled then seed_spnr.changed seed_spnr.value
	
	on isUpdate_chk changed state do Update_btn.enabled = not isUpdate_chk.checked
	
	on Update_btn pressed do seed_spnr.changed seed_spnr.value
)
createdialog puzzleOffsets_rllt style:#(#style_minimizebox, #style_titlebar, #style_border, #style_sysmenu)