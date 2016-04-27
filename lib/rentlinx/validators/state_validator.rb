module Rentlinx
  # Validator for two letter state codes
  #
  # Contains a list of all the states Rentlinx permits
  class StateValidator < BaseValidator
    STATES = %w(AK AL AR AS AZ CA CO CT DC DE FL GA GU HI IA ID IL IN KS KY LA
                MA MD ME MI MN MO MP MS MT NC ND NE NH NJ NM NV NY OH OK OR PA
                PR RI SC SD TN TX UT VA VI VT WA WI WV WY).freeze

    private

    def validate
      return if @value.nil? || @value == '' || (@value.size == 2 && STATES.include?(@value.upcase))
      @error = "#{@value} is not a valid state, states must be two characters (CA)"
    end
  end
end
