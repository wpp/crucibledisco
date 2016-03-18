namespace :gg do
  desc "Get rankings of users and gametypes"
  task get_rankings: :environment do
    Slack

    User.all.each do |user|
      puts "Getting elos for #{user.gamertag}"

      gg_user = GG::User.new(gamertag: user.gamertag)
      elos = gg_user.get_elos(user.gg_id)

      elos.each do |elo|
        puts "elo: #{elo}"
        r = Rating.find_by(mode: elo['mode'], user_id: user.id)
        unless (r.present? && r.created_at > 7.days.ago)
          Rating.create!(games_played: elo['gamesPlayed'],
                         mode: elo['mode'], elo: elo['elo'],
                         user_id: user.id)
        end
      end
    end
  end
end
