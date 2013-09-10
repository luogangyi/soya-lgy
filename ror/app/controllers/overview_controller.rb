# -*- encoding : utf-8 -*-
class OverviewController < ApplicationController
  	def index
  		if not has_setting?
        redirect_to  "/system_setting/overall_config"
      end
  	end


  	def update_keywords
  		exist_keywords=[]
  		Keyword.all.each do |k|
  			exist_keywords.push(k.str)
  		end

  		new_keywords=params[:keywords].split(/,/)

  		del_keywords = exist_keywords - new_keywords
  		add_keywords = new_keywords - exist_keywords
  		enable_keywords =  exist_keywords & new_keywords


  		add_keywords.each do |keyword|
  			Keyword.where(
  				:str => keyword
  				).first_or_create
  		end

  		del_keywords.each do |keyword|
  			Keyword.where(
  				:str => keyword
  				).first.update_attribute("enable" , false)
  		end

  		enable_keywords.each do |keyword|
  			Keyword.where(
  				:str => keyword
  				).first.update_attribute("enable" , true)
  		end

  		render :text => "OK"
  	end

  def has_setting?
    SiteInfo.where(:key => "HASSETTING").first.value.to_i == 1
  end
end
