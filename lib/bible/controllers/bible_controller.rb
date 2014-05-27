module Bible
  class BibleController < BaseController

    attr_accessor :bible

    def initialize(bible)
      self.bible = bible
    end

    def read_current_scripture
      @scripture = bible.current_scripture
      render :reading_verse
    end

    def goto_next_scripture
      bible.next_scripture!
      @scripture = bible.current_scripture
      render :reading_verse
    end

    def search query
      @result_count = bible.search query
      render :search
    end

    def list_results
      @results = bible.search_results
      render :list_results
    end

    def view_results
      @search_results = bible.search_results
      bible.current_scripture = @search_results.last
      render :view_results
    end

    def set_direction direction
      if direction == :forward
        bible.direction = '>'
      else
        bible.direction = '<'
      end
      goto_next_scripture
    end

    def goto fuzzy_references
      fuzzy_references.gsub! /(\s*,+\s*)+/, ','
      split_references = fuzzy_references.split(',').compact
      @scriptures = split_references.collect do |reference|
        if bible.set_position_to(Abbreviation.lengthen reference)
          bible.current_scripture
        else
          reference
        end
      end
      render :goto
    end
  end
end
