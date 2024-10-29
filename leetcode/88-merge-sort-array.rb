##
#
# https://leetcode.com/problems/merge-sorted-array/description/
#
# You are given two integer arrays nums1 and nums2, sorted in non-decreasing
# order, and two integers m and n, representing the number of elements in nums1
# and nums2 respectively.
#
# Merge nums1 and nums2 into a single array sorted in non-decreasing order.
#
# The final sorted array should not be returned by the function, but instead be
# stored inside the array nums1. To accommodate this, nums1 has a length of m +
# n, where the first m elements denote the elements that should be merged, and
# the last n elements are set to 0 and should be ignored. nums2 has a length of
# n.
#
# Example 1:
# Input: nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
# Output: [1,2,2,3,5,6]
# Explanation: The arrays we are merging are [1,2,3] and [2,5,6].
# The result of the merge is [1,2,2,3,5,6] with the underlined elements coming
# from nums1.


# @param {Integer[]} nums1
# @param {Integer} m
# @param {Integer[]} nums2
# @param {Integer} n
# @return {Void} Do not return anything, modify nums1 in-place instead.
def merge(nums1, m, nums2, n)

    # Both nums1 and nums2 are sorted.
    #
    # we will compare the elements starting from the end of the arrays
    # (nums1 without the zeros and nums 2), see which is bigger, and
    # place it in nums1 including the zeros.
    #
    # We know where to place it because we have a pointer_z that is walking thru the
    # real length of nums1 (including the zeros) and going backwards.
    # On each number of nums2 pointer_z asks, from which array should I put the
    # value here.

    # [1, 2, 3, 0, 0, 0] <- nums1
    #        x        pointer_z

    # [2, 5, 6] <- nums2

    # we pop the last value of nums2

    # 6, is 6 > 3? yes so we place it in `pointer_z`. We move `pointer_z` to the left
    # pop the next value and ask the question.

    # this will be the tracker for nums1 full array, including zeros
    pointer_z = m + n - 1
    # tracker for nums1 without the zeros
    pointer_x = m - 1

    # we wont really use a tracker for nums2, since we can treat it as
    # a stack and just pop the values.

    while nums2.length > 0
        n = nums2.pop

        # if we already finish with nums1 values, we have nothing to compare
        # against. Let's just copy the values and finish the stack.
        if pointer_x < 0
            nums1[pointer_z] = n
            pointer_z -= 1
            next
        end

        if n >= nums1[pointer_x]
            nums1[pointer_z] = n
            pointer_z -= 1
            next
        end

        if n < nums1[pointer_x]
            nums1[pointer_z] = nums1[pointer_x]
            pointer_x -= 1
            pointer_z -= 1
            # it was not big enough, so lets put it back on the stack to try
            # again with it next lap
            nums2.push(n)
        end
    end
end
