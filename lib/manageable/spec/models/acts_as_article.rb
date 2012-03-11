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
      articles = [Factory(options[:factory], :published_at => nil), Factory(options[:factory], :published_at => DateTime.now)]

      [articles[0]].should == described_class.unpublished.all
    end

    it 'should have published scope' do
      articles = [Factory(options[:factory], :published_at => nil), Factory(options[:factory], :published_at => DateTime.now)]

      [articles[1]].should == described_class.published.all
    end

    it 'should have sorted scope' do
      described_class.sorted.all.should_not be_nil
    end

    it 'should have highlighted scope' do
      articles = [Factory(options[:factory], :highlight => false), Factory(options[:factory], :highlight => true)]

      [articles[1]].should == described_class.highlighted.all
    end

    it 'should have for_url_param scope' do
      article = Factory(options[:factory], :published_at => DateTime.now)

      article.should == described_class.for_url_param(article.slug).first
    end

    it 'should have for_locale scope' do
      locale_article       = Factory(options[:factory], :locale => "en")
      other_locale_article = Factory(options[:factory], :locale => "pt")

      described_class.for_locale("en").should == [locale_article]
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