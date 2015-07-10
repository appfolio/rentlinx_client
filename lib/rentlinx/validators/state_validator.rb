module Rentlinx
  class StateValidator < BaseValidator
    STATES = %w(AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI
                MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX
                UT VT VA WA WV WI WY AS DC GU MP PR VI)

    private

    def validate
      return if @value.nil? || @value == '' || (@value.size == 2 && STATES.include?(@value.upcase))
      @error = "#{@value} is not a valid state, states must be two characters (CA)"
    end
  end
end
