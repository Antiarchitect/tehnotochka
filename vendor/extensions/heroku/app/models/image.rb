# encoding: utf-8
class Image < Asset
  has_attached_file :attachment, 
                    :styles => { :mini => '48x48>', :small => '100x100>', :product => '240x240>', :large => '600x600>' }, 
                    :default_style => :product,
                    :path => "assets/products/:id/:style/:basename.:extension",
                    :storage => "s3",
                    :s3_credentials => {
                      :access_key_id => ENV['S3_KEY']  || HEROKU_AWS_S3['access_key_id'],
                      :secret_access_key => ENV['S3_SECRET'] || HEROKU_AWS_S3['secret_access_key']
                    },
                    :bucket => ENV['S3_BUCKET'] || HEROKU_AWS_S3['bucket']

  # save the w,h of the original image (from which others can be calculated)
  # we need to look at the write-queue for images which have not been saved yet
  after_post_process :find_dimensions
  def find_dimensions
    temporary = attachment.queued_for_write[:original] 
    filename = temporary.path unless temporary.nil?
    filename = attachment.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.attachment_width  = geometry.width
    self.attachment_height = geometry.height
  end

  # if there are errors from the plugin, then add a more meaningful message
  def validate
    unless attachment.errors.empty?
      # uncomment this to get rid of the less-than-useful interrim messages
      # errors.clear 
      errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
      false
    end
  end
end
