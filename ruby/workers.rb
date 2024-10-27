##
# We are going to perform some operations on a file with the following data.
#
# Worker,Task,Time(mins.)
# Quentin,T1,24
# Peter,T3,18
# Whitney,T8,13
# Brian,T6,43
# Jacob,T7,31
# Xena,T9,10
#

##
# These are exercises by George T. Heineman's O'Reilly Course on Interview
# Prep, but I did them in ruby.


##
# Remove redundant workers.
#
# Remove combinations of <worker, task> entries with lower times than the max
# amount.
#
# Return a list that has <worker, task, max amount> (the max amount of time
# that worker spend doing the task.)
#
# Solution:
# we load the data into a dict, where the key is [worker task]
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

##
# Find most productive worker.
#
# Given a list with the following format: [[worker, task, time], ...]
#
# Return a list of the worker(s) with the most tasks
def most_producitve(workers_w_task)
    
    # new hash; 
    # keys are the workers names; 
    # values are the set of all the tasks they have done. (we use set because
    # we want to avoid duplicates.)
    worker_tasks_total = Hash.new

    workers_w_task.each do |worker, task, time|
        if worker_tasks_total.key?(worker)
            worker_tasks_total[worker].add(task)
            next 
        end
        worker_tasks_total[worker] = [task].to_set
    end

    # Now we have a hash with each worker and all the tasks they have done;
    # lets see which employee has the most tasks (take into account they can be
    # many) 

    # We will go thru the worker_tasks_total hash, and get the length of the
    # set. 
    # 
    # We check if that is the highest number of tasks someone has done.
    # if it is we add that worker to the result. Because it means someone else
    # already had that amount of tasks in the past.
    #
    # If its higher we then have a new highest number of tasks. We update the
    # number and start a new list with the that worker.
    # 
    # If is lower we do nothing.
    #
    highest_number_of_tasks = -1
    most_tasks = []
    worker_tasks_total.each do |worker, set_of_tasks|
        total_tasks = set_of_tasks.length
        if total_tasks == highest_number_of_tasks
            most_tasks.push(worker)
            next 
        end
        if total_tasks > highest_number_of_tasks
            most_tasks = [worker]
            highest_number_of_tasks = total_tasks 
        end
    end

    return [highest_number_of_tasks, most_tasks]
end

##
# 
# Return the least amount of time it takes to do all tasks.
#
# Given a list with the following format: [[worker, task, time], ...]
#
def least_amount(workers_w_task)
    # create a hash; key is task; value is the least amount of time for it. 
    tasks_hash = Hash.new
    workers_w_task.each do | _, task, time|
        if not tasks_hash.key?(task)
            tasks_hash[task] = time
            next
        end

        if time < tasks_hash[task] 
            tasks_hash[task] = time
        end
    end

    # sum all the values on the hash 
    result = 0
    tasks_hash.each do | _, time |
        result += time
    end

    return result
end

##
# Find the best worker, this means, the one that can do the most amount of
# tasks in the least period of time.
#
# Given a list with the following format: [[worker, task, time], ...]
#
# Return list [worker, amount of time]
def best_worker(workers_w_task)

    # new hash; key is worker; value [{set of tasks}, time]  
    workers = Hash.new
    workers_w_task.each do |worker, task, time|
        if not workers.key?(worker)
            workers[worker] = [[task].to_set, time]
            next
        end
        tasks, total_time =  workers[worker]
        workers[worker] = [tasks.add(task), total_time + time]
    end

    # iterate thru the hash, find the highest number of tasks done in the least
    # amount of time.
    max_amount_tasks = -1
    min_amount_time = Float::INFINITY

    result = [] 

    workers.each do |worker, tasks_info|
        tasks, time = tasks_info
        total_tasks = tasks.length

        if total_tasks > max_amount_tasks
            max_amount_tasks = total_tasks
            min_amount_time = time
            result = [worker, time]
            next
        end

        if total_tasks == max_amount_tasks
            if time < min_amount_time 
                min_amount_time = time 
                result = [worker, time]
            end
        end

    end

    return result
end

workers = reduce_pairs('../../files/workers.csv')
print "Most Producitve: #{most_producitve(workers)}\n"
print "Least Amount: #{least_amount(workers)}\n"
print "Best Worker: #{best_worker(workers)}\n"
