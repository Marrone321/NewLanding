/mob/living/brain/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/living/brain/treat_message(message)
	message = capitalize(message)
	return message
