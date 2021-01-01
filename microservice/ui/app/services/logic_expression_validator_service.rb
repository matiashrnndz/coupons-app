class LogicExpressionValidatorService
  attr_accessor :calculator

  def initialize
    @calculator = Dentaku::Calculator.new
  end

  def validate_logic_structure(record_attributes, logic_expression)
    aux_exp = logic_expression
    record_attributes.each do |rec_attr|
      aux_exp = aux_exp.gsub(rec_attr.strip, '1')
    end
    !calculator.evaluate(aux_exp).nil?
  rescue StandardError
    nil
  end

  def validate_logic_expression(logic_expression)
    calculator.evaluate(logic_expression)
  rescue StandardError
    nil
  end
end
