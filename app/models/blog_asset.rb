# == Schema Information
# Schema version: 119
#
# Table name: blog_assets
#
#  id           :integer(11)     not null, primary key
#  blog_id      :integer(11)     
#  parent_id    :integer(11)     
#  content_type :string(255)     
#  filename     :string(255)     
#  thumbnail    :string(255)     
#  size         :integer(11)     
#  width        :integer(11)     
#  height       :integer(11)     
#

class BlogAsset < ActiveRecord::Base
	belongs_to :blog
	
	has_attachment  :content_type => :image,
		:storage => :file_system,
		:path_prefix => "public/images/upload/#{table_name}",
		:min_size => 100.bytes,
		:max_size => 6.megabytes,
		:resize_to => '350x350>',	# This sets the maximum size of a side.  Aspect ratio is maintained, but the image scales so that its largest side is the size specified here.
		:thumbnails => { :thumb200 => '267x214' }, # See http://www.imagemagick.org/RMagick/doc/imusage.html#geometry to find out what this means
		:processor => "Rmagick" # "ImageScience" # Kropper also supports Rmagick, as you can see below
		
	validates_as_attachment
		
end
