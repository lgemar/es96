function area = overlap(d)  
r = 0.059; 
if( d > 2 * r )
    area = 0; 
else
    area = r^2 * acos(d / (2*r)) - d/4 * sqrt(4 * r^2 - d^2); 
end