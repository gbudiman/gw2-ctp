class Scrapper
	attr_accessor :scrap_result

	def initialize
		@mechanize = Mechanize.new
		@scrap_result = Hash.new
		@config = TextLoader::load_file 'lib/assets/config.txt'
		@last_access = nil
	end

	def login_to _site
		case _site
		when :gw2
			@mechanize.get @config[:gw2_login_page] do |page|
				page.form_with do |form|
					form.email = @config[:gw2_email]
					form.password = @config[:gw2_password]
				end.click_button

				break
			end
		end

		@last_access = _site

		return self
	end

	def scrap_data _site = @last_access
		case @last_access
		when :gw2
			@mechanize.get @config[:gw2_authentication_page]
			@scrap_result[_site] = JSON.parse(
				@mechanize.get(@config[:gw2_search_string]).body)['results']
		when :gw2db
			@scrap_result[_site] = JSON.parse(
				@mechanize.get(@config[_site]).body)
		end
	end
end
