##
#
# https://leetcode.com/problems/evaluate-reverse-polish-notation/description/?source=submission-ac
#
# You are given an array of strings tokens that represents an arithmetic
# expression in a Reverse Polish Notation.
# Evaluate the expression. Return an integer that represents the value of the
# expression.

# Note that:

# - The valid operators are '+', '-', '*', and '/'.
# - Each operand may be an integer or another expression.
# - The division between two integers always truncates toward zero.
# - There will not be any division by zero.
# - The input represents a valid arithmetic expression in a reverse polish
#   notation.
# - The answer and all the intermediate calculations can be represented in a
#   32-bit integer.

##
# The deal here is to use a stack, and when finding an operator, just popping
# two  the last to elements, do the operation and push the result into the
# stack.
#
# @param {String[]} tokens
# @return {Integer}
def eval_rpn(tokens)
    operators = ['+', '-', '*', '/'].to_set
    stack = []
    tokens.each do |token|
        # print "#{stack}\n"
        if operators.include?(token)
            # print "#{token}\n"
            n = stack.pop
            m = stack.pop
            # print "#{stack}\n"
            case token
            when '+'
                stack.push(m + n)
                next
            when '-'
                stack.push(m - n)
                next
            when '/'
                # if we divide and get a number between 0 and -1. If we dont
                # convert to float the first num. It will return -1.
                # The instructions say, we need to always truncate toward zero.
                stack.push((m.to_f / n).truncate)
                next
            when '*'
                stack.push(m * n)
                next
            end
        end
        stack.push(token.to_i)
    end
    return stack.pop
end

