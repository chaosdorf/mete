class Drink < ActiveRecord::Base

  validates_presence_of :name, :bottle_size, :price

  has_attached_file :logo, :styles => { :thumb => "100x100#" }, :default_style => :thumb
  validates_attachment_content_type :logo, :content_type => %w(image/jpeg image/jpg image/png)
  before_post_process :normalize_filename
  after_initialize :set_defaults, unless: :persisted?
  
  def as_json(options)
    h = super(options)
    #h[:donationRecommendation] = price
    h[:donation_recommendation] = price
    h[:bottle_size] = bottle_size
    h[:logo_url] = logo.url
    h
  end

  private

  def set_defaults
    self.price = 1.5
  end

  def normalize_filename
    extension = File.extname(logo_file_name).downcase
    self.logo.instance_write :file_name, "logo#{extension}"
  end

end
