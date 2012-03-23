module Manageable
  module Models
    module ActsAsArticle
      extend ActiveSupport::Concern

      included do
        before_save :set_slug, :set_published, :set_locale

        validates :title, :presence => true, :uniqueness => {:scope => :category_id, :case_sensitive => false, :if => Proc.new { |article| article.respond_to?(:category_id) }}

        scope :unpublished, where(:published_at => nil)
        scope :published,   lambda { where(arel_table[:published_at].not_eq(nil)) }
        scope :highlighted, lambda { where(:highlight => true) }
        scope :for_slug,    lambda { |param| where(:slug => param) }
        scope :for_locale,  lambda { |locale| where(:locale => locale) }
        scope :for_published_at, (lambda do |*args|
          year, month, day = args

          if year.nil?
            scoped
          else
            beginning_date, end_date = if month.nil? && day.nil?
              [Date.new(year.to_i).beginning_of_year, Date.new(year.to_i).end_of_year]
            elsif day.nil?
              [Date.new(year.to_i, month.to_i).beginning_of_month, Date.new(year.to_i, month.to_i).end_of_month]
            else
              [Date.new(year.to_i, month.to_i, day.to_i).beginning_of_day, Date.new(year.to_i, month.to_i, day.to_i).end_of_day]
            end

            where("published_at >= ? AND published_at <= ?", beginning_date, end_date)
          end
        end)
        scope :sorted,      (lambda do |*args|
          sort = args.first
          order(sort ? sort : 'highlight DESC, published_at DESC')
        end)
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

      def set_locale
        self.locale = I18n.locale unless self.locale
      end
    end
  end
end
