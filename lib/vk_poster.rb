class VkPoster
  require 'vkontakte_api'
  attr_reader :post_msg

  def initialize
    VkontakteApi.configure do |config|
      config.app_id       = ENV['VK_APP_ID']
      config.app_secret   = ENV['VK_APP_SECRET']
      config.adapter = :net_http
      config.http_verb = :post
      config.faraday_options = {
        ssl: {
          :verify => false
        },
      }
    end
    @app = VkontakteApi::Client.new(ENV['VK_ACCESS_TOKEN'])
  end

  def wall_post(gid, file, caption)
    us = @app.photos.get_wall_upload_server(gid: gid)
    up = VkontakteApi.upload(url: us.upload_url, file1: ["#{file}", 'image/jpeg'])
    up.caption = "#{caption}"
    up.gid = gid
    save = @app.photos.save_wall_photo(up)
    @post_msg = @app.wall.post(attachments: save.first.id, owner_id: "-#{gid}", from_group: 1 )
  end

  def wall_repost(wall_post_id, gid)
    @app.wall.repost(object: wall_post_id, group_id: gid )
  end

end




