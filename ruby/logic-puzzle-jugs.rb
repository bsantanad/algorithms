require 'debug'

##
# You have two Jugs of water, on of 4 gallons, and other of 7 gallons.
#
# You have an endless supply of water
#
# Can you fill exactly 6 gallons on the 7 gallon one?
#
# You can perform the following operations:
#   - you can completely empty a jug
#   - you can completely fill a jug
#   - you can pour from one jug to another
#

##
#
# We need to structure the problem.
# We can define a state. This state is the amount of water each jug has. (jug4
# and jug7)
#
# Identify how the state change, we can build a graph of options.
# [0, 0] -> [4, 0]
#        -> [0, 7]
#
# Work it out in a way a computer can solve it.


##
# For this problem in particular, we can record each state in a queue, go thru
# the queue, seeing the possible outcomes.
# In parallel we will have a set of the outcomes that we have already seen, so
# we do not repeat processes.

class State

    attr_reader :jug4, :jug7
    attr_accessor :previous_state

    def initialize(jug4, jug7)
        @jug4 = jug4
        @jug7 = jug7
    end

    def to_s # override default to_s method
        "#{jug4},#{jug7}"
    end

    def ==(other)
        self.class == other.class &&
        [jug4, jug7] == [other.jug4, other.jug7]
    end

    def eql?(other)
        self.class == other.class &&
        [jug4, jug7] == [other.jug4, other.jug7]
    end

    def hash() # needed to add this to a set
        [jug4, jug7].hash
    end

    def is_solved(target)
        jug4 == target or jug7 == target
    end

    def next_states()
        next_states = []

        # fill either one completely
        if jug4 < 4
            state = State.new(4, jug7)
            next_states.push(state)
        end
        if jug7 < 7
            state = State.new(jug4, 7)
            next_states.push(state)
        end

        # empty either one
        if jug4 > 0
            state = State.new(0, jug7)
            next_states.push(state)
        end
        if jug7 > 0
            state = State.new(jug4, 0)
            next_states.push(state)
        end

        # pour water from jug7 into jug4
        # choose between what's less:
        #   - how many space do I have left in jug4
        #   - how much water does jug7 has
        water_to_pour = [4 - jug4, jug7].min
        if water_to_pour > 0
            state = State.new(jug4 + water_to_pour, jug7 - water_to_pour)
            next_states.push(state)
        end

        # pour water from jug4 into jug7
        water_to_pour = [jug4, 7 - jug7].min
        if water_to_pour > 0
            state = State.new(jug4 - water_to_pour, jug7 + water_to_pour)
            next_states.push(state)
        end

        return next_states
    end

end

def search(target)
    unexplored_states_queue = []
    explored_states_set = [].to_set

    state = State.new(0,0)
    unexplored_states_queue.push(state)

    while unexplored_states_queue.length > 0
        # read and remove first state in the queue
        state = unexplored_states_queue.first
        unexplored_states_queue.shift

        # no case on adding it if we already explored it.
        if explored_states_set.include?(state)
            next
        end

        explored_states_set.add(state)

        if state.is_solved(target)
            return get_path(state, State.new(0, 0))
        end

        next_states = state.next_states()
        next_states.each do |next_state|
            next_state.previous_state = state
            unexplored_states_queue.push(next_state)
        end
    end

end

##
#
# Check previous state path to see if the target_state is met.
# If not return nil, If so return the path in a list
#
def get_path(state, target_state)
    path = [state]
    previous_state = state.previous_state
    while previous_state != target_state
         if previous_state == nil
            return nil
         end
         path.push(previous_state)
         previous_state = previous_state.previous_state
    end
    return path
end

path = search(6)
puts path
