describe ImageSite::Image do
  describe '#write' do
    let(:output_dir) { '/tmp/imagesite-test-output' }
    before { FileUtils.rm_rf output_dir }

    # This is already adequately tested by the acceptance spec, but we need a
    # baseline for the other examples
    it "handles an image with all metadata" do
      image = image('test-all-metadata.jpeg')
      image.write
      page = parsed_page image
      h1s = page.css('h1')
      expect(h1s.length).to eq(1)
      expect(h1s.first.text).to eq('Image title')
      expect(page.css('p').count { |p| p.text == 'Image description' }).to eq(1)
      expect(page.css('b').map(&:text)).to eq(['Image tag 1', 'Image tag 2'])
    end

    it "handles an image with no metadata" do
      image = image('test-no-metadata.jpeg')
      image.write
      page = parsed_page image
      expect(page.css('h1')).to be_empty
      expect(page.css('p').any? { |p| p.children.empty? && p.text.empty? }).to be false # i.e. there is no empty description or tags
    end

    it "handles an image with no dc" do
      image = image('test-no-dc.jpeg')
      expect(image.title).to be_nil
      expect(image.tags).to be_empty
    end

    it "handles an image with dc but no subject" do
      expect(image('test-no-subject.jpeg').tags).to be_empty
    end

    it "handles an image with dc but no title" do
      expect(image('test-no-title.jpeg').title).to be_nil
    end

    def image(unqualified_file)
      file = "spec/data/#{unqualified_file}"
      stub_const 'ARGV', ['-t', 'Title', '-o', output_dir, file]
      options = ImageSite::Options.new
      options.parse!
      image = ImageSite::Image.new 1, file, options
      index = ImageSite::Index.new 1, [image], options
      image.index = index
      image
    end

    def parsed_page(image)
      File.open("#{output_dir}/#{image.relative_html}") { |file| Nokogiri::XML(file) }
    end

  end
end
