module Manageable
  module Models
    module ActsAsArticle
      extend ActiveSupport::Concern

      included do
        before_save :set_slug, :set_published

        validates :title, :presence => true, :uniqueness => {:scope => :category_id, :case_sensitive => false, :if => Proc.new { |article| article.respond_to?(:category_id) }}
        validates :locale, :presence => true

        scope :unpublished,   where(:published_at => nil)
        scope :published,     lambda { where(arel_table[:published_at].not_eq(nil)) }
        scope :highlighted,   lambda { where(:highlight => true) }
        scope :for_url_param, lambda { |param| where(:slug => param) }
        scope :for_locale,    lambda { |locale| where(:locale => locale) }
        scope :sorted, (lambda do |*args|
          sort = args.first
          order(sort ? sort : 'highlight DESC, published_at DESC')
        end)

        scope :latest_published_highlighted, lambda { published.highlighted.sorted }
        scope :latest_published, lambda { published.sorted }
      end

      def to_url_param
        self.slug
      end

      def publish_now=(value)
        @publish_now = (value && !(value === 'false'))
      end

      private

      def set_slug
        self.slug = "#{self.title.parameterize}" if self.title
      end

      def set_published
        self.published_at = DateTime.now if @publish_now
      end
    end
  end
end
