#  Team Members: JOE LIANG, ASHTON ROWE, CAMERON MATSUMOTO
#  % Effort    :   ALL MEMBERS CONTRIBUTED EQUALLY  
#
# ECE369A,  
# 

########################################################################################################################
### data
########################################################################################################################
.data
# test input
# asize : dimensions of the frame [i, j] and window [k, l]
#         i: number of rows,  j: number of cols
#         k: number of rows,  l: number of cols  
# frame : frame data with i*j number of pixel values
# window: search window with k*l number of pixel values
#
# $v0 is for row / $v1 is for column

# test 0 For the 4x4 frame size and 2X2 window size
# small size for validation and debugging purpose
# The result should be 0, 2
asize0:  .word    4,  4,  2, 2    #i, j, k, l
frame0:  .word    0,  0,  1,  2, 
         .word    0,  0,  3,  4
         .word    0,  0,  0,  0
         .word    0,  0,  0,  0, 
window0: .word    1,  2, 
         .word    3,  4, 
# test 1 For the 16X16 frame size and 4X4 window size
# The result should be 12, 12
asize1:  .word    16, 16, 4, 4    #i, j, k, l
frame1:  .word    0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         .word    1, 2, 3, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
         .word    2, 3, 32, 1, 2, 3, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 
         .word    3, 4, 1, 2, 3, 4, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    0, 12, 24, 36, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    0, 13, 26, 39, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    0, 14, 28, 42, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window1: .word    0, 1, 2, 3, 
         .word    1, 2, 3, 4, 
         .word    2, 3, 4, 5, 
         .word    3, 4, 5, 6 

# test 2 For the 16X16 frame size and a 4X8 window size
# The result should be 0, 4
asize2:  .word    16, 16, 4, 8    #i, j, k, l
frame2:  .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    7, 5, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
         .word    0, 4, 2, 3, 4, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 0, 0, 0, 0, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 0, 0, 0, 0, 84, 90, 
         .word    0, 4, 8, 8, 8, 8, 42, 49, 56, 63, 0, 0, 0, 0, 98, 105, 
         .word    0, 1, 8, 8, 8, 8, 48, 56, 64, 72, 0, 0, 0, 0, 112, 120, 
         .word    0, 1, 8, 8, 8, 8, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 8, 8, 8, 8, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window2: .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0, 
         .word    0, 0, 0, 0, 0, 0, 0, 0

# test 3 For the 16X16 frame size and a 8X4 window size
# The result should be 3, 2
asize3:  .word    16, 16, 8, 4    #i, j, k, l
frame3:  .word    7, 8, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
         .word    7, 8, 8, 8, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 
         .word    7, 8, 8, 8, 2, 8, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 
         .word    7, 8, 8, 8, 8, 8, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 
         .word    0, 4, 8, 8, 8, 8, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 8, 8, 8, 8, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 8, 8, 8, 8, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 8, 8, 8, 8, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 1, 8, 8, 8, 8, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 1, 8, 8, 8, 8, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 8, 8, 8, 8, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window3: .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8, 
         .word    8, 8, 8, 8 

# test 4 For the 16X16 frame and a 4X4 window size
# The result should be 1, 1
asize4:  .word    16, 16, 4, 4    #i, j, k, l
frame4:  .word    9, 9, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 7, 7, 
         .word    9, 7, 7, 7, 7, 5, 6, 7, 8, 9, 10, 11, 6, 7, 7, 7, 
         .word    9, 7, 7, 7, 7, 3, 12, 14, 16, 18, 20, 6, 6, 7, 7, 7, 
         .word    9, 7, 7, 7, 7, 4, 18, 21, 24, 27, 30, 33, 6, 7, 7, 7, 
         .word    0, 7, 7, 7, 7, 5, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 
         .word    0, 5, 3, 4, 5, 6, 30, 35, 40, 45, 50, 55, 60, 65, 70,  75, 
         .word    0, 6, 12, 18, 24, 30, 36, 42, 48, 54, 60, 66, 72, 78, 84, 90, 
         .word    0, 4, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105, 
         .word    0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88, 96, 104, 112, 120, 
         .word    0, 9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135, 
         .word    0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 
         .word    0, 11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165, 
         .word    9, 9, 9, 9, 48, 60, 72, 84, 96, 108, 120, 132, 0, 1, 2, 3, 
         .word    9, 9, 9, 9, 52, 65, 78, 91, 104, 114, 130, 143, 1, 2, 3, 4, 
         .word    9, 9, 9, 9, 56, 70, 84, 98, 112, 126, 140, 154, 2, 3, 4, 5, 
         .word    9, 9, 9, 9, 60, 75, 90, 105, 120, 135, 150, 165, 3, 4, 5, 6 
window4: .word    7, 7, 7, 7, 
         .word    7, 7, 7, 7, 
         .word    7, 7, 7, 7, 
         .word    7, 7, 7, 7 

########################################################################################################################
### main
########################################################################################################################

.text

.globl main

main: 
    addi    $sp, $sp, -4    # Make space on stack
    sw      $ra, 0($sp)     # Save return address

    # Start test 1 
    ############################################################
    la      $a0, asize0     # 1st parameter: address of asize0[0]
    la      $a1, frame0     # 2nd parameter: address of frame0[0]
    la      $a2, window0    # 3rd parameter: address of window0[0] 
   
    jal     vbsme           # call function
    #jal     print_result    # print results to console
    
    ############################################################
    # End of test 1 

    # Start test 1 
    ############################################################
    la      $a0, asize1     # 1st parameter: address of asize1[0]
    la      $a1, frame1     # 2nd parameter: address of frame1[0]
    la      $a2, window1    # 3rd parameter: address of window1[0] 
   
    jal     vbsme           # call function
    #jal     print_result    # print results to console
    
    ############################################################
    # End of test 1   

   
    # Start test 2 
    ############################################################
    la      $a0, asize2     # 1st parameter: address of asize2[0]
    la      $a1, frame2     # 2nd parameter: address of frame2[0]
    la      $a2, window2    # 3rd parameter: address of window2[0] 
   
    jal     vbsme           # call function
    #jal     print_result    # print results to console
    ############################################################
    # End of test 2   
                    
               
    # Start test 3
    ############################################################
    la      $a0, asize3     # 1st parameter: address of asize3[0]
    la      $a1, frame3     # 2nd parameter: address of frame3[0]
    la      $a2, window3    # 3rd parameter: address of window3[0] 

    jal     vbsme           # call function
    #jal     print_result    # print results to console 
    ############################################################
    # End of test 3   
      
      
    # Start test 4 
    ############################################################
    la      $a0, asize4     # 1st parameter: address of asize4[0]
    la      $a1, frame4     # 2nd parameter: address of frame4[0]
    la      $a2, window4    # 3rd parameter: address of window4[0] 

    jal     vbsme           # call function
    #jal     print_result    # print results to console
    ############################################################
    # End of test 4   
   
    lw      $ra, 0($sp)         # Restore return address
    addi    $sp, $sp, 4         # Restore stack pointer
    jr      $ra                 # Return

################### Print Result ####################################
#print_result:
#    # Printing $v0
#    add     $a0, $v0, $zero     # Load $v0 for printing
#    li      $v0, 1              # Load the system call numbers
#    #syscall
#   
#    # Print newline.
#    la      $a0, newline          # Load value for printing
#    li      $v0, 4                # Load the system call numbers
#    #syscall
#   
#    # Printing $v1
#    add     $a0, $v1, $zero      # Load $v1 for printing
#    li      $v0, 1                # Load the system call numbers
#    #syscall
#
#    # Print newline.
#    la      $a0, newline          # Load value for printing
#    li      $v0, 4                # Load the system call numbers
#    #syscall
#   
#    # Print newline.
#    la      $a0, newline          # Load value for printing
#    li      $v0, 4                # Load the system call numbers
#    #syscall
#   
#    jr      $ra                   #function return

#####################################################################
### vbsme
#####################################################################


# vbsme.s 
# motion estimation is a routine in h.264 video codec that 
# takes about 80% of the execution time of the whole code
# given a frame(2d array, x and y dimensions can be any integer 
# between 16 and 64) where "frame data" is stored under "frame"  
# and a window (2d array of size 4x4, 4x8, 8x4, 8x8, 8x16, 16x8 
# or 16x16) where "window data" is stored under "window" 
# and size of "window" and "frame" arrays are stored under 
# "asize"

# - initially current sum of difference is set to a very large value
# - move "window" over the "frame" one cell at a time starting with location (0,0)
# - moves are based on the defined search pattern 
# - for each move, function calculates  the sum of absolute difference (SAD) 
#   between the window and the overlapping block on the frame.
# - if the calculated sum of difference is LESS THAN OR EQUAL to the current sum of difference
#   then the current sum of difference is updated and the coordinate of the top left corner 
#   for that matching block in the frame is recorded. 

# for example SAD of two 4x4 arrays "window" and "block" shown below is 3  
# window         block
# -------       --------
# 1 2 2 3       1 4 2 3  
# 0 0 3 2       0 0 3 2
# 0 0 0 0       0 0 0 0 
# 1 0 0 5       1 0 0 4

# program keeps track of the window position that results 
# with the minimum sum of absolute difference. 
# after scannig the whole frame
# program returns the coordinates of the block with the minimum SAD
# in $v0 (row) and $v1 (col) 


# Sample Inputs and Output shown below:
# Frame:
#
#  0   1   2   3   0   0   0   0   0   0   0   0   0   0   0   0 
#  1   2   3   4   4   5   6   7   8   9  10  11  12  13  14  15 
#  2   3  32   1   2   3  12  14  16  18  20  22  24  26  28  30 
#  3   4   1   2   3   4  18  21  24  27  30  33  36  39  42  45 
#  0   4   2   3   4   5  24  28  32  36  40  44  48  52  56  60 
#  0   5   3   4   5   6  30  35  40  45  50  55  60  65  70  75 
#  0   6  12  18  24  30  36  42  48  54  60  66  72  78  84  90 
#  0   7  14  21  28  35  42  49  56  63  70  77  84  91  98 105 
#  0   8  16  24  32  40  48  56  64  72  80  88  96 104 112 120 
#  0   9  18  27  36  45  54  63  72  81  90  99 108 117 126 135 
#  0  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 
#  0  11  22  33  44  55  66  77  88  99 110 121 132 143 154 165 
#  0  12  24  36  48  60  72  84  96 108 120 132   0   1   2   3 
#  0  13  26  39  52  65  78  91 104 117 130 143   1   2   3   4 
#  0  14  28  42  56  70  84  98 112 126 140 154   2   3   4   5 
#  0  15  30  45  60  75  90 105 120 135 150 165   3   4   5   6 

# Window:
#  0   1   2   3 
#  1   2   3   4 
#  2   3   4   5 
#  3   4   5   6 

# cord x = 12, cord y = 12 returned in $v0 and $v1 registers

.text
.globl  vbsme

# Your program must follow the required search pattern.  

# Preconditions:
#   1st parameter (a0) address of the first element of the dimension info (address of asize[0])
#   2nd parameter (a1) address of the first element of the frame array (address of frame[0][0])
#   3rd parameter (a2) address of the first element of the window array (address of window[0][0])
# Postconditions:	
#   result (v0) x coordinate of the block in the frame with the minimum SAD
#          (v1) y coordinate of the block in the frame with the minimum SAD

###############################################################
#rEfA1 finds the chosen index in a1 (frame) and returns the contents
rEfA1:
    add $t3, $t0, $s7                                #t3 = chosen index Address for a1, base address is $s7
    sll $t3, $t3, 2       
    add $t3, $t3, $a1                                
    lw $t3, 0($t3)                                   #t3 = a1[Address] 
    jr $ra                                           #jump back to where it was called +4
#rEfA2 finds the chosen index in a2 (window) and returns the contents
rEfA2:
    add $t4, $t1, $0                                 #t4 = chosen index Address for a2, no need to have a 'base address' since we always start at 0
    sll $t4, $t4, 2                                 
    add $t4, $t4, $a2                                   
    lw $t4, 0($t4)                                   #t4 = a2[Address] 
    jr $ra                                           #jump back to where it was called +4
###############################################################

# Begin subroutine
vbsme:  
    li      $v0, 0              # reset $v0 and $v1
    li      $v1, 0

    # insert your code here
    addi $sp, $sp, -4
    sw $ra, 0($sp);                                  #store ra = backtomain
    move $v0, $0                                     #v0 stores best addrSAD row
    move $v1, $0                                     #v1 stores best addrSAD col
    addi $s2, $0, 32767                              #$s2 stores best SAD min, initialize to large number 2^32-1

    ############################################################### THIS IS WHERE ZIG-ZAG SHOULD BE IMPLEMENTED
    li $s7, 0 # set index to 0
    lw $s3, 0($a0) # get frame rows (i)
    lw $s4, 4($a0) # get frame columns (j)
    lw $s5, 8($a0) # get window rows (k)
    lw $s6, 12($a0) # get window columns (l)

    jal SAD

zLoop: # main zigzag loop
    mult $s3, $s4 # i * j
    mflo $t0
    addi $t1, $s5, -1 # k - 1
    mult $s4, $t1 # j * (k - 1)
    mflo $t1
    sub $t0, $t0, $s6 # (i * j) - l
    sub $t0, $t0, $t1 # ((i * j) - l) - (j * (k - 1)) in $t0
    slt $t0, $s7, $t0 # index < $t0
    beq $t0, $0, exitz # if index >= $t0 (bottom right reached), exit zig-zag routine

    sub $t0, $s4, $s6 # j - l
    slt $t0, $s7, $t0 # index < (j - l), checks if top border reached
    bne $t0, $0, zIf1 # if top border reached, go into if statement
    j zElse1 # else go into else statement

zIf1:
    addi $s7, $s7, 1 # move index right
    j zCont1 # skip else statment

zElse1:
    add $s7, $s7, $s4 # move index down

zCont1:
    jal SAD

zWhile1:
    sub $t0, $s7, $s4 # index - j

mLoop1:
    slt $t1, $t0, $s4 # if $t0 < j
    bne $t1, $0, mExit1 # continue
    sub $t0, $t0, $s4 # else $t0 - j
    j mLoop1

mExit1:
    beq $t0, $0, zCont2 # if index % j = 0 (left border), exit loop
    
    mult $s3, $s4 # i * j
    mflo $t0
    mult $s4, $s5 # j * k
    mflo $t1
    sub $t0, $t0, $t1 # (i * j) - (j * k)
    slt $t0, $s7, $t0 # index < (i * j) - (j * k)
    beq $t0, $0, zCont2 # if index >= (i * j) - (j * k) (bottom border), exit loop
    
    add $s7, $s7, $s4 # else if left/bottom border not reached,
    addi $s7, $s7, -1 # move index down-left
    jal SAD
    j zWhile1 # loop until left/bottom border reached

zCont2:
    mult $s3, $s4 # i * j
    mflo $t0
    addi $t1, $s5, -1 # k - 1
    mult $s4, $t1 # j * (k - 1)
    mflo $t1
    sub $t0, $t0, $s6 # (i * j) - l
    sub $t0, $t0, $t1 # ((i * j) - l) - (j * (k - 1)) in $t0
    slt $t0, $s7, $t0 # index < $t0
    beq $t0, $0, exitz # if index >= $t0 (bottom right reached), exit zig-zag routine
    
    mult $s3, $s4 # i * j
    mflo $t0
    mult $s4, $s5 # j * k
    mflo $t1
    sub $t0, $t0, $t1 # (i * j) - (j * k)
    slt $t0, $s7, $t0 # index < (i * j) - (j * k)
    bne $t0, $0, zIf2 # if bottom border reached, go into if statment
    j zElse2 # else go into else statement

zIf2:
    add $s7, $s7, $s4 # move index down
    j zCont3

zElse2:
    addi $s7, $s7, 1 # move index right

zCont3:
    jal SAD

zWhile2:
    sub $t0, $s4, $s6 # j - l
    slt $t0, $t0, $s7 # index > (j - l)
    beq $t0, $0, zLoop # if top border reached, exit loop

    add $t0, $s7, $s6 # index + l
    sub $t0, $t0, $s4 # (index + l) - j

mLoop2:
    slt $t1, $t0, $s4 # if $t0 < j
    bne $t1, $0, mExit2 # continue
    sub $t0, $t0, $s4 # else $t0 - j
    j mLoop2

mExit2:
    beq $t0, $0, zLoop # if (index + l) % j = 0 (right border), exit loop

    sub $s7, $s7, $s4 # else if top/right border not reached,
    addi $s7, $s7, 1 # move index up-right
    jal SAD
    j zWhile2 # loop until top/right border reached

exitz: # exit zig-zag routine
    ############################################################### THIS IS WHERE ZIG-ZAG SHOULD BE IMPLEMENTED

    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

##############################################################################################################################
#SAD function begins
SAD:
    move $t0, $0                                     #t0 is current base address of frame
    move $t1, $0                                     #t1 is current base address of window

    addi $sp, $sp, -8                                #allocate space on stack
    sw $ra, 4($sp)                                   #store ra = backtovbsme
    sw $0, 0($sp)                                    #stack used to add up SAD

    lw $t2, 12($a0)
    addi $t2, $t2, -1                                #t2 = sizeofwindowcol-1 (used to check when to increment to nextrow)

    lw $t5, 8($a0)
    lw $t7, 12($a0)
    move $t6, $0
multiply: 
    add $t6, $t6, $t7
    addi $t5, $t5, -1
    bne $t5, $0, multiply
    addi $t6, $t6, -1                                #t6 = (sizeofwindowcol*sizeofwindowcol)-1 = sizeofwindow-1 (used to check when to exit loop)

    move $t7, $0                                     #t7 keeps track of col index

loop:
    jal rEfA1                                        #t3 = element of frame index
    jal rEfA2                                        #t4 = element of window index
    slt $t5, $t3, $t4                                
    beq $t5, $0, switch                              #if t3 >= t4 -> switch (used to calculate 'absolute' difference)
    sub $t4, $t4, $t3                                #else t4 = t4-t3
    j store
switch:     
    sub $t4, $t3, $t4                                #t4 = t3-t4
store:
    lw $t5, 0($sp)
    add $t4, $t4, $t5          
    sw $t4, 0($sp)                                   #update SAD into stack   
    beq $t6, $t1, compare                            #if t1 = sizeofwindow-1 -> compare (exit loop when last element has been added to SAD)
    addi $t1, $t1, 1                                 #else t1++
    beq $t7, $t2, nextrow                            #if t7==sizeofwindowcol-1 -> nextrow (jump to nextrow if last element of a row has been accessed)
    addi $t0, $t0, 1                                 #else t0++ 
    addi $t7, $t7, 1                                 #t7++
    j loop
nextrow:
    lw $t5, 4($a0)
    add $t0, $t0, $t5
    lw $t5, 12($a0)
    sub $t0, $t0, $t5                                
    addi $t0, $t0, 1                                 #t0 = $t0 + sizeofframecol - sizeofwindowcol + 1 (get new index on next line)
    move $t7, $0                                     #t7 = 0 (reset to new col index of nextrow)
    j loop

#compare to see if new calculated SAD is <= minimum SAD
compare:
    lw $t5, 0($sp)
    slt $t6, $t5, $s2                               
    bne $t6, $0, update                              #if t5 < s2 -> update
    beq $t5, $s2, update                             #if t5 == s2 -> update
    add $sp, $sp, 4                                  #else clear stack and return
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra

#update minimum into s2, calculate row_index into v0 and col_index into v1 based on s7
update:
    move $s2, $t5                                    #update minimum s2
    
    move $t0, $0                                     #t0 increments to s7
    move $t1, $0                                     #t1 keeps track of rows
    move $t2, $0                                     #t2 keeps track of col
    lw $t3, 4($a0)                                   #t3 = size_of_frame_col                                
    beq $t0, $s7, done                               #check before incrementing t0, used when t0 = 0 to avoid infinite loop
getRowCol:
    addi $t0, $t0, 1                                 #t0++
    addi $t2, $t2, 1                                 #t2++
    bne $t2, $t3, continue                           #if t2 != t3 -> continue (if col_index is not size_of_frame_col)
    addi $t1, $t1, 1                                 #else t1++ (new row achieved)
    move $t2, $0                                     #t2 = 0 (reset to new col index of nextrow)
continue:
    bne $t0, $s7, getRowCol                          #if t0 != s7 -> getRowCol

done:
    move $v0, $t1                                    #v0 = $t1 = row_index
    move $v1, $t2                                    #v1 = $t1 = col_index
    # new code to move into v0 and v1

    add $sp, $sp, 4                                  #clear stack and return
    lw $ra, 0($sp)
    add $sp, $sp, 4
    jr $ra
##############################################################################################################################