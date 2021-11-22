vbsme:  
    li      $v0, 0              # reset $v0 and $v1
    li      $v1, 0

    # insert your code here
    addi $sp, $sp, -4
    sw $ra, 0($sp)                                  #store ra = backtomain
    move $v0, $0                                     #v0 stores best addrSAD row
    move $v1, $0                                     #v1 stores best addrSAD col
    addi $s2, $0, 32767                              #$s2 stores best SAD min, initialize to large number 2^32-1
    
    li $s7, 0 # set index to 0
    lw $s3, 0($a0) # get frame rows (i)
    lw $s4, 4($a0) # get frame columns (j)
    lw $s5, 8($a0) # get window rows (k)
    lw $s6, 12($a0) # get window columns (l)
    sub $s0, $s4, $s6                                             
    addi $s0, $s0, 1                                  # sizeofframecol - sizeofwindowcol + 1

    jal SAD

    sub $s1, $s4, $s6                                 # s1 = endofcol

    mul $t1, $s3, $s4                                 # t1 = (i * j)
    addi $t2, $s5, -1                                 # t2 = (k - 1)
    mul $t3, $t2, $s4                                 # t3 = (j * (k - 1))
    sub $t4, $t1, $t3                                 # t4 = (i * j) - (j * (k - 1))
    addi $t9, $t4, -1                                 # t9 = (i * j) - (j * (k - 1)) - 1 = last index

zLoop:
    addi $s7, $s7, 1
    j zCompare
endCol:
    add $s7, $s7, $s6
    add $s1, $s1, $s4
    j zCompare
zCompare: 
    jal SAD
    beq $s7, $t9, endSAD                              # endloop if last element index
    bne $s7, $s1, zLoop                               # loop +1 if not endofcol
    j endCol                                          # loop +windowcol if endcol
endSAD:

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

##############################################################################################################################
#SAD function begins
SAD:
    move $t0, $0                                     # t0 is current base address of frame
    move $t1, $0                                     # t1 is current base address of window

    addi $sp, $sp, -4
    sw $ra, 0($sp)                  
    move $t8, $0                                     # t8 = local SAD value 

    move $t2, $s6                                    
    addi $t2, $t2, -1                                # t2 = sizeofwindowcol-1 (used to check when to increment to nextrow)

    mul $t6, $s5, $s6
    addi $t6, $t6, -1                                # t6 = sizeofwindow-1 (used to check when to exit SAD loop)

    move $t7, $0                                     # t7 keeps track of col index

loop:
    # rEfA1
    add $t3, $t0, $s7                                # t3 = chosen index Address for a1, base address is $s7
    sll $t3, $t3, 2       
    add $t3, $t3, $a1                                
    lw $t3, 0($t3)                                   # t3 = a1[Address]

    # rEfA2
    add $t4, $t1, $0                                 # t4 = chosen index Address for a2, no need to have a 'base address' since we always start at 0
    sll $t4, $t4, 2                                 
    add $t4, $t4, $a2                                   
    lw $t4, 0($t4)                                   # t4 = a2[Address] 

    slt $t5, $t3, $t4                                
    beq $t5, $0, switch                              # if t3 >= t4 -> switch (used to calculate 'absolute' difference)
    sub $t4, $t4, $t3                                # else t4 = t4-t3
    j store
switch:     
    sub $t4, $t3, $t4                                # t4 = t3-t4
store:
    add $t4, $t4, $t8                                # update SAD into t8
    beq $t6, $t1, compare                            # if t1 = sizeofwindow-1 -> compare (exit loop when last element has been added to SAD)
    addi $t1, $t1, 1                                 # else t1++
    beq $t7, $t2, nextrow                            # if t7==sizeofwindowcol-1 -> nextrow (jump to nextrow if last element of a row has been accessed)
    addi $t0, $t0, 1                                 # else t0++ 
    addi $t7, $t7, 1                                 # t7++
    j loop
nextrow:                                
    addi $t0, $t0, $s0                               # t0 = $t0 + sizeofframecol - sizeofwindowcol + 1 (get new index on next line)
    move $t7, $0                                     # t7 = 0 (reset to new col index of nextrow)
    j loop

# compare to see if new calculated SAD is <= minimum SAD
compare:
    slt $t6, $t8, $s2                               
    bne $t6, $0, update                              # if t8 < s2 -> update
    beq $t5, $s2, update                             # if t8 == s2 -> update
    lw $ra, 0($sp)                                   # else clear stack and return
    addi $sp, $sp, 4
    jr $ra

# update minimum into s2, calculate row_index into v0 and col_index into v1 based on s7
update:
    move $s2, $t8                                    # update minimum s2
    
    move $t0, $0                                     # t0 increments to s7
    move $t1, $0                                     # t1 keeps track of rows
    move $t2, $0                                     # t2 keeps track of col

    beq $t0, $s7, done                               # check before incrementing t0, used when t0 = 0 to avoid infinite loop
getRowCol:
    addi $t0, $t0, $s4                               # t0 = multiples of framecol
    addi $t1, $t1, 1
    slt $t5, $s7, $t0                                # t5 = 1 if s7 < t0
    blez $t5, getRowCol                              # if t5 = 0, keep adding
    sub $t5, $t0, $s4
    sub $t2, $s7, $t5                                # t2 = s7-(t0-s4)    

done:
    # new code to move into v0 and v1
    move $v0, $t1                                    # v0 = $t1 = row_index
    move $v1, $t2                                    # v1 = $t1 = col_index                                
    lw $ra, 0($sp)                                   # clear stack and return
    addi $sp, $sp, 4
    jr $ra
##############################################################################################################################