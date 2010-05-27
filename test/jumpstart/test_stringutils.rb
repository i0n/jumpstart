require 'helper'

class TestJumpstartStringTools < Test::Unit::TestCase
    
  context "Tests for JumpStart::StringTools instance methods." do

    setup do
      @string = "hello"
    end

    context "Test for JumpStart::StringTools#red instance method." do
      should "alter string to add red colour code and reset back to normal at the end." do
        assert_equal "\e[31mhello\e[0m" , @string.red
      end
    end

    context "Test for JumpStart::StringTools#red_bold instance method." do
      should "alter string to add red_bold colour code and reset back to normal at the end." do
        assert_equal "\e[1m\e[31mhello\e[0m" , @string.red_bold
      end
    end

    context "Test for JumpStart::StringTools#green instance method." do
      should "alter string to add green colour code and reset back to normal at the end." do
        assert_equal "\e[32mhello\e[0m" , @string.green
      end
    end
    
    context "Test for JumpStart::StringTools#green_bold instance method." do
      should "alter string to add green_bold colour code and reset back to normal at the end." do
        assert_equal "\e[1m\e[32mhello\e[0m" , @string.green_bold
      end
    end
    
    context "Test for JumpStart::StringTools#yellow instance method." do
      should "alter string to add yellow colour code and reset back to normal at the end." do
        assert_equal "\e[1m\e[33mhello\e[0m" , @string.yellow
      end
    end
    
    context "Test for JumpStart::StringTools#blue instance method." do
      should "alter string to add blue colour code and reset back to normal at the end." do
        assert_equal "\e[34mhello\e[0m" , @string.blue
      end
    end
    
    context "Test for JumpStart::StringTools#blue_bold instance method." do
      should "alter string to add blue_bold colour code and reset back to normal at the end." do
        assert_equal "\e[1m\e[34mhello\e[0m" , @string.blue_bold
      end
    end
    
    context "Test for JumpStart::StringTools#purple instance method." do
      should "alter string to add purple colour code and reset back to normal at the end." do
        assert_equal "\e[1m\e[35mhello\e[0m" , @string.purple
      end
    end
    
    context "Test for JumpStart::StringTools#colourise instance method." do
      should "insert colour_code value before text and then end with reset output." do
        assert_equal "blue_colour_code hello\e[0m", @string.colourise(@string, "blue_colour_code ")
      end
    end

  end
  
end