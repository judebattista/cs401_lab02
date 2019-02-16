.data
array1:     .byte   1,2,3,4
.text

main:
# $s0 = array base address, $s1 = i
# initialization
#lui     $s0, 0x23B8         # load 0x23BB into the upper half of s0
#ori     $s0, $s0, 0xF000    # $s0 = 0x23BBF000
la      $s0, array1         # load the address of array1 into $s0
addi    $s1, $0, 0          # $s1 = 0
addi    $t2, $0, 4          # $t2 = 4

loop:
    slt     $t0, $s1, $t2   # $s1 < 4?
    beq     $t0, $0, done   # if not, jump to done
    sll     $t0, $s1, 2     # $t0 = $s1 * 4 (creates a byte offset)
    add     $t0, $t0, $s0   # add $s0 to $t0 so that $t0 holds the address of array[$s0]
    lw      $t1, 0($t0)     # load array[$s0] into $t1
    sll     $t1, $t1, 3     # $t1 = $t1 * 8
    sw      $t1, 0($t0)     # write the new value back to the array so array[i] = array[i] * 8
    addi    $s1, $s1, 1     # i = i + 1
    j loop                  # loop
done: