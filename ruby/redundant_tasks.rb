##
# We are given the following data
#
# Worker,Task,Time(mins.)
# Quentin,T1,24
# Peter,T3,18
# Whitney,T8,13
# Brian,T6,43
# Jacob,T7,31
# Xena,T9,10
#
# We are being ask to remove redundant (worker, task) entries with lower times.
#
# Meaning to return a list that has worker, task, max amount of time, that
# worker spend doing the task.

##
# Solution:
# we can load the data into a dict, where the key is [worker task]
# then we store the largest time (by comparing elements with same key)
#
# return a list, decomposing the key to get the format:
# [[worker, task, time], ...]

def reduce_pairs(filename)

    workers_hash = Hash.new

    File.foreach(filename) do |entry|
        worker, task, time = entry.strip.split(',')

        # convert time to integer
        time = time.to_i
        # key = "#{worker}#{task}".downcase.to_sym
        key = [worker, task]

        if workers_hash.key?(key)
            if workers_hash[key] < time
                workers_hash[key] = time
            end
            next
        end

        workers_hash[key] = time
    end

    result = workers_hash.map { |k, v| [k[0], k[1], v] }
    return result

end

print reduce_pairs('../files/workers-test.csv')
