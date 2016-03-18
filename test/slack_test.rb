module Slack
  class UserTest < Minitest::Test
    def test_get_user
      stub_request(:get, "https://destiny-disco.slack.com/api/users.info?token=TOKEN&user=U0CV2MDJ9").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'destiny-disco.slack.com', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read(File.join("#{Rails.root}", 'test', 'fixtures', 'user.json')), :headers => {})

      user = User.new

      assert_equal 'U0CV2MDJ9', user.id
      assert_equal 'PSN: jessedarko ', user.title
      assert_equal 'Jesse', user.first_name
      assert_equal 'Atkinson', user.last_name
      assert_equal 'Jesse Atkinson', user.real_name
      assert_equal 'jessedarko', user.gamertag
    end

    def test_gamertag_parsing
      gamertags = JSON.parse(File.read(File.join("#{Rails.root}", 'test', 'fixtures', 'gamertags_test.json')))
      gamertags.each do |gamertag|
        parsed_tag = User.parse_gamertag(gamertag['title'])
        assert_equal gamertag['gamertag'], parsed_tag
      end
    end
  end
end
