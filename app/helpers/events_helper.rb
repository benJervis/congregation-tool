module EventsHelper
	def time_string(event)
		if event.event_date.in_time_zone('Sydney') < Time.now.in_time_zone('Sydney')
			if ((Time.now.in_time_zone('Sydney') - event.event_date.in_time_zone('Sydney')) / 1.day) < 1
				time_string = "started #{distance_of_time_in_words(Time.now.in_time_zone('Sydney'), event.event_date.in_time_zone('Sydney'))} ago"
			else
				time_string = "#{distance_of_time_in_words(Time.now.in_time_zone('Sydney'), event.event_date.in_time_zone('Sydney'))} ago"
			end
		else
			time_string = "#{distance_of_time_in_words(Time.now.in_time_zone('Sydney'), event.event_date.in_time_zone('Sydney'))} from now"
		end

		time_string
	end
end
