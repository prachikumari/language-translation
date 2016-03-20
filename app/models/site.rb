# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
  resourcify #This line is added to add Site model as a resource for the Rolify gem. (contributors, volunteers)
  belongs_to :country

  validates :name, presence: true
  validates :name, uniqueness:{case_sensitive:false}

  # default order when calling the Site model
  default_scope -> { order('created_at DESC') }
end
