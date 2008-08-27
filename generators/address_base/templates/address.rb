class Address < ActiveRecord::Base
  belongs_to :user
  attr_accessor :address_type
  validates_presence_of :line1, :city, :state, :country, :zip
end
