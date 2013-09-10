# -*- encoding : utf-8 -*-
class Operation < ActiveRecord::Base
  attr_accessible :handled, :ignored, :handled_alert, :ignored_alert
  belongs_to :operatable, :polymorphic => true

  scope :unhandled, where(:handled => false)
end
