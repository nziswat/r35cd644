// Simple buff for the staff. Maybe it's less of a wasted spell slot now (Convair880).
/datum/targetable/spell/summon_staff
	name = "Summon Staff of Cthulhu"
	desc = "Returns the staff to your active hand."
	icon_state = "staff"
	targeted = 0
	cooldown = 600
	requires_robes = 1

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner

		if (!M)
			return 1

		// Ability holder only checks for M.stat and wizard power, we need more than that here.
		if (M.stunned > 0 || M.weakened > 0 || M.paralysis > 0 || M.stat != 0 || M.restrained())
			boutput(M, __red("Not when you're incapacitated or restrained."))
			return 1

		M.say("KOMH HEIRE")
		//playsound(M.loc, "sound/voice/wizard/[not_done_yet].ogg", 50, 0, -1)

		var/list/staves = list()
		var/we_hold_it = 0
		for (var/obj/item/staff/cthulhu/S in world)
			if (M.mind && M.mind.key == S.wizard_key)
				if (S == M.find_in_hand(S))
					we_hold_it = 1
					continue
				if (!(S in staves))
					staves["[S.name] #[staves.len + 1] [ismob(S.loc) ? "carried by [S.loc.name]" : "at [get_area(S)]"]"] += S

		switch (staves.len)
			if (-INFINITY to 0)
				if (we_hold_it != 0)
					boutput(M, __red("You're already holding your staff."))
					return 1 // No cooldown.
				else
					boutput(M, __red("You were unable to summon your staff."))
					return 0

			if (1)
				var/obj/item/staff/cthulhu/S2
				for (var/C in staves)
					S2 = staves[C]
					break

				if (!S2 || !istype(S2))
					boutput(M, __red("You were unable to summon your staff."))
					return 0

				S2.send_staff_to_target_mob(M)

			// There could be multiple, I suppose.
			if (2 to INFINITY)
				var/t1 = input("Please select a staff to summon", "Target Selection", null, null) as null|anything in staves
				if (!t1)
					return 1

				var/obj/item/staff/cthulhu/S3 = staves[t1]

				if (!M || !ismob(M))
					return 0
				if (!S3 || !istype(S3))
					boutput(M, __red("You were unable to summon your staff."))
					return 0
				if (!isliving(M) || !M.mind || !iswizard(M))
					boutput(M, __red("You seem to have lost all magical abilities."))
					return 0
				if (M.wizard_castcheck() == 0)
					return 0 // Has own user feedback.
				if (M.stunned > 0 || M.weakened > 0 || M.paralysis > 0 || M.stat != 0 || M.restrained())
					boutput(M, __red("Not when you're incapacitated or restrained."))
					return 0
				if (M.mind.key != S3.wizard_key)
					boutput(M, __red("You were unable to summon your staff."))
					return 0

				S3.send_staff_to_target_mob(M)

		return 0