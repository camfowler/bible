module Bible
  class Scripture
    attr_accessor :row
    # [1, "Genesis", 1, 1, "In the beginning God created the heavens and the earth."]
    def initialize(row)
      self.row = row
    end

    def rowid
      row[0]
    end

    def name
      "#{book} #{chapter}:#{verse}"
    end

    def header
      "#{book} #{chapter}"
    end

    def short_name
      "#{Abbreviation.shorten book}#{chapter}:#{verse}"
    end

    def content_with_header
<<VERSE

#{header}

#{content}
VERSE
    end

    def book
      row[1]
    end

    def chapter
      row[2]
    end

    def verse
      row[3]
    end

    def content
      row[4]
    end
  end
end
