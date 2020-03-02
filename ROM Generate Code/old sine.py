import math
#for max use 2^x-1
bits=9
m=(2**bits)
print("reg ["+str(bits+26-1)+" : 0] f[63:0][2:0]; //f max 26' by "+str(bits)+"' = "+str(bits+26)+"'")
print()  
print("  initial begin")
print("    div=50000000/freq; //div max is 26bits")
for x in range(32):
    print("f["+str(x)+"][0]=div*"+str(int(round((math.asin(1-(1/64)*(x*2+1))/(2*math.pi))*m,0)))+">>"+str(bits)+";"+"f["+str(x)+"][1]=div*"+str(int(round((0.5-math.asin(1-(1/64)*(x*2+1))/(2*math.pi))*m,0)))+">>"+str(bits)+";"+"f["+str(x)+"][2]=div+1'b1;")
for x in range(32,64):
    print("f["+str(x)+"][0]=0;"+"f["+str(x)+"][1]=div*"+str(int(round((1-(math.asin(1-(1/64)*(x*2+1))/(2*math.pi)+.5))*m,0)))+">>"+str(bits)+";"+"f["+str(x)+"][2]=div*"+str(int(round((1-(0.5-math.asin(1-(1/64)*(x*2+1))/(2*math.pi))+.5)*m,0)))+">>"+str(bits)+";")
    
