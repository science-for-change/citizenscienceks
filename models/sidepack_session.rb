class SidepackSession < ActiveRecord::Base
  belongs_to :user, class_name: :account
end
