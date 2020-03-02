import math
#for max use 2^x-1
bits=6
m=(2**bits)-1
print ("//Begin ROM, resolution: "+str(bits)+" bits")
for x in range(m+1):
    print("sine_rom["+str(x)+"]="+str(int(round((math.sin(x*2*math.pi/m)*m/2+m/2)))), end=';')
print ("\n//End ROM ")    
