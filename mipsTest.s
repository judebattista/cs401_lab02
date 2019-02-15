lui     $s0, 0x23B8         # load 0x23BB into the upper half of s0
ori     $s1, 0xF000         # $s0 = 0x23BBF000
addi    $s1, $0, $0         # $s1 = 0
addi    $t2, $0, 1000       # $t2 = 1000

loop:
    slt     $0, $s1, $t2    # $s1 < 1000 ?
    