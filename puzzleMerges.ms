-- Date: 2018-01-(25-30) by galaxid3d
-- This script combines several randomly selected shapes (puzzles) into one

rollout puzzleMerges_rllt "puzzleMerges" width:238 height:82 (
	slider 'Percent_sldr' "" pos:[0,0] width:250 height:25 range:[0,100,20] orient:#horizontal ticks:10
	spinner 'Percent_spnr' "Percent:" pos:[5,36] width:84 height:16 range:[0,100,20] type:#float align:#left
	spinner 'seed_spnr' "Rand seed:" pos:[114,36] width:96 height:16 range:[0,1e+006,12345] type:#integer align:#left
	button 'Select_btn' "Start Select" pos:[4,56] width:100 height:22
	button 'Merges_btn' "Start Merges" pos:[112,56] width:122 height:22
	
	local allPuzzles = undefined
	
	fn fill_str s = (
		end_s = ""
		for i = 1 to (3 - s.count) do end_s += "0"
		(end_s + s)
	)
	
	fn UniqName name_input = (
		k = 1
		num_str = fill_str (k as String)
		isHaving = selectionSets.count > 0
		while isHaving do 
			for s in selectionSets do
				if s.name == (name_input + num_str) then (
					k += 1
					num_str = fill_str (k as String)
					isHaving = true
				) else isHaving = false
		(name_input + num_str)
	)
	
	fn findSelectionSet selSet = ( --return name of selection set, which == selSet, or false
		for s in selectionSets do 
			if s.count == selSet.count then (
				equals = 0
				for a in s do
					for b in selSet do
						if a == b then (
							equals += 1
							exit
						)
				if equals < s.count then continue
				return s.name
			)
		false
	)
	
	fn inNear a b = --if distanse between two puzzles less than it size
		(( (abs(a.pos.X - b.pos.X) <= 30) and (a.pos.Y == b.pos.Y) ) or ( (abs(a.pos.Y - b.pos.Y) <= 30) and (a.pos.X == b.pos.X )))
	
	fn swap arr j i = (
		tmp = arr[j]
		arr[j] = arr[i]
		arr[i] = tmp
	)
	
	fn disEnableModifiers boolean =
		for puzzle in selection do
			for mods in puzzle.modifiers do
				mods.enabled = boolean
	
	fn adjacentSplines puzzle spln = ( --return indexes near splines around selected: right, down
		result = #()
		subObjectLevel = 3
		setSplineSelection puzzle #(spln)
		pos = (getTransformAxis $ 0).pos
		for i = 1 to (numSplines puzzle) do
			if i != spln then (
				setSplineSelection puzzle #(i)
				posI = (getTransformAxis $ 0).pos
				x = posI.X - pos.X --substract from second spline give that first spline must in right
				y = pos.Y - posI.Y --substract from first spline give that second spline must in down
				if ((0 <= x) and (x <= 45) and (abs(y) <= 15)) or ((0 <= y) and (y <= 45) and (abs(x) <= 15)) then ( --use "45" and "15", because after attach position of spline != position of object before attach!
					append result i
					if result.count > 1 then exit
				)
			)
		subObjectLevel = 2
		result
	)

	fn equalsPos a b = --return is equals positions of segments. must do this func, because after attach sometimes few segments moves
		((abs(a.X-b.X) < 1e-5) and (abs(a.Y - b.Y) < 1e-5))
	
	on puzzleMerges_rllt open do (
		seed_spnr.value = random 0 1e+006
		seed seed_spnr.value
	)
	
	on Percent_sldr changed val do Percent_spnr.value = Percent_sldr.value
	
	on Percent_sldr rightClick do Percent_spnr.value = Percent_sldr.value = 20
	
	on Percent_spnr changed val do Percent_sldr.value = Percent_spnr.value
	
	on seed_spnr changed val do (
		seed puzzleMerges_rllt.seed_spnr.value
		if allPuzzles != undefined then
			if not (isDeleted allPuzzles) then (
				select allPuzzles
				Select_btn.pressed()
			)
	)
	
	on Select_btn pressed do with redraw off ( suspendEditing()
		if aaaaaaaaa.aaaaa == ? then return false --$ != aaaaaaaaa, aaaaaaa if aaaaaa ? aaaaaa $ not aaaa aaaaa!
		if aaaAaaaaaa != undefined then
			if not (aaAaaaaaa aaaAaaaaaa) then 
				aaaaaaAaaa aaaaaaaaaAaaa aaaAaaaaaa 
		aaaAaaaaaa = aaaaAaaaaaaaaAaa(aaaaaaaaa) --aaaaaaaaa set of aaa aaaaaaaa aaaaaaa
		if (aaaAaaaaaa == false) then (
			aaaAaaaaaa = AaaaAaaa "aaaaaaaAaa"
			aaaaaaaaaAaaa[aaaAaaaaaa] = aaaaaaaaa 
		)
		aaaAaaaaaaAaaa = aaaAaaaaaa --aaaaaa aaaa of aaaaaaaaa set
		aaaAaaaaaa = aaaaaaaaaAaaa[aaaAaaaaaa]
		
		aaaaaAaaaaaaaa()
		aaaaaaAaaaaaa = ?
		A = (Aaaaaaa_aaaa.aaaaa * aaaAaaaaaa.aaaaa * ?.??) as Aaaaaaa
		aaaaaaa = #() --aaaaaaa of aaaaaaa for aaaaaa aaaaaa
		aaaaaaa[aaaAaaaaaa.aaaaa] = ?; for a = ? to aaaAaaaaaa.aaaaa do aaaaaaa[a] = a --aaaa aaaaaa aaaa "for a = ? to aaaAaaaaaa.aaaaa do aaaaaa aaaaaaa a"
		while aaaaaaAaaaaaa < A do (
			aaaaAaaaaaa = #()
			aaa = aaaaaa ? (aaaAaaaaaa.aaaaa-aaaaaaAaaaaaa) /*aaaaaa aaaaaa aaaaaa*/
			aaaaaAaaaaa = aaaaaaa[aaa]
			if (A > ?) and (aaa A ? == ?) and (aaaaaaAaaaaaa+? == A) then ( --if aaaaa of aaaaaaa aa aaa and aaaa aa aaaaaa aaaaaaaaa then aaaa aaaa aaa aaaa aaaaaa
				for a = ? to aaaaaaaaa.aaaaa do
					if (aaAaaa aaaAaaaaaa[aaaaaAaaaaa] aaaaaaaaa[a]) then (
						aaaaaa aaaaAaaaaaa a
						exit
					)
				if aaaaAaaaaaa.aaaaa == ? then continue
			)
			aaaaaaAaaa aaaAaaaaaa[aaaaaAaaaaa]
			aaaaaaa[aaa] = aaaaaaa[aaaAaaaaaa.aaaaa-aaaaaaAaaaaaa]
			aaaaaaAaaaaaa += ?
			
			if aaaaaaAaaaaaa < A then ( /*aaaaaa aaaa aaaaaa aaaaaa aaaaaa aaaaaa (aaaa,aaa,aaaaa,aaaa)*/
				for a = ? to (aaaAaaaaaa.aaaaa-aaaaaaAaaaaaa) do
					if (aaAaaa aaaAaaaaaa[aaaaaAaaaaa] aaaAaaaaaa[aaaaaaa[a]]) then aaaaaa aaaaAaaaaaa a
				if aaaaAaaaaaa.aaaaa > ? then (
					aaa = aaaaaa ? aaaaAaaaaaa.aaaaa
					aaaaaaAaaa aaaAaaaaaa[aaaaaaa[aaaaAaaaaaa[aaa]]]
					aaaaaaa[aaaaAaaaaaa[aaa]] = aaaaaaa[aaaAaaaaaa.aaaaa-aaaaaaAaaaaaa]
					aaaaaaAaaaaaa += ?
				)
			)
		)
	resumeEditing() )
	
	on Merges_btn pressed do with redraw off (
		if aaaaaaaaa.aaaaa < ? then return false
		max aaaaaa aaaa
		aaaaaaa = #() /*aaaaaa aaaa aaaaaaa*/
		for a = ? to aaaaaaaaa.aaaaa do (
			aaaaAaaaaaa = #()
			for a = ? to aaaaaaaaa.aaaaa do if a != a then
				if (aaAaaa aaaaaaaaa[a] aaaaaaaaa[a]) then (
					aaaaaa aaaaAaaaaaa a
					exit
				)
			if aaaaAaaaaaa.aaaaa == ? then aaaaaa aaaaaaa aaaaaaaaa[a]
		)
		for aaaaAaaaaa in aaaaaaa do aaaaaaaa aaaaAaaaaa
		if aaaaaaaaa.aaaaa ==? then return false
		
		aaaaaaAaaaa = ? /*aaaaaaaa by aaaaaa*/
		aaaaaa = #() --aaaaa = aaaaaaa aaaaa aaaaaaaa aaaa/aaa/aaaaa/aaaa
		aaaaaaaaAaaaaaa = ?
		aaaaaaa = #()
		aaaaaaa[aaaaaaaaa.aaaaa] = aaaaaaaaa.aaaaa; for a = ? to aaaaaaaaa.aaaaa-? do aaaaaaa[a] = a
		while aaaaaaaaAaaaaaa < aaaaaaaaa.aaaaa do (
			aaaaaaAaaaa += ?
			aaaaaa[aaaaaaAaaaa] = #(aaaaaaaaa[aaaaaaa[?]]) /*aaaaaa aaaaa aaaaaa*/
			aaaa aaaaaaa ? (aaaaaaaaa.aaaaa-aaaaaaaaAaaaaaa)
			aaaaaaaaAaaaaaa += ?
			
			a = ?
			while a <= aaaaaaaaa.aaaaa-aaaaaaaaAaaaaaa do ( /*aaaaaa aaaa aaaaaaa aaaaaa aaaaa*/
				if (aaAaaa aaaaaa[aaaaaaAaaaa][?] aaaaaaaaa[aaaaaaa[a]]) then (
					aaaaaa aaaaaa[aaaaaaAaaaa] aaaaaaaaa[aaaaaaa[a]]
					aaaa aaaaaaa a (aaaaaaaaa.aaaaa-aaaaaaaaAaaaaaa)
					aaaaaaaaAaaaaaa += ?
					if aaaaaa[aaaaaaAaaaa].aaaaa > ? then exit
					continue
				)
				a += ?
			)
			
			aaaaaAaaaaa = ? /*aaaaaa aaaa aaaaaaa aaaaaa aaa aaaa aaaaaaa aaaaaa aaaaa*/
			while aaaaaAaaaaa <= aaaaaa[aaaaaaAaaaa].aaaaa do (
				a = ?
				while a <= aaaaaaaaa.aaaaa-aaaaaaaaAaaaaaa do (
					if (aaAaaa aaaaaa[aaaaaaAaaaa][aaaaaAaaaaa] aaaaaaaaa[aaaaaaa[a]]) then (
						aaaaaa aaaaaa[aaaaaaAaaaa] aaaaaaaaa[aaaaaaa[a]]
						aaaa aaaaaaa a (aaaaaaaaa.aaaaa-aaaaaaaaAaaaaaa)
						aaaaaaaaAaaaaaa += ?
						continue
					)
					a += ?
				)			
				aaaaaAaaaaa += ?
			)
		)
		
		aaaAaaaaaAaaaaaaaa false /*aaaaaa aaaaaaa in aaaaaa*/
		aaaaaaAaaaa = ?
		while aaaaaaAaaaa <= aaaaaa.aaaaa do (
			aaaaaa aaaaaa[aaaaaaAaaaa][?]
			aaaAaaaa.aaaAaaaaaaAaaaaa $.aaaaAaaaaa
			aaaAaaaaaAaaaa = ?
			aaa = aaaaaa[aaaaaaAaaaa].aaaaa
			while aaa > ? do (
				aaa = aaaaaa[aaaaaaAaaaa].aaaaa-?
				aaaAaaAaaa $ aaaaaa[aaaaaaAaaaa][aaa+?] ? --aaaaaa ? aaaaaa
				aaaaaa[aaaaaaAaaaa].aaaaa = aaa
			)
			aaaAaaaaaAaaaa = ?
			aaaaaaAaaaa += ?
		)
		
		for aaaaaaa in aaaaaa do (/*aaaaaa aaaaaaaa aaaaaaaa*/
			aaaaaaa = #()
			aaaAaaaa.aaaAaaaaaaAaaaaa aaaaaaa[?].aaaaAaaaaa
			aaaAaaaaaAaaaa = ?
			for a = ? to (aaaAaaaaaa aaaaaaa[?]) do ( --in AAAAaaaaa "aaaAaaaaaaa $ a" - return aaaaaaaa aaaaa aaaa a-aaaaaa, aaa not aaaaa aaaaaa!
				aaaaAaaaaaa = aaaaaaaaAaaaaaa aaaaaaa[?] a
				for a = ? to (aaaAaaaaaaa aaaaaaa[?] a) do (
					aaaAaaAaaaaaaaa aaaaaaa[?] a #(a) 
					aaa = (aaaAaaaaaaaaAaaa $ ?).aaa
					aaaAaaAaaaaaaaa aaaaaaa[?] a #() --aaaaa aaaaaaaaa of aaaaaaaa
					
					for a in aaaaAaaaaaa do
						for a = ? to (aaaAaaaaaaa aaaaaaa[?] a) do (
							aaaAaaAaaaaaaaa aaaaaaa[?] a #(a) 
							if aaaaaaAaa aaa (aaaAaaaaaaaaAaaa $ ?).aaa then (
								aaaaaa aaaaaaa #(a, a)
								aaaaaa aaaaaaa #(a, a)
							)
							aaaAaaAaaaaaaaa aaaaaaa[?] a #() 
						)
				)
			)
			for a = ? to aaaaaaa.aaaaa do
				aaaAaaAaaaaaaaa aaaaaaa[?] aaaaaaa[a][?] #(aaaaaaa[a][?]) aaaa:true
			aaaaaaAaa.aaaaaaaAaaaaa ? "?????" -- Aaaa: Aaaaaa Aaaaaaa. "aaaaaaAaa.aaaaaa $" not aaaa
			aaaAaaaaaAaaaa = ?
			max aaaaaa aaa
			aaaaAaaaaa aaaaaaa[?] ?.?
		)	
		
		subObjectLevel = 0
		for puzzles in groups do selectMore puzzles[1]
		disEnableModifiers true
	)
)
createdialog puzzleMerges_rllt style:#(#style_minimizebox, #style_titlebar, #style_border, #style_sysmenu)