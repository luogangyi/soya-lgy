# -*- encoding : utf-8 -*-
module SearchHelper
	def sub_query_str(query)
		if query.length>10
			query[0,10]+"..."
		else
			query
		end
	end
end
