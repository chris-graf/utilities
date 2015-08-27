# U2.W6: Create a Bingo Scorer (SOLO CHALLENGE)

# I spent [#] hours on this challenge.

# Pseudocode





# sample boards

horizontal = [[47, 44, 71, 8, 88],
              ['x', 'x', 'x', 'x', 'x'],
              [83, 85, 97, 89, 57],
              [25, 31, 96, 68, 51],
              [75, 70, 54, 80, 83]]

vertical = [[47, 44, 71, 'x', 88],
            [22, 69, 75, 'x', 73],
            [83, 85, 97, 'x', 57],
            [25, 31, 96, 'x', 51],
            [75, 70, 54, 'x', 83]]


right_to_left = [['x', 44, 71, 8, 88],
                 [22, 'x', 75, 65, 73],
                 [83, 85, 'x', 89, 57],
                 [25, 31, 96, 'x', 51],
                 [75, 70, 54, 80, 'x']]


left_to_right = [[47, 44, 71, 8, 'x'],
                  [22, 69, 75, 'x', 73],
                  [83, 85, 'x', 89, 57],
                  [25, 'x', 96, 68, 51],
                  ['x', 70, 54, 80, 83]]

big_board_horizontal = [[47, 44, 71, 8, 88],
                        ['x', 'x', 'x', 'x', 'x'],
                        [83, 85, 97, 89, 57],
                        [25, 31, 96, 68, 51],
                        [75, 70, 54, 80, 83]]

horizontal_not_winning = [[47, 44, 71, 8, 88],
              ['x', 'x', 11, 'x', 'x'],
              [83, 85, 97, 89, 57],
              [25, 31, 96, 68, 51],
              [75, 70, 54, 80, 83]]




# Initial Solution
class BingoScorer

  attr_reader :board, :max_index

  def initialize(board)
    # Not foolproof, fails to reject boards with varying row length
    raise ArgumentError.new("Board must be square") unless (board.length ** 2) == board.flatten.length
    @board = board
    @max_index = board.length - 1
  end

  def bingo?
    winning_column? || winning_row? || winning_diagonal?
  end

  def winning_column?
    (0..max_index).each do |column|
      if check_line(0, column, max_index, column) == true
        return true
      end
    end
    false
  end


  def winning_row?
    (0..max_index).each do |row|
      if check_line(row, 0, row, max_index) == true
        return true
      end
    end
    false
  end

  def winning_diagonal?
    check_line(0, 0, max_index, max_index) || check_line(0, max_index, max_index, 0)
  end

  def check_line(start_row, start_column, end_row, end_column)
    row               = start_row
    column            = start_column
    row_increment     = (end_row - start_row) / max_index
    column_increment  = (end_column - start_column) / max_index
    max_index.times do
      return false unless board[row][column] == 'x'
      row     += row_increment
      column  += column_increment
    end
    true
  end
end




# Refactored Solution

class BingoScorer

  attr_reader :board, :max_index

  def initialize(board)
    # Rewrote to reject all non-square shapes
    raise ArgumentError.new("Board must have at least 1 cell") if board.empty?
    raise ArgumentError.new("Board must be square") if board.any? { |row| row.length != board.length}
    @board = board
    @max_index = board.length - 1
  end

  def bingo?
    winning_column? || winning_row? || winning_diagonal?
  end

  def winning_column?
    (0..max_index).each do |column|
      if check_line(0, column, max_index, column) == true
        return true
      end
    end
    false
  end

  # could be rewritten without using check_line, but doing so might obscure similar purpose between methods.
  def winning_row?
    (0..max_index).each do |row|
      if check_line(row, 0, row, max_index) == true
        return true
      end
    end
    false
  end

  def winning_diagonal?
    check_line(0, 0, max_index, max_index) || check_line(0, max_index, max_index, 0)
  end

  def check_line(start_row, start_column, end_row, end_column)
    row               = start_row
    column            = start_column
    row_increment     = (end_row - start_row) / max_index
    column_increment  = (end_column - start_column) / max_index
    max_index.times do
      return false unless board[row][column] == 'x'
      row     += row_increment
      column  += column_increment
    end
    true
  end
end

# DRIVER TESTS GO BELOW THIS LINE
# implement tests for each of the methods here:

p BingoScorer.new(horizontal).bingo? == true
p BingoScorer.new(vertical).bingo? == true
p BingoScorer.new(right_to_left).bingo? == true
p BingoScorer.new(left_to_right).bingo? == true
p BingoScorer.new(big_board_horizontal).bingo? == true
p BingoScorer.new(horizontal_not_winning).bingo? == false
# p BingoScorer.new([[1, 2, 3], [4, 5, 6]]) # should raise error
# p BingoScorer.new([]) # should raise error



# Reflection
# The design principle described in POODR of limiting as much as possible what each class and method 'knows' has been massively helpful in slimming-down and designing-up my code. By following these principles, I was able to avoid using any hard-coded numbers other than 0 and 1, which let me create a class compatible with any size of board.
# Also, I retract to some extent my claim from last week that hashes are better than arrays for storing bingo boards. Array#zip would be very helpful in creating "true", random boards, and the check_line method may be more elegant when row and column are both indexes.
# The other methods still have a lot of "knowledge" about check_line. I'm not sure if this is a significant problem, since they are still all part of the same class. The three separate winning? methods are also not very DRY, particularly column and row which are almost identical.