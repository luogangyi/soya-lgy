module SystemSettingHelper
	def setSettingStatus(status)
		if status
			SiteInfo..update_all(['value=?',1],:key =>'HASSETTING')
		end
	end
end
