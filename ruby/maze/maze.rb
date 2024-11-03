require 'debug'

##
# Maze
#
# Represent a rectangular maze whose entrance is at the top row in the middle,
# and its exit is at the bottom row in the middle too.
class Maze

    attr_reader :number_columns, :number_rows
    attr_accessor :matrix

    def initialize(number_columns, number_rows)
        @number_columns = number_columns
        @number_rows = number_rows
    end

    def to_s
        puts matrix
    end


    ##
    # Return start of maze, which is always on the first row, in the middle
    def start
        Square.new(number_columns / 2, 0)
    end

    ##
    # Return exit of maze
    def end
        Square.new(number_columns / 2, number_rows - 1)
    end

    ##
    # Given a square, determine if it is has a valid position inside the maze.
    def is_valid(square)
        if square.column > number_columns or square.column < 0
            return false
        end
        if square.row > number_rows - 1 or square.row < 0
            return false
        end
        return true
    end

    ##
    # Given a square, determine if it is is a wall
    def is_wall(square)
        matrix[square.row][square.column] == '#'
    end

    ##
    # Given a square, get its neighbours
    def neighbours(square)
        neighbours = []

        up = square.up()
        if is_valid(up)
            neighbours.push(up)
        end

        down = square.down()
        if is_valid(down)
            neighbours.push(down)
        end

        left = square.left()
        if is_valid(left)
            neighbours.push(left)
        end

        right = square.right()
        if is_valid(right)
            neighbours.push(right)
        end

        neighbours
    end

    ##
    # Given a list of squares, paint it in the matrix with X
    def paint_path(path)
        # FIXME, you cannot call this function two times due to it overwriting
        # the maze? or m? not entirely sure, need to look more into it.

        # TODO make this output html
        m = matrix.clone
        puts '----------'
        path.each do |square|
            m[square.row][square.column] = 'x'
        end
        puts m
    end
end

##
# Square
#
# Represent a square in the maze.
class Square

    attr_reader :column, :row
    attr_accessor :previous

    def initialize(column, row)
        @column = column
        @row = row
    end

    def ==(other)
        self.class == other.class &&
            [column, row] == [other.column, other.row]
    end

    # needed to add this to a set
    def eql?(other)
        self.class == other.class &&
            [column, row] == [other.column, other.row]
    end

    # needed to add this to a set
    def hash
        [column, row].hash
    end

    def to_s
        "(#{column}, #{row})"
    end

    def up
        Square.new(column + 1, row)
    end

    def down
        Square.new(column - 1, row)
    end

    def right
        Square.new(column, row + 1)
    end

    def left
        Square.new(column, row - 1)
    end
end

def load_maze(filename)
    lines = File.readlines(filename).map { |line| line.chomp }

    columns, row = lines.first.split
    lines.shift # remove entry with cols and rows

    maze = Maze.new(columns.to_i, row.to_i)
    maze.matrix = lines

    maze
end

##
# Given a square, track all its previous squares.
# Return a list with all the previous squares
def get_path(square)
    path = []
    prev = square.previous
    while prev != nil
        path.push(prev)
        prev = prev.previous
    end
    path
end

##
# depth-first search
#
# over optimistic search algorithm, that hopes the next value it will look at
# is the solution.
#
# it will store start by checking a square, if its the end of the maze, it will
# return. If not it will get its neighbours and add them to a stack.
#
# for the next iteration it will pop one value from the stack and repeat the
# process until it finds the solution.
#
# It will be biased for going to the right, since the order in which we add the
# neighbours ends with the right, and since it is a stack, (first in, last out)
# it will pop that value fist.
#
# If the maze has a solution, it is guaranteed to be found by this. But it does
# not ensure the quality of the solution.
def dfs(maze)
    stack = []

    start_square = maze.start
    start_square.previous = nil
    stack.push(start_square)

    end_square = maze.end

    visited_squares = [].to_set

    while stack.length.positive?
        square = stack.pop
        if square == end_square
            return square
        end
        visited_squares.add(square)

        maze.neighbours(square).each do |neighbour|
            # check if the neighbour is already in the set, if it is, we do not
            # need to visit it again.
            if visited_squares.include? neighbour or maze.is_wall(square)
                next
            end
            neighbour.previous = square
            stack.push(neighbour)
        end
        # binding.break
    end

    # if we ever get here, it means that we went thru the whole stack and did
    # not find a solution.
    return nil
end


##
# breadth-first search
#
# pessimistic search algorithm, works exactly the same as dfs, but instead of a
# stack uses a queue, this small change makes the algorithm methodical. Opposed
# to dfs, which thinks is always one step away from the end of the maze. This
# will first check all the neighbours, and until is finished with those, it
# will go and check the neighbours of neighbours and so on.
#
# this one does guarantees that the path it finds is the shortest one.
def bfs(maze)
    queue = []

    start_square = maze.start
    start_square.previous = nil
    queue.push(start_square)

    end_square = maze.end

    visited_squares = [].to_set

    while queue.length.positive?
        square = queue.first
        queue.shift
        if square == end_square
            return square
        end
        visited_squares.add(square)

        maze.neighbours(square).each do |neighbour|
            # check if the neighbour is already in the set, if it is, we do not
            # need to visit it again.
            if visited_squares.include? neighbour or maze.is_wall(square)
                next
            end
            neighbour.previous = square
            queue.push(neighbour)
        end
        # binding.break
    end

    # if we ever get here, it means that we went thru the whole queue and did
    # not find a solution.
    return nil
end

maze = load_maze('sample.maze')
dfs_path = get_path(dfs(maze))
puts dfs_path.length

bfs_path = get_path(bfs(maze))
puts bfs_path.length

maze.paint_path(bfs_path)
