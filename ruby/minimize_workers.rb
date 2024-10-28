##
# We need to find the best optimal schedule (order in which to do the tasks)
# for a dataset of workers that looks like this:

# Worker,Task,Time(mins.)
# Quentin,T1,24
# Peter,T3,18
# Whitney,T8,13
# Brian,T6,43
# Jacob,T7,31
# Xena,T9,10
# (NOTE data might have redundancies (use lowest time)
#
# There is a single machine where tasks are performed
# - The day starts at 9:00AM and all workers are available.
# - Only one task can be performed at a time
# - All tasks must be completed.
# - Completion Time is since 9:00AM

##
# Remove repeated entries on dataset. When repeated choose lowest time.
# Given a list [[worker, task, time], ...]
#
# Return a list where all tasks are guaranteed to be unique and with the lowest
# time.
#
def remove_redundant_entries(workers)

    # new hash; key is the task; value a list of [worker, task, time].
    # in the hash we only store the entries of the task were the time is
    # the lowest.
    task_hash = Hash.new
    workers.each do |worker, task, time|
        if not task_hash.key?(task)
            task_hash[task] = [worker, task, time]
            next
        end

        # if the time of this iteration, is lowest than the one we already
        # recorded, we need to replace the entry
        _, _, old_time = task_hash[task]
        if time < old_time
            task_hash[task] = [worker, task, time]
        end

    end
    return task_hash.values
end

##
# Return a list with the schedule that minimizes the completion time for each
# task.
#
# We now have a list with no repeated workers. How do we minimize the time for
# each task? Well if we do the short tasks after a longer one, the time would
# add up. Say for example we do a 40 min task, and then a 15 min one. The total
# completion time for the 15 min one is 55 min. But if we did it the other way
# around, that is, first the 15 and then the 40, the completion time for the 15
# one is 15 min.
#
# Using this logic, we just need to sort the list by time, and we have the
# schedule that minimize the completion time for each task.
#
def minimize_completion_time(workers)
    clean_workers = remove_redundant_entries(workers)
    clean_workers = clean_workers.sort_by { |entry| entry[2]} # entry[2] = time
    return clean_workers
end

##
# Simple function to read the file and add it to a list
def read_workers_file(filename)
    workers = []
    File.foreach(filename) do |entry|
        worker, task, time = entry.strip.split(',')
        workers.push([worker, task, time.to_i])
    end
    return workers
end

filename = '../files/workers-test.csv'
workers = read_workers_file(filename)
print "#{minimize_completion_time(workers)}\n"
