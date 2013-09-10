# -*- encoding : utf-8 -*-
module ShowHelper
	def sentiment_color(sid)
		if sid == 1
			resualt = "success"
		elsif sid ==2
			resualt = "important"
		else 
			resualt = "danger"
		end
		resualt
	end
end
