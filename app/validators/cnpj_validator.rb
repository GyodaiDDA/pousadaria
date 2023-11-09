class CnpjValidator < ActiveModel::Validator
  def validate(record)
    @cnpj = record.vat_number.scan(/\d/).map!(&:to_i)
    return false unless fourteen_digits(@cnpj, record)
    return false unless valid_cnpj(record)

    true
  end

  def valid_cnpj(record)
    return if verifying_digit(12) == @cnpj[12] && verifying_digit(13) == @cnpj[13]

    record.errors.add(:base, 'CNPJ inválido')
  end

  def fourteen_digits(cnpj, record)
    return if cnpj.size == 14

    record.errors.add(:base, 'CNPJ não tem 14 dígitos')
  end

  def multiplier(cnpj, num)
    sequencia = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].last(num)
    cnpj.first(num).each_with_index.map do |digito, index|
      sequencia[index] * digito
    end.sum
  end

  def verifying_digit(num)
    soma = multiplier(@cnpj, num)
    if soma % 11 < 2
      0
    else
      11 - (soma % 11)
    end
  end
end
