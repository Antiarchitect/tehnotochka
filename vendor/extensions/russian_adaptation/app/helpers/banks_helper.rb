module BanksHelper  
  def payment_details(pd)
    out = []
    out << pd[:beneficiary_name]
    out << ("#{I18n::t("beneficiary_code")} #{pd[:beneficiary_code]}" << (pd[:beneficiary_code2].blank? ? '': " / #{I18n::t("beneficiary_code2")} #{pd[:beneficiary_code2]}"))
    unless pd[:correspondent_account].blank?
      out << ("#{I18n::t("correspondent_account")} #{pd[:correspondent_account]}" << (pd[:correspondent_bank_name].blank? ? '' : " в #{pd[:correspondent_bank_name]}") << (pd[:correspondent_bank_address].blank? ? '' : " (#{pd[:correspondent_bank_address]})"))
      out << "#{I18n::t("correspondent_bank_code")} #{pd[:correspondent_bank_code]}"
    end
    out << ("#{I18n::t("beneficiary_account")} #{pd[:beneficiary_account]} в #{pd[:beneficiary_bank_name]}" << (pd[:beneficiary_bank_address].blank? ? '' : " (#{pd[:beneficiary_bank_address]})"))
    out << "#{I18n::t("beneficiary_bank_code")} #{pd[:beneficiary_bank_code]}"
    out.join('<br />')
  end
  
  def payer_name(payer)
    [payer.lastname, payer.firstname, payer.secondname].join(' ')
  end

  def payer_address(payer)
    [payer.zipcode, payer.country, payer.state, payer.city, payer.address1, payer.address2].join(', ')
  end
end
