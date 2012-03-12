shared_examples_for 'acts_as_article' do |options = {}|

  options = {:factory => described_class.name.downcase.to_sym}.merge(options)

  it { should have_db_column(:slug).of_type(:string) }
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:description).of_type(:string) }
  it { should have_db_column(:keywords).of_type(:string) }
  it { should have_db_column(:excerpt).of_type(:text) }
  it { should have_db_column(:content).of_type(:text) }
  it { should have_db_column(:published_at).of_type(:datetime) }
  it { should have_db_column(:highlight).of_type(:boolean) }
  it { should have_db_column(:locale).of_type(:string) }

  it { should have_db_index(:slug) }
  it { should have_db_index([:published_at, :locale]) }
  it { should have_db_index([:highlight, :published_at, :locale]) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:locale) }

  context "scopes" do
    it 'should have unpublished scope' do
      unpublished_article = Factory(options[:factory], :published_at => nil)
      published_article   = Factory(options[:factory], :published_at => DateTime.now)

      described_class.unpublished.should == [unpublished_article]
    end

    it 'should have published scope' do
      unpublished_article = Factory(options[:factory], :published_at => nil)
      published_article   = Factory(options[:factory], :published_at => DateTime.now)

      described_class.published.should == [published_article]
    end

    it 'should have sorted scope' do
      described_class.sorted.should_not be_nil
    end

    it 'should have highlighted scope' do
      not_highlighted_article = Factory(options[:factory], :highlight => false)
      highlighted_article     = Factory(options[:factory], :highlight => true)

      described_class.highlighted.should == [highlighted_article]
    end

    it 'should have for_slug scope' do
      article         = Factory(options[:factory], :published_at => DateTime.now)
      slugged_article = Factory(options[:factory], :title => "Our custom title")

      described_class.for_slug(slugged_article.slug).should == [slugged_article]
    end

    it 'should have for_locale scope' do
      locale_article       = Factory(options[:factory], :locale => "en")
      other_locale_article = Factory(options[:factory], :locale => "pt")

      described_class.for_locale("en").should == [locale_article]
    end

    describe 'for_published_at scope' do
      it 'should filter by year' do
        article_last_year    = Factory(options[:factory], :published_at => Date.current - 1.year)
        article_current_year = Factory(options[:factory], :published_at => Date.current)
        article_next_year    = Factory(options[:factory], :published_at => Date.current + 1.year)

        described_class.for_published_at(Date.current.year).should == [article_current_year]
      end

      it 'should filter by year and month' do
        article_last_month    = Factory(options[:factory], :published_at => Date.current - 1.month)
        article_current_month = Factory(options[:factory], :published_at => Date.current)
        article_next_month    = Factory(options[:factory], :published_at => Date.current + 1.month)

        described_class.for_published_at(Date.current.year, Date.current.month).should == [article_current_month]
      end

      it 'should filter by year and month and day' do
        article_last_day    = Factory(options[:factory], :published_at => Date.current - 1.day)
        article_current_day = Factory(options[:factory], :published_at => Date.current)
        article_next_day    = Factory(options[:factory], :published_at => Date.current + 1.day)

        described_class.for_published_at(Date.current.year, Date.current.month, Date.current.day).should == [article_current_day]
      end
    end
  end

  describe "instance methods" do
    it 'should be able to set published_at trought the publish_now method' do
      article = Factory(options[:factory], :published_at => nil)
      article.published_at.should be_nil

      article.publish_now = true
      article.save!
      article.published_at.should be_present
    end
  end

  context "callbacks" do
    it 'should save slug from title' do
      article = Factory(options[:factory])
      article.slug.should == "#{article.title.parameterize}"
    end
  end
end