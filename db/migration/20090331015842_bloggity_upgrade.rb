class BloggityUpgrade < ActiveRecord::Migration
  def self.up
		create_table :blog_categories do |t|
      t.string :name
			t.integer :parent_id
      t.integer :group_id, :default => 0
			
      t.timestamps
    end
		
		add_index :blog_categories, :parent_id
		add_index :blog_categories, :group_id
		add_column :blogs, :fck_created, :boolean
		add_index :blogs, :category_id
		
		bc = BlogCategory.create(:name => "Main blog")
		BlogPost.update_all(["category_id = ?", bc.id])
  end

  def self.down
    drop_table :blog_categories
		
		remove_column :blogs, :fck_created
		remove_index :blogs, :category_id
  end
end
