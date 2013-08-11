require './lib/image_generator'
require './lib/vk_poster'
require './lib/rus_date'
require 'nokogiri'
require 'open-uri'

# Загрузим наши настройки
horo_settings = YAML.load_file('settings.yml')

# I этап. Получим гороскопы.
url = "http://img.ignio.com/r/export/utf/xml/daily/lov.xml"
horo_feed = Nokogiri::XML open(url)

# II этап. Генерация картинок.
images_folder = horo_settings[:all][:images_path]
templates_folder = horo_settings[:all][:templates_path]
templates_list = Dir.foreach(templates_folder).select { |x| File.file?("#{templates_folder}/#{x}") }

templates_list.each do |file|
  image = ImageGenerator.new
  image.file = "#{templates_folder}/#{file}"
  image.date = RusDate.today
  sign_name = horo_settings[:"#{file}"][:rss]
  image.description = horo_feed.xpath("//#{sign_name}//today").text
  image.save("#{images_folder}/#{file}")
end


# III этап. Отправка изображений в группы vk.com и репост в основную группу.
# Основная группа, нужна для репоста сообщений из других групп.

default_gid = horo_settings[:all][:public_id]
images_list = Dir.foreach(images_folder).select { |x| File.file?("#{images_folder}/#{x}") }


images_list.each do |image|

  uploader = VkPoster.new
  gid = horo_settings[:"#{image}"][:public_id]
  uploader.wall_post( gid , "#{images_folder}/#{image}", "http://ignio.com")

  uploader.wall_repost("wall-#{gid}_#{uploader.post_msg.post_id}", default_gid)
  sleep 20 + rand(30)
end
