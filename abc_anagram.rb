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