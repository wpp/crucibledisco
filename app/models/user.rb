class User < ActiveRecord::Base
  %i(slack_id gg_id platform_id).each do |att|
    validates att, presence: true
  end

  validates :gamertag, presence: true, uniqueness:{ scope: [:gamertag, :platform_id] }
end
