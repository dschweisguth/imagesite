require 'fileutils'

feature "Image site generation" do
  let(:output_dir) { '/tmp/imagesite-test-output' }

  scenario "User generates maximal image site" do
    run_imagesite_with_2x2_indexes_on_5_maximal_photos
    visit_index_page
    page_has_site_title
    page_has_no_link_to 'Page 1'
    page_has_4_thumbnails_in_2_columns_and_2_rows

    follow_link_to 'Page 2'
    page_has_no_link_to 'Page 2'
    page_has_1_thumbnail

    follow_link_to 'Page 1'
    follow_first_thumbnail_link
    page_has_image_title_description_and_tags
    page_has_no_link_to '<--Previous'

    follow_link_to 'Next-->'
    page_has_link_to('<--Previous')

    3.times { follow_link_to 'Next-->' }
    page_has_link_to('<--Previous')
    page_has_no_link_to 'Next-->'

  end

  # Specific steps

  def run_imagesite_with_2x2_indexes_on_5_maximal_photos
    FileUtils.rm_rf output_dir
    photos = Array.new(5, 'spec/features/test-all-metadata.jpeg')
    # Run this way rather than using system so coverage sees the code.
    # Require the class rather than the executable because require needs .rb and
    # simplecov needs require (not load).
    stub_const 'ARGV', ['-t', 'Site title', '-c', '2', '-r', '2', '-o', output_dir, *photos]
    ImageSite::ImageSite.new.run
  end

  def visit_index_page
    visit "#{output_dir}/index.html"
  end

  def page_has_site_title
    expect(page).to have_content('Site title')
  end

  def page_has_4_thumbnails_in_2_columns_and_2_rows
    rows = page.all 'tr'
    expect(rows.length).to eq(2)
    image_number = 1
    rows.each do |row|
      cells = row.all('td')
      expect(cells.length).to eq(2)
      cells.each do |cell|
        has_thumbnail cell, image_number
        image_number += 1
      end
    end
  end

  def page_has_1_thumbnail
    has_thumbnail find('tr td'), 5 # find would explode if there were more than 1
  end

  def follow_first_thumbnail_link
    first('td a').click
  end

  def page_has_image_title_description_and_tags
    expect(page).to have_css(%Q(img[alt="Image title"][src="../Images/1.jpeg"]))
    ['Image title', 'Image description', 'Image tag 1', 'Image tag 2'].each do |text|
      expect(page).to have_text(text)
    end
  end

  # General purpose steps

  def page_has_link_to(text)
    expect(page).to have_css('a', text: text)
  end

  def page_has_no_link_to(text)
    expect(page).to have_no_css('a', text: text)
  end

  def follow_link_to(page)
    click_link page
  end

  def has_thumbnail(element, image_number)
    expect(element).to have_css(%Q(a img[alt="Image title"][src="Thumbnails/#{image_number}.jpeg"]))
    expect(element).to have_text('Image title')
  end

end
