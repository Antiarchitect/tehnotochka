# encoding: utf-8
# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class RussianAdaptationExtension < Spree::Extension
  version "1.0"
  description "Adapts Spree to the Russian reality."
  url "http://github.com/romul/spree-russian-adaptation"

  # Please use russian_adaptation/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem 'russian'
    # config.gem 'rutils'
    config.gem 'prawn'
  end

  def activate
    
    Time::DATE_FORMATS[:date_time24] = "%d.%m.%Y - %H:%M"
    Time::DATE_FORMATS[:short_date] = "%d.%m.%Y"
        
    # replace .to_url method provided by stringx gem by .parameterize provided by russian gem
    String.class_eval do
      def to_url
        self.parameterize
      end
   	end
   	
    [PaymentMethod::Cash, PaymentMethod::Bank, Billing::RoboKassa].each {|m| m.register}
    
    Checkout.class_eval do
      validation_group :address, :fields=> [
      "ship_address.firstname", "ship_address.lastname", "ship_address.phone", 
      "ship_address.zipcode", "ship_address.state", "ship_address.lastname", 
      "ship_address.address1", "ship_address.city", "ship_address.statename", 
      "ship_address.zipcode", "ship_address.secondname"]
  
      def bill_address
        ship_address || Address.default
      end
    end
    
    OrderMailer.class_eval do
      default_url_options[:host] = Spree::Config[:site_url]
    end
    
    OrdersController.class_eval do
      helper BanksHelper
      before_filter :fetch_payment_details, :only => [:receipt, :invoice]
      
      def receipt
        render :layout => false
      end
      def invoice
        render :layout => false
      end
      
      private
      def fetch_payment_details
        payment = @order.checkout.payments.detect{|p| p.payment_method.type.to_s == "PaymentMethod::Bank"} || @order.payments.detect{|p| p.payment_method.type.to_s == "PaymentMethod::Bank"}
        @pd = payment.payment_method.preferences.symbolize_keys!        
      end
    end
    
    Admin::OrdersController.class_eval do
      def waybill
        load_object
      end
      def cash_memo
        load_object
      end
    end
    
    AppConfiguration.class_eval do
      preference :show_currency_with_kopek, :boolean
      preference :show_currency_with_zero_kopek, :boolean
    end

    ApplicationHelper.module_eval do
      def number_to_currency(number, options = {})
        options.symbolize_keys!
        with_kopek = options.delete(:with_kopek) || Spree::Config[:show_currency_with_kopek]
        if I18n.locale == I18n.default_locale and with_kopek
          with_zero_kopek = options.delete(:with_zero_kopek) || Spree::Config[:show_currency_with_zero_kopek]
          if (number - number.floor).zero? and !with_zero_kopek
            options.merge!(:precision => 0) # нет копеек
          else
            options.merge!(:format => "%n коп.", :separator => " %u ") # есть копейки
          end
        end
        super(number, options) 
      end
    end
    
    Admin::BaseHelper.module_eval do 
      def text_area(object_name, method, options = {})
        begin
          ckeditor_textarea(object_name, method, :width => '100%', :height => '350px')
        rescue
          super
        end
      end      
    end
    
  end
end

