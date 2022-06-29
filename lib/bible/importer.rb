require 'nokogiri'
require 'sqlite3'

module Bible
  class Importer
    attr_accessor :file_path, :version_name, :bible_xml, :books, :chapters, :verses

    def initialize(file_path, version_name)
      self.file_path = file_path
      self.version_name = version_name
    end

    def start
      load_xml_file
      parse_bible_xml
      load_data_into_sqlite3_db
    end

    private

    def load_xml_file
      self.bible_xml = IO.read(file_path)
      true
    end

    def parse_bible_xml
      bible = Nokogiri::XML(bible_xml)

      # parse_books(bible)
      # parse_chapters(bible)
      parse_verses(bible)
      true
    end

    # def parse_books(bible)
    #   self.books = bible.xpath('//bible/book').collect do |book|
    #     book_name = name_attr_of(book)
    #     { type: 'book', name: book_name }
    #   end
    # end

    # def parse_chapters(bible)
    #   self.chapters = bible.xpath('//bible/book/chapter').collect do |chapter|
    #     book_name = name_attr_of(chapter.parent)
    #     chapter_number = name_attr_of(chapter)
    #     { type: 'chapter', book: book_name, chapter: chapter_number }
    #   end
    # end

    def parse_verses(bible)
      self.verses = bible.xpath('//bible/book/chapter/verse').collect do |verse|
        book_name = name_attr_of(verse.parent.parent)
        chapter_number = name_attr_of(verse.parent)
        verse_number = name_attr_of(verse)
        { book: book_name, chapter: chapter_number, verse: verse_number, content: verse.content }
      end
    end

    def name_attr_of(node)
      node.attribute('name').to_s
    end

    def load_data_into_sqlite3_db
      # db_file = File.expand_path(File.join(File.dirname(__FILE__), "../../db/", "#{version_name}.db"))
      # Dir.mkdir '~/.bibles'
      db_file = File.expand_path(File.join("~/.bibles", "#{version_name}.db"))
      File.delete(db_file) if File.exists?(db_file)
      db = SQLite3::Database.new(db_file)

      db.execute <<-SQL
        CREATE VIRTUAL TABLE verses USING fts4(
          book string,
          chapter integer,
          verse integer,
          content string
        );
      SQL

      verses.each do |verse|
        db.execute("INSERT INTO verses VALUES (?, ?, ?, ?)",
                   [verse[:book], verse[:chapter], verse[:verse], verse[:content]])
      end

      db.execute("SELECT ROWID, * FROM verses LIMIT 1") do |row|
        p row
      end
    end
  end
end

