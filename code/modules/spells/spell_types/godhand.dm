/obj/item/melee/touch_attack
	name = "\improper outstretched hand"
	desc = "High Five?"
	var/catchphrase = "High Five!"
	var/on_use_sound = null
	var/obj/effect/proc_holder/spell/targeted/touch/attached_spell
	icon = 'icons/obj/items_and_weapons.dmi'
	inhand_icon = 'icons/mob/inhands/misc/touchspell_inhand.dmi'
	icon_state = "latexballon"
	inhand_icon_state = null
	item_flags = NEEDS_PERMIT | ABSTRACT | DROPDEL
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	throwforce = 0
	throw_range = 0
	throw_speed = 0
	var/charges = 1

/obj/item/melee/touch_attack/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/melee/touch_attack/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, SPAN_WARNING("You can't reach out!"))
		return
	..()

/obj/item/melee/touch_attack/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(catchphrase)
		user.say(catchphrase, forced = "spell")
	playsound(get_turf(user), on_use_sound,50,TRUE)
	charges--
	if(charges <= 0)
		qdel(src)

/obj/item/melee/touch_attack/Destroy()
	if(attached_spell)
		attached_spell.on_hand_destroy(src)
	return ..()

/obj/item/melee/touch_attack/disintegrate
	name = "\improper smiting touch"
	desc = "This hand of mine glows with an awesome power!"
	catchphrase = "EI NATH!!"
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "disintegrate"
	inhand_icon_state = "disintegrate"

/obj/item/melee/touch_attack/disintegrate/afterattack(mob/living/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !istype(target) || !iscarbon(user) || !(user.mobility_flags & MOBILITY_USE)) //exploding after touching yourself would be bad
		return
	if(!user.can_speak_vocal())
		to_chat(user, SPAN_WARNING("You can't get the words out!"))
		return
	do_sparks(4, FALSE, target.loc)
	for(var/mob/living/L in view(src, 7))
		if(L != user)
			L.flash_act(affect_silicon = FALSE)
	var/atom/A = target.anti_magic_check()
	if(A)
		if(isitem(A))
			target.visible_message(SPAN_WARNING("[target]'s [A] glows brightly as it wards off the spell!"))
		user.visible_message(SPAN_WARNING("The feedback blows [user]'s arm off!"),SPAN_USERDANGER("The spell bounces from [target]'s skin back into your arm!"))
		user.flash_act()
		var/obj/item/bodypart/part = user.get_holding_bodypart_of_item(src)
		if(part)
			part.dismember()
		return ..()
	target.gib()
	return ..()
