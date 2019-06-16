class HomeController < ApplicationController
  def index
  end

  def link_check
    @preview = PreviewAnalyzer.new(url: params[:url]) if params[:url]
  end

  def image_dimension
    if params[:url]
      @image_dimension = FastImage.size("http://upload.wikimedia.org/wikipedia/commons/b/b4/Mardin_1350660_1350692_33_images.jpg", raise_on_failure: false, timeout: 2.0)
    end
  end
end
