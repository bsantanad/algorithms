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

maze = load_maze('sample.maze')
