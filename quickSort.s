.data
sortMe:     .byte   3,1,4,5,9,2,6
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


la      $s0, sortMe         # load the address of array1 into $s0
lb      $s1, lenSortMe      # $s1 = length of the array
addi    $s7, $0, 1          # $s7 set to 1 so we can easily subtract 1 from things
addi    $t0, $0, 0          # $t0 = current lo value = 0
addi    $t1, $s1, 0         # $t1 = current hi value = lenSortMe
sub     $t1, $t1, $s7            # subtract one from the hi value to account for zero-based arrays

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

# get the new index of the partition value

# split the array on the partition value and recurse on each half
