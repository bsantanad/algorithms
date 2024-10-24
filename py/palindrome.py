'''
palindrome word detector

a palindrome word reads the same backward as forward, such as `madam`.
'''
import re

def process_string(word):
    '''
    We do not care about punctuation and spaces, so we remove them.
    '''
    word = word.lower()
    e = r'[^\w]'
    # replace ^ (everything that is not) a word (\w)).
    word = re.sub(e, '', word)
    print(word)
    return word


def is_palindrome(word):
    word = process_string(word)
    return word == word[::-1]

def is_palindrome_for(word):
    word = process_string(word)
    i = -1
    for char in word:
        if char != word[i]:
            return False
        i -= 1
    return True

w = 'A man, a plan, a canal. Panama!'

print(is_palindrome(w))
print(is_palindrome_for(w))

