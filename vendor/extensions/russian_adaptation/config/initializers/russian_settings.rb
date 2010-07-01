begin
  RUSSIAN_SETTINGS = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml'))
rescue
  RUSSIAN_SETTINGS = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'settings.yml.example'))
end

Time.zone = RUSSIAN_SETTINGS['country']['timezone']
I18n.default_locale = :'ru-RU'
locale = File.join(File.dirname(__FILE__), '..', 'locales', RUSSIAN_SETTINGS['country']['id'], 'ru-RU_extend.yml')
I18n.load_path << locale if File.exists?(locale) and !I18n.load_path.include?(locale)

if Spree::Config.instance
  Spree::Config.set(:default_locale => :'ru-RU')
  Spree::Config.set(:default_country_id => RUSSIAN_SETTINGS['country']['id'])
  Spree::Config.set(:auto_capture => false)
  Spree::Config.set(:ship_form_requires_state => true)
  Spree::Config.set(:show_currency_with_kopek => RUSSIAN_SETTINGS['finance']['show_currency_with_kopek'])
  Spree::Config.set(:show_currency_with_zero_kopek => RUSSIAN_SETTINGS['finance']['show_currency_with_zero_kopek'])
end
