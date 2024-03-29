require 'fileutils'

feature "Image site generation" do
  let(:output_dir) { '/tmp/imagesite-test-output' }

  scenario "User generates image site" do
    run_imagesite images: 5, columns: 2, rows: 2
    visit_index_page
    page_has_site_title
    page_has_no_link_to 'Page 1'
    page_has_4_thumbnails_in_2_columns_and_2_rows
    page_has_no_parent_link

    follow_link_to 'Page 2'
    page_has_no_link_to 'Page 2'
    page_has_1_thumbnail
    page_has_no_parent_link

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

  scenario "User specifies descriptions on index pages" do
    run_imagesite images: 5, columns: 2, rows: 2, descriptions_on_index_pages: true
    visit_index_page
    page_has_4_thumbnails_in_2_columns_and_2_rows descriptions_on_index_pages: true
  end

  scenario "User specifies a parent link" do
    run_imagesite images: 2, columns: 1, rows: 1, parent_link_text: 'Parent'
    visit_index_page
    page_has_no_parent_link

    follow_link_to 'Page 2'
    page_has_parent_link 'Parent'

  end

  # Specific steps

  def run_imagesite(images: nil, columns: nil, rows: nil, descriptions_on_index_pages: false, parent_link_text: nil)
    FileUtils.rm_rf output_dir
    photos = Array.new(images, 'spec/data/test-all-metadata.jpeg')
    # Run this way rather than using system so coverage sees the code.
    # Require the class rather than the executable because require needs .rb and
    # simplecov needs require (not load).
    args = ['-t', 'Site title', '-c', columns.to_s, '-r', rows.to_s, '-o', output_dir]
    if descriptions_on_index_pages
      args << '-d'
    end
    if parent_link_text
      args += ['-p', parent_link_text]
    end
    args += photos
    stub_const 'ARGV', args
    ImageSite::ImageSite.new.run
  end

  def visit_index_page
    visit "#{output_dir}/index.html"
  end

  def page_has_site_title
    expect(page).to have_content('Site title')
  end

  def page_has_4_thumbnails_in_2_columns_and_2_rows(descriptions_on_index_pages: false)
    rows = page.all 'tr'
    expect(rows.length).to eq(2)
    image_number = 1
    rows.each do |row|
      cells = row.all('td')
      expect(cells.length).to eq(2)
      cells.each do |cell|
        has_thumbnail cell, image_number, descriptions_on_index_pages
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
    expect(page).to have_css(%q(img[alt="Image title"][src="../Images/1.jpeg"]))
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

  def page_has_parent_link(text)
    expect(page).to have_css('a[href="../"]', text: text)
  end

  def page_has_no_parent_link
    expect(page).to have_no_css('a[href="../"]')
  end

  def follow_link_to(page)
    click_link page
  end

  def has_thumbnail(element, image_number, descriptions_on_index_pages = false)
    expect(element).to have_css(%Q(a img[alt="Image title"][src="Thumbnails/#{image_number}.jpeg"]))
    expect(element).to have_text('Image title')
    expect(element.has_text?('Image description')).to eq(descriptions_on_index_pages)
  end

end
