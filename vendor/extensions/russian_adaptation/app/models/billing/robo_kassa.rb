require "active_merchant/billing/gateways/robo_kassa"

class Billing::RoboKassa < BillingIntegration
  preference :login, :string
  preference :password1, :password  
  preference :password2, :password
  preference :payment_currency, :string, :default => "WMR"
  
  validates_uniqueness_of :type, :environment, :active
  
  def provider_class
    ActiveMerchant::Billing::RoboKassaGateway
  end
    
  def self.current
    self.first(:conditions => {:type => self.to_s, :environment => Rails.env, :active => true})
  end
end
