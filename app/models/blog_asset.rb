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
	belongs_to :blog_post
	
	has_attachment  :content_type => :image,
		:storage => :file_system,
		:path_prefix => "public/images/upload/#{table_name}",
		:min_size => 100.bytes,
		:max_size => 6.megabytes,
		:resize_to => '350x350>',	# This sets the maximum size of a side.  Aspect ratio is maintained, but the image scales so that its largest side is the size specified here.
		:thumbnails => { :thumb200 => '267x214' }, # See http://www.imagemagick.org/RMagick/doc/imusage.html#geometry to find out what this means
		:processor => "Rmagick", 
		# What type of content will you allow to be uploaded to your blog?  Set it here... by default, these are all image types (AND a pdf)
		:content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/gif', 'image/png','image/x-png','image/jpg','image/x-ms-bmp','image/bmp','image/x-bmp',
			'image/x-bitmap','image/x-xbitmap','image/x-win-bitmap','image/x-windows-bmp','image/ms-bmp','application/bmp','application/x-bmp',
			'application/x-win-bitmap','application/preview','image/jp_','application/jpg','application/x-jpg','image/pipeg','image/vnd.swiftview-jpeg',
			'image/x-xbitmap','application/png','application/x-png','image/gi_','image/x-citrix-pjpeg', 'application/pdf']
		
	validates_as_attachment
		
end
