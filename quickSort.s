.data
sortMe:     .byte   18, 43, 7, 93, 2, 11, 63
lenSortMe:  .byte   7
.text

main:
# $s0 = address of array
# $s1 = length of the array
# $s2 = current pivot index - probably don't need this
# $t0 = current lo index
# $t1 = current hi index
# $t2 = Foo index
# $t3 = Bar index
# $t4 = Pivot value
# $t5 = Bar value
# $t6 = temp
# $t7 = Foo Address
# $t8 = Bar Address
# $t9 = Pivot address
# $a0 = first parameter: lo index
# $a1 = second parameter: hi index

# initialization
la      $s0, sortMe         # load the address of array1 into $s0
lb      $s1, lenSortMe      # $s1 = length of the array
addi    $a0, $0, 0          # $a0 = lo value parameter = 0
addi    $a1, $s1, -1        # $s1 = current hi value parameter = lenSortMe - 1

# start the quicksort function
quicksort:
# check whether lo = hi
blt     $a0, $a1, lowlessthanhi # if lo < hi then do stuff
    jr $ra                      # otherwise return to calling function
lowlessthanhi:

# partition the array - initial pivot is the last element of the array
add     $s2, $a1, $0        # $s2 = pivot index = hi index

partition:
add     $t2, $0,$a0         # set foo index to lo index
add     $t3, $0,$a0         # set bar index to the lo index
add     $t9, $a1,$s0        # get the address of the pivot value (address of the hi index)
lb      $t4, 0($t9)         # get the pivot value from its address
cmpBarPiv:
    add     $t7, $s0,$t3        # get the address of the bar value: array address + bar offset
    lb      $t5, 0($t7)         # get the bar value from its address
    blt     $t5, $t4, swap      # if the bar value is less than the pivot value swap the values at foo and bar
    j       skipswap            # otherwise skip the swap
    swap:                       # swap values at foo and bar
        add $t7, $s0, $t2           # get the address of foo
        add $t8, $s0, $t3           # get the address of bar
        lb  $t6, 0($t7)             # load the value of foo based on its address into temp
        sb  $t5, ($t7)              # load the value of bar into the array at foo's address   
        sb  $t6, ($t8)              # load the value in temp (foo's old value) into the array at bar's address
        addi    $t2, $t2, 1         # increment foo's index
    skipswap:
        addi $t3, $t3, 1             #increment bar's index
    
    blt $t3, $a1, cmpBarPiv         # if bar index < hi  then loop
    # when we're done comparing, swap the pivot value with the foo value
    add $t7, $s0, $t2           # get the address of foo
    lb  $t6, 0($t7)             # load the value of foo based on its address into temp
    sb  $t4, ($t7)              # store the pivot value into foo's address
    sb  $t6, ($t9)              # store the value in temp (foo's old value) into pivot's address
# end of partitioning

# before we call quicksort on the subarrays, we need to stash relevant information on the stack
# we need to save the params for the second call before making the first call
addi    $t0, $t2, 1     # store foo index + 1 in $t0
addi    $sp, $sp, -8    # make room for two register values (push twice)
sw      $t0, 4($sp)     # store t0 (foo index + 1) in sp+4
sw      $a1, 0($sp)     # store $1 (hi index) in sp+0


# call quicksort on the lower array [lo, foo-1] = [$a0, $t2 - 1]
# #a0 should already be correct
addi    $a1, $t2, -1    # set $a1 = foo index - 1
jal quicksort           # call quicksort

# pull the params for the second call off the stack and restore the stack
lw      $a0, 4($sp)     # load foo index + 1 off the stack into the lo param
lw      $a1, 0($sp)     # load hi index off the stack into the hi param
addi    $sp, $sp, 8     # restore the stack pointer (pop twice)

#call quicksort on the upper array (foo+1, hi) = [$t2 + 1, $a1]
jal quicksort           # call quicksort

#end program
li      $v0, 10         # load the value 10 for exit into $v0
syscall                 # execute syscall 10 = exit