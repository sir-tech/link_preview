class PreviewAnalyzer
  attr_accessor :metatags, :og_tags, :whatsapp_sharing_tags, :facebook_sharing_tags

  def initialize(url:)
    begin
      @metatags = MetaInspector.new(url).try(:meta_tags)
    rescue => e
      @metatags = nil
    end
  end

  def metadata
    @metatags
  end

  def twitter_tags
    return @twitter_tags if @twitter_tags

    @twitter_tags ||= {}
    @metatags["name"].each do |k,v|
      @twitter_tags[k] = v if k.include?('twitter:')
    end
    @twitter_tags
  end

  def og_tags
    @og_tags ||= @metatags.try(:[], 'property').dup
  end

  def og_images
    (@og_tags['og:image'] || [])
  end

  def whatsapp_sharing_tags
    return @whatsapp_sharing_tags if @whatsapp_sharing_tags
    @whatsapp_sharing_tags ||= {}
    @whatsapp_sharing_tags[:small_images] ||= {}
    og_images.each do |image_url|
      _image_hint = wa_image_hint(get_image_resolution(image_url))
      @whatsapp_sharing_tags[:small_images][image_url] = _image_hint if _image_hint
    end
    @whatsapp_sharing_tags
  end

  def wa_image_hint(resolution)
    return unless resolution
    return 'Image too small for sharing' if resolution[0] < 100 || resolution[1] < 100
  end

  def facebook_sharing_tags
    return @facebook_sharing_tags if @facebook_sharing_tags
    @facebook_sharing_tags ||= {}
    @facebook_sharing_tags[:small_images] ||= {}
    og_images.each do |image_url|
      _image_hint = fb_image_hint(get_image_resolution(image_url))
      @facebook_sharing_tags[:small_images][image_url] = _image_hint if _image_hint
    end
    @facebook_sharing_tags
  end

  def fb_image_hint(resolution)
    return unless resolution
    return 'Image too small for sharing' if resolution[0] < 200 || resolution[1] < 200
  end

  private

  def get_image_resolution(image_url)
    FastImage.size(image_url, raise_on_failure: false, timeout: 2.0)
  end
end
