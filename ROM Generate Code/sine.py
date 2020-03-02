import math
#for max use 2^x-1
bits=9
m=(2**bits)
print ("//Begin ROM, scaling factor "+str(m))
for x in range(32):
    print("sine_rom["+str(x)+"][0]="+str(int(round((math.asin(1-(1/64)*(x*2+1))/(2*math.pi))*m,0)))+";"+"sine_rom["+str(x)+"][1]="+str(int(round((0.5-math.asin(1-(1/64)*(x*2+1))/(2*math.pi))*m,0)))+";"+"sine_rom["+str(x)+"][2]="+str(m*1)+";")
for x in range(32,64):
    print("sine_rom["+str(x)+"][0]=0;"+"sine_rom["+str(x)+"][1]="+str(int(round((1-(math.asin(1-(1/64)*(x*2+1))/(2*math.pi)+.5))*m,0)))+";"+"sine_rom["+str(x)+"][2]="+str(int(round((1-(0.5-math.asin(1-(1/64)*(x*2+1))/(2*math.pi))+.5)*m,0)))+";")
print ("//End ROM ")    
