# -*- encoding : utf-8 -*-
class Hot < ActiveRecord::Base
  attr_accessible  :name ,:any_keywords, :has_keywords, :without_keywords ,:start_at , :end_at
end
