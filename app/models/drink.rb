class Drink < ActiveRecord::Base

  validates_presence_of :name, :bottle_size, :price

  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  before_post_process :normalize_filename

  private

  def normalize_filename
    extension = File.extname(logo_file_name).downcase
    self.logo.instance_write :file_name, "logo#{extension}"
  end

end
