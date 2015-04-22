classdef mirror
    %
    
    properties
        x % Center of face, x-coordinate
        r % radius
        R % radius of curvature
        ctr % (x,y,z) coordinants of center of sphere
        reflect % reflectivity
        ctr_thick % center thickness
    end
    
    methods
        function M = mirror(x, r, R, dir, reflect, ctr_thick)
            
            M.x = x;
            M.r = r;
            M.R = R;
            M.ctr = [M.x+dir*M.R;0;0];
            M.reflect = reflect;
            M.ctr_thick = ctr_thick;
            
        end
            
        
    end
    
end

