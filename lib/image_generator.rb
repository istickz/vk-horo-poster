require_relative "text_placer.rb"
class ImageGenerator

  require 'RMagick'
  attr_accessor :date, :description, :file


  def save(filename)
    canvas = Magick::ImageList.new @file

    horo_date = Magick::Draw.new
    horo_date.font_family = 'helvetica'
    horo_date.pointsize = 16
    horo_date.interline_spacing = 7
    horo_date.annotate(canvas, 0,0,180,57, @date) {
      self.fill = '#929da7'
    }

    horo_description = Magick::Draw.new
    horo_description.font_family = 'helvetica'
    horo_description.pointsize = 20
    horo_description.interline_spacing = 5
    horo_description.annotate(canvas, 0,0,190,100, @description.place(44)) {
      self.fill = '#929da7'
    }

    canvas.write(filename)
  end

end
