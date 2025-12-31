require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#file_name_with_timestamp' do
    let(:frozen_time) { Time.local(2024, 12, 19, 14, 30, 0) }
    let(:timestamp) { frozen_time.strftime('%Y-%m-%d_%H-%M-%S') }

    before do
      Time.use_zone(Time.zone) { travel_to(frozen_time) }
    end

    it 'returns filename with timestamp and extension' do
      result = helper.file_name_with_timestamp(file_name: 'report', file_extension: 'xlsx')
      expect(result).to eq("report_#{timestamp}.xlsx")
    end

    it 'handles special characters in filename' do
      result = helper.file_name_with_timestamp(file_name: 'my report!', file_extension: 'csv')
      expect(result).to eq("my report!_#{timestamp}.csv")
    end

    it 'handles different file extensions' do
      extensions = %w[pdf doc xlsx csv txt]
      extensions.each do |ext|
        result = helper.file_name_with_timestamp(file_name: 'report', file_extension: ext)
        expect(result).to eq("report_#{timestamp}.#{ext}")
      end
    end
  end

  describe '#default_date_format' do
    it 'returns same value if a non-date value is submitted' do
      submitted_value = Faker::Lorem.word
      expect(default_date_format(submitted_value)).to eq submitted_value
    end

    it 'returns the properly formatted date value if date is submitted' do
      submitted_value = Faker::Date.between(from: 2.years.ago, to: Time.zone.today)
      expect(default_date_format(submitted_value)).to eq submitted_value.strftime('%b %e, %Y')
    end

    it 'returns nil if nil is submitted' do
      submitted_value = nil
      expect(default_date_format(submitted_value)).to be_nil
    end
  end

  describe '#selector_date_format' do
    it 'formats a date object' do
      date = Date.new(2024, 12, 19)
      expect(helper.selector_date_format(date)).to eq('2024-12-19')
    end

    it 'formats a datetime object' do
      datetime = DateTime.new(2024, 12, 19, 14, 30, 0)
      expect(helper.selector_date_format(datetime)).to eq('2024-12-19')
    end

    it 'returns original value if not a date object' do
      expect(helper.selector_date_format('2024-12-19')).to eq('2024-12-19')
      expect(helper.selector_date_format(nil)).to be_nil
    end

    it 'formats a time object' do
      time = Time.zone.local(2024, 12, 19, 14, 30, 0)
      expect(helper.selector_date_format(time)).to eq('2024-12-19')
    end
  end

  describe '#external_link_to' do
    it 'renders link with default options' do
      link = helper.external_link_to('Google', 'https://google.com')

      expect(link).to have_link('Google', href: 'https://google.com')
      expect(link).to have_css('a[target="_blank"]')
      expect(link).to have_css('a[rel="noopener noreferrer"]')
      expect(link).to have_content('Google')
    end

    it 'merges custom options with defaults' do
      link = helper.external_link_to('Google', 'https://google.com', class: 'btn')

      expect(link).to have_css('a.btn')
      expect(link).to have_css('a[target="_blank"]')
      expect(link).to have_css('a[rel="noopener noreferrer"]')
    end

    it 'allows overriding default options' do
      link = helper.external_link_to('Google', 'https://google.com', target: '_self')

      expect(link).to have_css('a[target="_self"]')
      expect(link).to have_css('a[rel="noopener noreferrer"]')
    end

    it 'renders data attributes' do
      link = helper.external_link_to('Google', 'https://google.com', data: { test: 'value' })

      expect(link).to have_css('a[data-test="value"]')
    end

    it 'escapes HTML in name' do
      link = helper.external_link_to('<script>alert("xss")</script>', 'https://google.com')

      expect(link).not_to include('<script>')
    end
  end

  describe '#boolean_badge' do
    it 'returns a badge with the text "Yes" and a class of "bg-primary" if the parameter is true' do
      expect(helper.boolean_badge(true)).to include('Yes')
      expect(helper.boolean_badge(true)).to include('bg-primary')
    end

    it 'returns a badge with the text "No" and a class of "bg-secondary" if the parameter is false' do
      expect(helper.boolean_badge(false)).to include('No')
      expect(helper.boolean_badge(false)).to include('bg-secondary')
    end
  end

  describe '#options_for_site_theme_path' do
    it 'returns an array of directory names under app/themes except shared' do
      Dir.mktmpdir('test_themes') do |dir|
        Dir.mkdir(File.join(dir, 'theme_one'))
        Dir.mkdir(File.join(dir, 'theme_two'))
        Dir.mkdir(File.join(dir, 'shared'))

        allow(Rails.root).to receive(:join).with('app/themes').and_return(Pathname.new(dir))

        expect(helper.options_for_site_theme_path).to match_array(%w[theme_one theme_two])
      end
    end
  end

  describe '#options_for_site_page_templates' do
    it 'returns an array of file names in the templates directory for a theme except 404' do
      site = create(:site, theme_path: 'test_theme')

      Dir.mktmpdir('test_theme') do |dir|
        templates_dir = File.join(dir, 'templates')
        Dir.mkdir(templates_dir)

        FileUtils.touch(File.join(templates_dir, 'home.html.erb'))
        FileUtils.touch(File.join(templates_dir, 'about.html.erb'))
        FileUtils.touch(File.join(templates_dir, '404.html.erb'))

        allow(Rails.root).to receive(:join).with('app', 'themes', site.theme_path, 'templates').and_return(Pathname.new(templates_dir))

        expect(helper.options_for_site_page_templates(site)).to match_array(%w[about home])
      end
    end

    it 'returns an empty array if site is nil' do
      expect(helper.options_for_site_page_templates(nil)).to eq([])
    end
  end

  describe '#avails_website_title_link' do
    it 'returns nil if the avails_title_id for the instance is blank' do
      instance = create(:landing_page, avails_title_id: nil)
      expect(helper.avails_website_title_link(instance)).to be_nil
    end

    it 'returns a link to the website title ID on Avails' do
      instance = create(:landing_page, avails_title_id: 123)
      expect(helper.avails_website_title_link(instance)).to have_link(href: 'https://avails.mpimediagroup.com/admin/website_titles/123')
    end

    it 'sets the link text to the full name in the instance metadata if it exists' do
      metadata = { full_name: 'My movie title' }
      instance = create(:landing_page, avails_title_id: 123, metadata: metadata)
      expect(helper.avails_website_title_link(instance)).to have_link('My movie title')
    end

    it 'sets the link text to the website title ID if the instance metadata does not have the full name' do
      instance = create(:landing_page, avails_title_id: 123, metadata: {})
      expect(helper.avails_website_title_link(instance)).to have_link('Title 123')
    end
  end

  describe '#page_template_check' do
    let(:validator_class) { class_double(template_validator_class).as_stubbed_const }

    it 'raises an ArgumentError if the instance is not a SitePage or LandingPage' do
      site = create(:site)

      expect { helper.page_template_check(site) }.to raise_error(ArgumentError)
    end

    context 'when instance is a SitePage' do
      let(:site) { create(:site, theme_path: 'dark_sky_films') }
      let(:site_page) { create(:site_page, site: site, template: 'movie') }
      let(:template_validator_class) { 'TemplateValidator::DarkSkyFilms::MovieValidator' }

      it 'returns only the instance template if the instance does not have a template validator' do
        expect(helper.page_template_check(site_page)).to eq(site_page.template)
      end

      it 'returns only the instance template if the instance template validator is valid' do
        validator = instance_double(validator_class, valid?: true, errors: [])
        allow(site_page).to receive(:template_validator).and_return(validator)

        expect(helper.page_template_check(site_page)).to eq(site_page.template)
      end

      it 'returns the instance template and a warning icon if the instance template validator is not valid' do
        validator = instance_double(validator_class, valid?: false, errors: ['full name is missing'])
        allow(site_page).to receive(:template_validator).and_return(validator)

        expect(helper.page_template_check(site_page)).to include(site_page.template)
        expect(helper.page_template_check(site_page)).to include(/<i/)
      end
    end

    context 'when instance is a LandingPage' do
      let(:landing_page) { create(:landing_page, theme_path: 'devs_die_slowly') }
      let(:template_validator_class) { 'TemplateValidator::DevsDieSlowlyValidator' }

      it 'returns only the instance theme path if the instance does not have a template validator' do
        expect(helper.page_template_check(landing_page)).to eq(landing_page.theme_path)
      end

      it 'returns only the instance theme path if the instance template validator is valid' do
        validator = instance_double(validator_class, valid?: true, errors: [])
        allow(landing_page).to receive(:template_validator).and_return(validator)

        expect(helper.page_template_check(landing_page)).to eq(landing_page.theme_path)
      end

      it 'returns the instance theme path and a warning icon if the instance template validator is not valid' do
        validator = instance_double(validator_class, valid?: false, errors: ['full name is missing'])
        allow(landing_page).to receive(:template_validator).and_return(validator)

        expect(helper.page_template_check(landing_page)).to include(landing_page.theme_path)
        expect(helper.page_template_check(landing_page)).to include(/<i/)
      end
    end
  end

  describe '#metadata_errors' do
    let(:landing_page) { create(:landing_page, theme_path: 'devs_die_slowly') }
    let(:template_validator_class) { 'TemplateValidator::DevsDieSlowlyValidator' }
    let(:validator_class) { class_double(template_validator_class).as_stubbed_const }

    it 'returns nil if the instance does not have a template validator' do
      expect(helper.metadata_errors(landing_page)).to be_nil
    end

    it 'returns nil if the instance template validator does not have any errors' do
      validator = instance_double(template_validator_class, valid?: true, errors: [])
      allow(landing_page).to receive(:template_validator).and_return(validator)

      expect(helper.metadata_errors(landing_page)).to be_nil
    end

    it 'returns the validation errors if the instance template validator has any errors' do
      validator = instance_double(template_validator_class, valid?: false, errors: ['full name is missing', 'hero image is missing'])
      allow(landing_page).to receive(:template_validator).and_return(validator)

      expect(helper.metadata_errors(landing_page)).to eq(validator.errors)
    end
  end

  describe '#landing_page_domains' do
    it 'raises an ArgumentError if the instance is not a LandingPage' do
      site = create(:site)

      expect { helper.landing_page_domains(site) }.to raise_error(ArgumentError)
    end

    it 'returns a list of the landing page domain names with links if the page is published' do
      landing_page = create(:landing_page, published: true)
      domain_name_1, domain_name_2 = create_list(:domain_name, 2, domainable: landing_page)

      expect(helper.landing_page_domains(landing_page)).to include(domain_name_1.name, domain_name_2.name)
      expect(helper.landing_page_domains(landing_page)).to have_link(domain_name_1.name, href: "https://#{domain_name_1.name}")
      expect(helper.landing_page_domains(landing_page)).to have_link(domain_name_2.name, href: "https://#{domain_name_2.name}")
    end

    it 'returns a list of the landing page domain names without links if the page is not published' do
      landing_page = create(:landing_page, published: false)
      domain_name_1, domain_name_2 = create_list(:domain_name, 2, domainable: landing_page)

      expect(helper.landing_page_domains(landing_page)).to include(domain_name_1.name, domain_name_2.name)
      expect(helper.landing_page_domains(landing_page)).to_not have_link(domain_name_1.name)
      expect(helper.landing_page_domains(landing_page)).to_not have_link(domain_name_2.name)
    end
  end
end
