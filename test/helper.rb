require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'jumpstart'

class Test::Unit::TestCase

end

module JumpStart
  
  class Base
        
  end
  
  module FileTools
    
  end
  
end