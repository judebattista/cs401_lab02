.data
sortMe:     .byte   9, 100, 55, 78, 1, 6, 3
lenSortMe:  .byte   7
.text

main:
# $s0 = array base address, $s1 = i
# initialization
# $s0 = address of array
# $s1 = size of the array
# $s2 = current partition index
# $s7 = 1 for subtraction purposes
# $t0 = current lo index
# $t1 = current hi index
# $t2 = Foo index
# $t3 = Bar index
# $t4 = Piv value
# $t5 = Bar value
# $t6 = temp
# $t7 = FooAddress
# $t8 = BarAddress
# $t9 = Piv address
# $a0 = first parameter: lo index
# $a1 = second parameter: hi index

# initialization
la      $s0, sortMe         # load the address of array1 into $s0
lb      $s1, lenSortMe      # $s1 = length of the array
addi    $s7, $0, 1          # $s7 set to 1 so we can easily subtract 1 from things
#addi    $t0, $0, 0          # $t0 = current lo value = 0
addi    $a0, $0, 0         # $a0 = lo value parameter = 0
#addi    $t1, $s1, 0         # $t1 = current hi value = lenSortMe
addi    $a1, $s1, 0         # $s1 = current hi value parameter = lenSortMe
sub     $t1, $t1, $s7       # subtract one from the hi value to account for zero-based arrays

# start the quicksort function
# get our hi and low values
quicksort:
# check whether lo = hi
blt     $a0, $a1, lolessthanhi  # if lo < hi then do stuff
    jr $ra                      # otherwise return to calling function
lolessthanhi:
addi    $t0, $a0, 0          # load lo param into $t0 which holds the lo value for this iteration
addi    $t1, $a1, -1         # load hi param into $t1 which holds the hi value for this iteration

# partition the array - initial partition is the last element of the array
add     $s2, $t1, $0        # $s2 = partition index = hi index

partition:
add     $t2, $0,$t0         # set foo index to lo index
add     $t3, $0,$t0         # set bar index to the lo index
add     $t9, $t1,$s0        # get the address of the pivot value (address of the hi index)
lb      $t4, 0($t9)         # get the pivot value from its address
cmpBarPiv:
    add     $t7, $s0,$t3        # get the address of the bar value: array address + bar offset
    lb      $t5, 0($t7)         # get the bar value from its address
    blt     $t5, $t4, swap      # if the bar value is less than the pivot value do the swap
    j       skipswap            # otherwise skip the swap
    swap:
        add $t7, $s0, $t2           # get the address of foo
        add $t8, $s0, $t3           # get the address of bar
        lb  $t6, 0($t7)             # load the value of foo based on its address into temp
        sb  $t5, ($t7)              # load the value of bar into the array at foo's address   
        sb  $t6, ($t8)              # load the value in temp (foo's old value) into the array at bar's address
        addi    $t2, $t2, 1          # increment foo's index
    skipswap:
        addi $t3, $t3, 1             #increment bar's index
    
    blt $t3, $t1, cmpBarPiv         # if bar index < hi  then loop
    # when we're done comparing, swap the pivot value with the foo value
    add $t7, $s0, $t2           # get the address of foo
    lb  $t6, 0($t7)             # load the value of foo based on its address into temp
    sb  $t4, ($t7)              # store the pivot value into foo's address
    sb  $t6, ($t9)              # store the value in temp (foo's old value) into pivot's address
# end of partitioning
#call quicksort on the lower array (lo, foo)
addi    $a0, $t0, 0     # set $a0 = lo index
addi    $a1, $t2, 0     # set $a1 = foo index
jal quicksort           # call quicksort

#call quicksort on the upper array (foo+1, hi)
addi    $a0, $t2, 1     # set $a0 = foo+1 index
addi    $a1, $t1, 0     # set $a1 = hi index
jal quicksort           # call quicksort

sorted:
li      $v0, 10         # load the value 10 for exit into $v0
syscall                 # execute syscall 10 = exit