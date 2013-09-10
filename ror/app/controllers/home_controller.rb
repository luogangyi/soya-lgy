# -*- encoding : utf-8 -*-
#encoding: utf-8
class HomeController < ApplicationController
  def index
=begin
    infos = ThinkingSphinx.search '认证', :classes => [WeiboStatus, WikiPost]
    infos.each do |info|
      p info.class.to_s + ' ' + info.id.to_s
    end
=end
  end
end
