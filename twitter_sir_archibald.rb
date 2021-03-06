require 'twitter'
require 'geocoder'
require 'yaml'

class Sir_Archibald

  def self.run_once
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = 'RuEj73tDb5kVokCEE2pKHA3zg'
      config.consumer_secret     = 'Z89eWeV5PNj6bQ4nF0amAVDtmaFmmy1GW4BTihJCskWlLQSsr8'
      config.access_token        = '2593421125-XmaWz1yk6dac0RdIUGMVkCl6DB22VKvStHQDmn6'
      config.access_token_secret = 'MiSWcXHWvHu9gtyazrv9vtflCV2ROz2ydyRnX9hGYSbfF'
    end

    t = client.search('"no manors"', :result_type => 'recent', :lang => 'en').first

    @name = t.user.name.split[0]
    @handle = t.user.screen_name

    @users = []

    if File.exists? 'users.yaml'
      @users = YAML.load(open 'users.yaml')
    end

    if @users.include? t.user.screen_name
      p "#@handle -- already a friend: #{t.text}"
    else

      loop do

        potential_tweets = [
          "@#{@handle} Oh No! No manors? Get in touch and I'll try to help out.",
          "@#{@handle} This saddens me deeply, #{@name}. Everyone should own a couple of manors.",
          "@#{@handle} #{@name}, no manors? #firstworldproblems",
          "@#{@handle} #{@name}, this is truly tragic. Everyone should have at least one estate.",
          "@#{@handle} #{@name}, I am shocked to the core. Manors are important. I inherited mine.",
          "@#{@handle} Disgusting. Everyone should have at least a couple of good manors.",
          "@#{@handle} Good manors don't cost a penny - I inherited mine.",
          "@#{@handle} I have found, #{@name}, that manors are essential for one's own sense of wellbeing.",
          "@#{@handle} 'A life without manors is not worth living' - Sir Archibald.",
          "@#{@handle} Manors are a mark of true civilisation, #{@name}. Anything less than 800 acres is pitiful.",
          "@#{@handle} No manors? Go exploring and create some yourself.",
          "@#{@handle} Manors maketh man. As do Chateauxs and stalking lodges.",
          "@#{@handle} Just like you, I can't stand the idea of people without manor or two."
        ]

        @random_tweet = potential_tweets.sample


        if (rand() > 0.7) && (t.geo?)
          p 'congrats. GEOCODE! :D'

          geo_result = Geocoder.search(t.geo.coordinates)
          @place = geo_result[0].data['formatted_address'].split(',')[-2..-1].join(',')

          tweet = ["@#{@handle} I've heard that #{@place} has a distinct lack of stately homes too.",
                   "@#{@handle} #{@name}, #{@place} has very few Aristocrats; this is to be expected."]

          @random_tweet = tweet.sample

        end

        break if @random_tweet.length < 140
        p 'What are the chances - Im looping. OMG'
      end

      client.follow @handle
      client.update(@random_tweet, {"in_reply_to_status_id" => t.id}) 
      p 'OMG. TWEETED!!!!!'

      p "Tweeted: #{@random_tweet}"

      if File.exists? 'users.yaml'
        @users << @handle
        File.open('users.yaml', 'w'){|f| f.write @users.to_yaml}
      end
    end
  end
end

# Sir_Archibald.run_once
# heroku config:add CONSUMER_KEY=__CONSUMER_KEY__
# heroku config:add CONSUMER_SECRET=__CONSUMER_SECRET__
# heroku config:add OAUTH_TOKEN=__OAUTH_TOKEN__
# heroku config:add OAUTH_TOKEN_SECRET=__OAUTH_TOKEN_SECRET__
# heroku config:add USERNAME=__STELLAR_USERNAME__
