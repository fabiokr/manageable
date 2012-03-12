class Article < ActiveRecord::Base
  include Manageable::Models::ActsAsArticle
end