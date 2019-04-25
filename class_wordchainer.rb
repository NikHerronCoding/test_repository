require 'byebug'

class WordChainer
    attr_reader :current_words, :all_seen_words, :new_current_words
    def initialize 
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
        @current_words = []
        @new_current_words = []
        @all_seen_words = Hash.new

    end

    def adjacent_words(word)
        
     new_word = word.dup
        output = Array.new
        i = 0
        j = 0
        until i == word.length
           
           new_word = word_incrementer(new_word, i)
           if @dictionary.include?(new_word) && new_word != word
            output << new_word.dup 
           end
            
            i +=  1 if j == 25 
            j =  ((j + 1) % 26)
        
        end
        output

    end

    def word_incrementer(word, word_idx)
        new_word = word.dup
        alphabet = ("a".."z").to_a
        new_idx = (alphabet.index(word[word_idx]) + 1) % 26
        new_word[word_idx] = alphabet[new_idx]
        new_word
    end

    def run(source, target)
        
        
        @current_words += [source.dup]
        @all_seen_words[source.dup] = nil

        until (@current_words.empty? || @all_seen_words[target])  do 
            @new_current_words = []
           explore_current_words
            @new_current_words.each do |new_current_word|
                print "  Word: #{new_current_word} Parent: #{@all_seen_words[new_current_word]}  "
            end
puts
            @current_words = @new_current_words

        end

        build_path(source, target)
    end

    def explore_current_words
          @current_words.each do |current_word|
                adjacent_words = []
                adjacent_words = adjacent_words(current_word)
                adjacent_words.each do |adjacent_word|
                    unless @all_seen_words.include?(adjacent_word)
                        @new_current_words << adjacent_word
                        @all_seen_words[adjacent_word] = current_word
                    end
                end
            end
    end

    def build_path(source, target)
        
        return [] if @all_seen_words[source] == target
    
        
        parent = @all_seen_words[target]

        build_path(source, parent) + [target]
    end


end