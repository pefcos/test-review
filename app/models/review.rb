class Review < ApplicationRecord
  belongs_to :listing

  def count_word_frequencies(string)
    words = string.split(' ')
    frequency = Hash.new(0)
    words.each { |word| frequency[word.downcase] += 1 }
    frequency
  end
end
