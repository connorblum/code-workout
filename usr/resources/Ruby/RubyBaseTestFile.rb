require_relative '%{class_name}'
require 'test/unit'

class %{class_name}Test < Test::Unit::TestCase
  @@results_file=File.join(File.expand_path(File.dirname(__FILE__)), "results.csv")
  @@f = File.open(@@results_file, "w")
  @@subject = %{class_name}.new()

  def setup
    @@f.close unless @@f.closed?
    @@f = File.open(@@results_file, "a")
  end

  def teardown
    assertion_failed = "null"
    message = "null"
    if not passed?
      if @_result.errors.any?
        error = @_result.errors.last
        assertion_failed = error.exception.class.to_s
        message = error.exception.to_s
        message.sub!(/ for #<.*>$/,'')
      end
      if @_result.failures.any?
        assertion_failed = "AssertionFailedError"
        message = @_result.failures.last.user_message
        if message.nil? || message.empty?
          message = "expected:<#{@_result.failures.last.expected}> but was:<#{@_result.failures.last.actual}>"
        end
      end
    end
    @@f.write "/attempt,%{class_name}Test,#{method_name},0,0,#{assertion_failed},#{message},#{passed? ? 1 : 0}\n"
    @@f.close
  end

%{tests}
end
