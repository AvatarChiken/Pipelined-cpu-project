addiw x1, x0, 1        
addiw x2, x0, 5        
addiw x3, x0, 0        
addiw x4, x0, 1        
addw  x3, x3, x1       
l1: addw  x1, x1, x4       
bge   x2, x1, l1      
addiw x5, x0, 15
bne   x3, x5, l2        
addiw x6, x0, 1        
l2: