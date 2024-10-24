##
# max()
#
# implementing python\'s max() func in a variety of ways

##
# finding the largest value on a list, flawed
#
# this implementation is flawed because it assumes that the max value of a list
# is going to be greater than 0.
#
# It executes the `less than` operation n times.
#

def flawed(list)
    my_max = 0
    list.each do |v|
        if my_max < v
            my_max = v
        end
    end
    return my_max
end

##
# find the largest number on a list
#
# we define the first "my_max" value as the first element of the list, since
# the max value will be on the list either way.

def largest(list)
    my_max = list[0]
    list.each do |element|
        if my_max < element
            my_max = element
        end
    end
    return my_max
end

##
# find the largest 2 values on a list, simple approach
#

def largest_two(list)

    len = list.length
    if len == 0
        return nil
    end

    first_max = list[0]
    second_max = list[1]

    if first_max < second_max
        first_max = second_max
        second_max = first_max
    end

    # [1, 2, 3, 4, 5]
    # [5, 4, 3, 2, 1]
    (2..len - 1).each do | i |
        if first_max < list[i]
            second_max = first_max
            first_max = list[i]
        elsif second_max < list[i]
            second_max = list[i]
        end
    end
    return [first_max, second_max]
end

##
# find the largest 2 values on a list, tournament approach.
#
# this algorithm works like a tournament, it will put face to face,
# neighbour numbers. And will advance those who win to face each other, until
# we have the largest one.

def tournament_two(list)

    # check if the list is empty
    len = list.length
    if len == 0
        return nil
    end

    # this arrays will contains the results of each match.
    # For example, the winner and loser of match 2, will be in position 2 of
    # this array.
    winner = Array.new(len - 1, nil)
    loser = Array.new(len - 1, nil)


    idx = 0
    # this is the first round.
    (0..len-1).step(2) do | i |
        if list[i] < list[i + 1]
            winner[idx] = list[i + 1]
            loser[idx] = list[i]
        else
            winner[idx] = list[i]
            loser[idx] = list[i + 1]
        end
        idx += 1
    end

    # for the first round this will have -1's, due to those not having previous
    # matches.

    # after that we record the index of the value that wins, because we will
    # want to go back to see the loser to which that value won to.
    prior_matches = Array.new(len - 1, -1)

    # this will walk through the winner array, controlling who matches with
    # who.
    i = 0
    while idx < len - 1
        if winner[i] < winner[i + 1]
            winner[idx] = winner[i + 1]
            loser[idx] = winner[i]
            # here we are recording that the winner that won was in position
            # i + 1, this is important, because it means that the loser of the
            # previous match this value had, is in the same position, but in
            # the losers array.
            prior_matches[idx] = i + 1
        else
            winner[idx] = winner[i]
            loser[idx] = winner[i + 1]
            prior_matches[idx] = i
        end

        i += 2
        idx += 1
    end

    largest = winner[-1]
    second = loser[-1]

    # we start from the last previous match we have, to see all the losers and
    # compare them to the second place. See who is bigger.
    idx_of_previous_match = prior_matches[-1]
    while idx_of_previous_match > 0
        if second < loser[idx_of_previous_match]
            second = loser[idx_of_previous_match]
        end
        idx_of_previous_match -= 1
    end

    return [largest, second]
end

array = [3, 1, 4, 1, 5, 9, 2, 6]
print "#{array} result: #{tournament_two(array)}\n"

array = [-3, -4, -1, -2]
print "#{array} result: #{tournament_two(array)}\n"

array = []
print "#{array} result: #{tournament_two(array)}\n"
