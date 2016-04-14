# README

1. Users are pulled from the slack #crucible (default) channel. `Slack::Channel.new`
2. For each user we try and extract a `gamertag` from their Slack's `['profile']['title']`
3. With the `gamertag` we can go to `http://proxy.guardian.gg` and get a `membershipId` (per platform).
4. With the `membershipId` we can finally get the elo ratings for the user.

- There is a rake task "slack.rake" which pulls the users from slack and gets the membershipIds and stores these things in the db. (Using sqlite for now).

- A different rake task "gg.rake" goes through all the users (db) and pulls their elos from guardian.gg.

**NOTE:** In order to test this stuff make sure you have a [Slack API token](https://api.slack.com/tokens),
and supply it as an enviornmental variable called `SLACK_API_TOKEN`. E.g.

    SLACK_API_TOKEN=YOUR_TOKEN rails s


## As far as new stuff/ideas go:

Smaller stuff:

- Links to gg profiles
- Use guardian.gg font for logos to show in different game modes
- Slack avatars

Bigger things:

- Automate pulling new rankings
- Track rankings on weekly/reset basis, to make
  comparisions, trends (last week elo vs this week etc)

ASDFASDFASDF
