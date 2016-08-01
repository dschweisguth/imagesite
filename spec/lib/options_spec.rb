describe ImageSite::Options do
  describe '#parse!' do
    let(:options) { ImageSite::Options.new }

    it "parses valid options" do
      stub_const 'ARGV', %w(-t Title -o output image.jpeg)
      options.parse!
      expect(options.title).to eq('Title')
      expect(options.columns).to eq(ImageSite::Options::DEFAULT_COLUMNS)
      expect(options.rows).to eq(ImageSite::Options::DEFAULT_ROWS)
      expect(options.output_dir).to eq('output')
      expect(options.files).to eq(%w(image.jpeg))
    end

    context "watching stderr" do
      class Watcher
        attr_reader :output

        def initialize
          @output = []
        end

        def write(string)
          @output << string
        end

      end

      let(:stderr) { Watcher.new }

      around do |example|
        old_stderr = $stderr
        $stderr = stderr
        begin
          example.run
        ensure
          $stderr = old_stderr
        end
      end

      it "aborts if a title was not specified" do
        stub_const 'ARGV', %w(-o output image.jpeg)
        expect { options.parse! }.to raise_error SystemExit
        expect(stderr.output.first).to match(/Please specify a title with -t\./)
      end

      it "aborts if an output dir was not specified" do
        stub_const 'ARGV', %w(-t Title image.jpeg)
        expect { options.parse! }.to raise_error SystemExit
        expect(stderr.output.first).to match(/Please specify an output directory with -o\./)
      end

      it "aborts if one or more files were not specified" do
        stub_const 'ARGV', %w(-t Title -o output)
        expect { options.parse! }.to raise_error SystemExit
        expect(stderr.output.first).to match(/Please specify one or more image files\./)
      end

      it "aborts if an unknown option was specified" do
        stub_const 'ARGV', %w(-x)
        expect { options.parse! }.to raise_error SystemExit
        expect(stderr.output.first).to start_with('Usage:')
      end

      it "prints help and exits if -h was specified" do
        stub_const 'ARGV', %w(-h)
        expect { options.parse! }.to raise_error SystemExit
        expect(stderr.output.first).to start_with('Usage:')
      end

    end

  end
end
