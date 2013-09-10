# -*- encoding : utf-8 -*-
class PythonTask < ActiveRecord::Base
  attr_accessible :filename, :period, :remark, :enable
end
