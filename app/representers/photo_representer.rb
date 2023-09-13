class PhotoRepresenter
  def initialize(photos)
    @photos = photos
  end

  def as_json
    @photos.map do |photo|
      {
        id: photo.id,
        title: photo.title,
        image: photo.imageUrl
      }
    end
  end

  private

  attr_reader :photos
end
