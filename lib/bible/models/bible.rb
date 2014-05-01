require 'sqlite3'

module Bible
  class Bible
    attr_accessor :version, :db, :current_scripture, :search_results, :direction

    def initialize version, db_file
      self.version = version
      self.db = SQLite3::Database.new db_file
      db.execute("SELECT ROWID, * FROM verses LIMIT 1") do |row|
        self.current_scripture = Scripture.new row
      end
      self.direction = '>'
    end

    def next_scripture!
      next_rowid = current_scripture.rowid + direction_increment
      db.execute("SELECT ROWID, * FROM verses WHERE ROWID=? LIMIT 1", next_rowid) do |row|
        self.current_scripture = Scripture.new row
      end
    end

    def reading
      if current_scripture.verse == "1"
        current_scripture.content_with_header
      else
        current_scripture.content
      end
    end

    def search query
      self.search_results = []
      db.execute("SELECT ROWID, * FROM verses WHERE content MATCH ?", query) do |row|
        self.search_results.push Scripture.new(row)
      end
      search_results.count
    end

    def set_position_to reference
      #keep the current context
      unless reference[:book].nil?
        reference[:chapter] ||= current_scripture.chapter
      end
      reference[:book] ||= current_scripture.book

      # remove nils
      reference.delete_if { |k, v| v.nil? }

      query_string = []
      if reference[:book]
        query_string.push "book = :book"
      end
      if reference[:chapter]
        query_string.push "chapter = :chapter"
      end
      if reference[:verse]
        query_string.push "verse = :verse"
      end
      query_string = query_string.join " AND "
      row = db.get_first_row("SELECT ROWID, * FROM verses WHERE #{query_string} LIMIT 1", reference)

      if row
        self.current_scripture = Scripture.new row
        return self.current_scripture
      else
        return nil
      end
    end

    def book
      current_scripture.book
    end

    def chapter
      current_scripture.chapter
    end

    def verse
      current_scripture.verse
    end

    private

    def direction_increment
      direction == '>' ? 1 : -1
    end
  end
end
