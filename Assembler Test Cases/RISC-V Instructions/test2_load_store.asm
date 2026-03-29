addiw x1, x0, 0       
addiw x2, x0, 100     
sw    x2, 0(x1)       
sw    x2, 4(x1)       
lw    x3, 0(x1)       
lw    x4, 4(x1)       
addw  x5, x3, x4      