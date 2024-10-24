##
# palindrome word detector
#
# a palindrome word reads the same backward as forward, such as `madam`.

def is_palindrome(word)
    i = -1
    word.each_char do |c|
        if c != word[i]
            return false
        end
        i -= 1
    end
    return true
end

w = 'madam'
puts is_palindrome(w)
