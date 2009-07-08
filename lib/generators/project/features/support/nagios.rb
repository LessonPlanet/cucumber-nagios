module Nagios
  class NagiosFormatter < Cucumber::Ast::Visitor
    def initialize(step_mother, io, options={})
      super(step_mother)
      @failed  = []
      @passed  = []
      @warning = []
    end

    def visit_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
      super
      case status
        when :passed
          @passed << step_match
        when :failed
          @failed << step_match
        when :undefined
          @warning << step_match
      end
    end

    def visit_steps(steps)
      super
      print_summary
    end

    private
    def print_summary
      @total = @failed.size + @passed.size + @warning.size
      message = ""
      message += "Critical: #{@failed.size}, "
      message += "Warning: #{@warning.size}, "
      message += "#{@passed.size} okay"
      # nagios performance data
      message += " | passed=#{@passed.size}"
      message += ", failed=#{@failed.size}"
      message += ", nosteps=#{@warning.size}"
      message += ", total=#{@total}"
      puts message
    end
  end
end

