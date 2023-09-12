class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def imageUrl
    image.attached? ? Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) : nil
  end
end

