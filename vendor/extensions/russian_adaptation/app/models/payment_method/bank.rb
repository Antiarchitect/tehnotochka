class PaymentMethod::Bank < PaymentMethod
  preference :beneficiary_name, :string
  preference :beneficiary_code, :string # ОКПО или ИНН
  preference :beneficiary_code2, :string # КПП для РФ
  preference :beneficiary_account, :string
  preference :beneficiary_bank_name, :string
  preference :beneficiary_bank_address, :string
  preference :beneficiary_bank_code, :string # МФО, БИК, SWIFT
  preference :correspondent_account, :string # Для РФ и SWIFT
  preference :correspondent_bank_name, :string
  preference :correspondent_bank_address, :string
  preference :correspondent_bank_code, :string
end