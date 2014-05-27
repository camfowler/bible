require 'readline'
require 'word_wrap'

module Bible
  class Cli
    attr_accessor :bible, :bible_controller, :prompt

    def initialize version, db_file
      self.bible = Bible.new(version, db_file)
      self.bible_controller = BibleController.new bible
      puts "Hit '?' for help.\n"
      puts bible_controller.read_current_scripture
      set_prompt
    end

    def start
      while command = Readline.readline(prompt)
        if [nil, 'q', '?bye', '?exit', '?quit', '?q'].include? command
          puts
          break
        end
        Readline::HISTORY.push(command) unless command == ''
        run command
        set_prompt
      end
    end

    private

    def set_prompt
      self.prompt = "bible(#{bible.version}) [#{bible.current_scripture.short_name}]#{bible.direction} "
    end

    def help
<<HELP

 -Bible verse specifications:
     Verses may be specified using various standard abbreviations and
     notations, including both single verses and verse ranges.
     E.g.  Jn3:16, jn3:16,17 ps1:1-6
     Partial specs are interpreted in the context of the previous verse.
     E.g.  "Rev3:20" followed by "15" prints Rev3:15.
 -Concordance (word search) commands:
      ??word     Find all verses containing "word".
                 Creates a "ref list" for subsequent use.
      ?list      List the references in ref list.       (abbrev ?l)
      ?view      View text of verses in ref list.       (abbrev ?v)
      ?and word  Combine ref list w/MATCHING refs for "word".    (abbrev ?a)
      ?or word   Combine ref list w/ALL refs for "word".    (abbrev ?o)
      ?in <verse range>       Limit ref list to range of verses.
      ?in all    Reset ref list limit.
     To get a list of refs, each containing multiple words, start with:
      ??word     for the first word, followed by
      ?and word  for each following word.The order of the words doesn't matter.
  -A few miscellaneous program control commands.
     ?, ?h, ?help              -- Prints this help text.
     <, >                      -- Change direction through text.
     ?w file                   -- Begin writing (appending) output to "file".
     ?w                        -- Stop writing output to a file.
     ?f                        -- Toggles output formatting modes.
     q, ?bye, ?exit, ?quit, ?q -- End this program.
  Note that a blank line will advance one verse in current direction.
HELP
    end

    def run command
      case command
      when '?', '?h', '?help'
        display help
      when ''
        display bible_controller.goto_next_scripture
      when /\?\?(?<query>.*)/
        print "Searching for '#{$~[:query]}'... "
        display bible_controller.search $~[:query]
      when '?l', '?list'
        display bible_controller.list_results
      when '?v', '?view'
        display bible_controller.view_results
      when '>'
        display bible_controller.set_direction :forward
      when '<'
        display bible_controller.set_direction :backward
      else
        display bible_controller.goto command
      end
    end

    def display string
      wrapped_string = WordWrap.ww(string)
      if wrapped_string.lines.count > `tput lines`.to_i
        IO.popen("less", "w") { |f| f.puts wrapped_string }
      else
        puts wrapped_string
      end
    end
  end
end
