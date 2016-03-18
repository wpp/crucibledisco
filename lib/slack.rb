require 'net/http'
require 'json'
require 'byebug'

module Slack
  ENDPOINT = 'https://destiny-disco.slack.com/api'
  TOKEN    = ENV['SLACK_API_TOKEN']

  module HTTP
    def get(*args)
      path, params = args
      uri = URI("#{ENDPOINT}/#{path}")
      uri.query = URI.encode_www_form(params.merge({token: TOKEN}))
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)
      else
        raise StandardError, "Slack API responded with: #{response}"
      end
    end
  end

  class Channel
    include HTTP

    def initialize(id: 'C0D9GMLVC')
      @channel = get('channels.info', {channel: id})['channel']
    end

    def members
      @channel['members']
    end
  end

  class User
    include HTTP
    attr_accessor :id, :title, :first_name, :last_name, :real_name, :gamertag

    def initialize(id: 'U0CV2MDJ9')
      @id = id
      @user = get('users.info', {user: @id})['user']
      @title = @user['profile']['title']
      @first_name = @user['profile']['first_name']
      @last_name  = @user['profile']['last_name']
      @real_name  = @user['profile']['real_name']
    end

    def gamertag
      User.parse_gamertag(title)
    end

    # Snowflakes, and I'm too lazy to improve these.
    TYPE_1 = /^((ps[4|n]|xb1|xboxone)(([:-]\W*)|\W*))+/i
    TYPE_2 = /\W*(warlock|titan|teacher)\W*ps[4|n]\W*\s?/i

    def self.parse_gamertag(title)
      case title
      when /head of engineering at pinterest/i
        'kurzinator'
      when /psn: palefacex . i'm on gmt/i
        'PalefaceX'
      when /software engineer at everlane; psn: esherido/i
        'Esherido'
      when /NeuronBasher, XB1: Neuron Basher. I also run a little startup called Operable./i
        'NeuronBasher'
      when /XB1: changelog PSN: superdealloc \(CET time\)/i
        'superdealloc'
      when /Software Engineer at Heroku; PSN\/XB1: daneharrigan/i
        'daneharrigan'
      when /PS4: RebelSenator. Titan main./i
        'RebelSenator'
      when /Dean of Students, Xbox One: KaiserHughes/i
        'KaiserHughes'
      when TYPE_1
        title.gsub(TYPE_1, '').chomp(' ')
      when TYPE_2
        title.gsub(TYPE_2, '').chomp(' ')
      else
        nil
      end
    end
  end
end

module GG
  API_ENDPOINT   = 'http://api.guardian.gg'
  PROXY_ENDPOINT = 'http://proxy.guardian.gg'
  XBOX = 1
  PSN  = 2

  class User
    attr_reader :user, :membership_ids

    def initialize(gamertag: 'wpp31')
      @gamertag = gamertag
    end

    def get_user_for(platform)
      uri = URI(URI.encode("#{PROXY_ENDPOINT}/Platform/Destiny/SearchDestinyPlayer/#{platform}/#{@gamertag}/"))
      response = Net::HTTP.get_response(uri)
      body = JSON.parse(response.body)['Response']
      body.empty? ? {} : body[0]
    end

    def get_membership_ids
      @membership_ids = []

      unless (psn_user  = get_user_for(PSN)).empty?
        @membership_ids << { id: psn_user['membershipId'], platform_id: PSN }
      end

      unless (xbox_user = get_user_for(XBOX)).empty?
        @membership_ids << { id: xbox_user['membershipId'], platform_id: XBOX }
      end
    end

    def get_elos(membership_id)
      uri = URI(URI.encode("#{API_ENDPOINT}/elo/#{membership_id}"))
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body)
    end
  end
end
