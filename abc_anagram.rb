# solution to http://www.codewars.com/kata/53e57dada0cb0400ba000688
# Challenge text:
# Consider a "word" as any sequence of capital letters A-Z (not limited to just "dictionary words"). For any word with at least two different letters, there are other words composed of the same letters but in a different order (for instance, STATIONARILY/ANTIROYALIST, which happen to both be dictionary words; for our purposes "AAIILNORSTTY" is also a "word" composed of the same letters as these two).
#
# We can then assign a number to every word, based on where it falls in an alphabetically sorted list of all words made up of the same set of letters. One way to do this would be to generate the entire list of words and find the desired one, but this would be slow if the word is long.
#
# Given a word, return its number. Your function should be able to accept any word 25 letters or less in length (possibly with some letters repeated), and take no more than 500 milliseconds to run. To compare, when the solution code runs the 27 test cases in JS, it takes 101ms.

def listPosition
  word = gets.chomp
  sorted_char_arr = word.chars.sort
  abc_rank = 1
  
  word.chars.each do |c|
    # Count of minimum alphabetically smaller permutations at given position including transposed non-unique letters
    smaller_perms = sorted_char_arr.find_index(c) * (sorted_char_arr.length - 1).safe_factorial
    
    # Remove non-unique permutations
    unique_smaller_perms = smaller_perms / sorted_char_arr.uniq.map { |d| sorted_char_arr.count(d).safe_factorial }.reduce(:*)
    
    abc_rank += unique_smaller_perms
    sorted_char_arr.delete_at(sorted_char_arr.index(c) || sorted_char_arr.length)
  end
  puts abc_rank
end

class Fixnum
  def safe_factorial
    (1..self).reduce(:*) || 1
  end
end

listPosition