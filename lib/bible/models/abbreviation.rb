# require 'fuzzy_match'

module Bible
  class Abbreviation
    def self.shorten reference
      ABBREVIATIONS[reference]
    end

    def self.lengthen reference
      case reference
      when /^(?<verse>\d+)$/
        {book: nil, chapter: nil, verse: $~[:verse]}
      when /^(?<chapter>\d+):(?<verse>\d+)$/
        {book: nil, chapter: $~[:chapter], verse: $~[:verse]}
      when /^(?<verse_start>\d+)-(?<verse_end>\d+)$/
        {book: nil, chapter: $~[:chapter], verse_range: [$~[:verse_start], $~[:verse_end]]}
        "ranges not supported yet"
      when /^(?<book>\d?\D+)(?<chapter>\d+)?(:(?<verse>\d+)(-(?<range>\d+))?)?$/
        {book: FuzzyMatch.new(ABBREVIATIONS.keys).find($~[:book]),
         chapter: $~[:chapter]||'1',
         verse: $~[:verse]||'1'}
      else
        {book: nil, chapter: nil, verse: nil}
      end
    end

    ABBREVIATIONS = {
      'Acts' => 'Ac',
      'Amos' => 'Am',
      '1 Chronicles' => '1Ch',
      '2 Chronicles' => '2Ch',
      'Colossians' => 'Cl',
      '1 Corinthians' => '1Co',
      '2 Corinthians' => '2Co',
      'Daniel' => 'Da',
      'Deuteronomy' => 'De',
      'Ecclesiastes' => 'Ec',
      'Ephesians' => 'Ep',
      'Ezra' => 'Er',
      'Esther' => 'Es',
      'Exodos' => 'Ex',
      'Ezekiel' => 'Ez',
      'Galatians' => 'Ga',
      'Genesis' => 'Ge',
      'Habakkuk' => 'Hb',
      'Hebrews' => 'He',
      'Haggai' => 'Hg',
      'Hosea' => 'Ho',
      'Isaiah' => 'Is',
      'James' => 'Ja',
      'Job' => 'Jb',
      'Jude' => 'Jd',
      'Jeremiah' => 'Je',
      'Judges' => 'Jg',
      'Joel' => 'Jl',
      'John' => 'Jn',
      '1 John' => '1Jn',
      '2 John' => '2Jn',
      '3 John' => '3Jn',
      'Jonah' => 'Jo',
      'Joshua' => 'Js',
      '1 Kings' => '1Ki',
      '2 Kings' => '2Ki',
      'Leviticus' => 'Le',
      'Luke' => 'Lk',
      'Lamentations' => 'La',
      'Malachi' => 'Ma',
      'Micah' => 'Mi',
      'Mark' => 'Mk',
      'Matthew' => 'Mt',
      'Nahum' => 'Na',
      'Nehemiah' => 'Ne',
      'Numbers' => 'Nu',
      'Obadiah' => 'Ob',
      '1 Peter' => '1Pe',
      '2 Peter' => '2Pe',
      'Philippians' => 'Ph',
      'Philemon' => 'Pm',
      'Proverbs' => 'Pr',
      'Psalms' => 'Ps',
      'Revelation' => 'Re',
      'Romans' => 'Ro',
      'Ruth' => 'Ru',
      '1 Samuel' => '1Sa',
      '2 Samuel' => '2Sa',
      'Song of Solomon' => 'So',
      '1 Thessalonians' => '1Th',
      '2 Thessalonians' => '2Th',
      '1 Timothy' => '1Tm',
      '2 Timothy' => '2Tm',
      'Titus' => 'Tt',
      'Zechariah' => 'Ze',
      'Zephaniah' => 'Zp'
    }
  end
end
