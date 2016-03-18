class Rating < ActiveRecord::Base
  belongs_to :user
  %i(mode games_played elo user_id).each do |att|
    validates att, presence: true
  end
end
