#! /usr/bin/ruby

##
# Parse a list of string with the following format:
# [
#   "1) Умный - clever",
#   "2) глУпый - stupid",
#   "3) Я бы хотел - I would like",
# }
#
# into a csv with a bit of html to make the stress of the word blue the idea of
# this is to then just redirect this into a file and upload that csv to anki
#
# clever,<span style='color: blue;'>у</span>мный
# stupid,гл<span style='color: blue;'>у</span>пый
# I would like,<span style='color: blue;'>я</span> бы хотел
#
def parse_data(entries)
    parsed = []
    entries.each do |entry|
        russian, english = entry.split '-'

        # remove '1) '
        russian = russian.gsub(/(\d*\) )/, '')
        # get the capital letter to see the stress of the word
        begin
            stress_in_word = russian[/[А-ЯЁ]/].downcase
            # replace the capital letter in the word to add it as blue in anki
            russian = russian.gsub(
                /([А-Я])/, %(<span style='color: blue;'>#{stress_in_word}<\/span>)
            )
        rescue NoMethodError
            russian = russian.gsub(/(\d*\) )/, '')
        end

        # remove first space from english part
        english = english.gsub(/^\s/, '')

        parsed.push("#{english},#{russian}")
    end
    parsed
end

def load_file(filename)
    entries = []
    File.foreach(filename) do |entry|
        # chomp removes \n
        entries.push(entry.chomp)
    end
    entries
end

filename = ARGV[0]
unless filename
    puts 'ERROR: you are supposed to send a file'
    puts "#{File.basename(__FILE__)} <your file>"
    exit
end

entries = load_file filename
puts parse_data(entries)
