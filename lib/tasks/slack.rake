namespace :slack do
  desc "Get members of a slack channel"
  task get_users: :environment do
    channel = Slack::Channel.new
    members = channel.members

    members.each_with_index do |member, index|
      puts "Channel Member #{index}"

      next if User.exists?(slack_id: member)

      slack_user = Slack::User.new(id: member)

      next if slack_user.gamertag.blank?

      puts "gamertag: #{slack_user.gamertag}"
      gg_user = GG::User.new(gamertag: slack_user.gamertag)
      gg_user.get_membership_ids


      gg_user.membership_ids.each do |membership_id|
        User.create!(slack_id: slack_user.id,
                     gg_id: membership_id[:id],
                     gamertag: slack_user.gamertag,
                     platform_id: membership_id[:platform_id])
      end
    end
  end
end
