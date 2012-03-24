# This migration comes from manageable_engine (originally 20120311172544)
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :slug
      t.string :title
      t.string :description
      t.string :keywords
      t.string :locale
      t.text :excerpt
      t.text :content
      t.datetime :published_at
      t.boolean  :highlight
      t.timestamps
    end

    add_index :articles, :slug
    add_index :articles, [:published_at, :locale]
    add_index :articles, [:highlight, :published_at, :locale]
  end
end