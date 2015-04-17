classdef mirror
    %
    
    properties
        x % Center of face, x-coordinate
        r % radius
        R % radius of curvature
        ctr % (x,y,z) coordinants of center of sphere
        reflect % reflectivity
    end
    
    methods
        function M = mirror(x, r, R, reflect)
            
            M.x = x;
            M.r = r;
            M.R = R;
            M.ctr = [M.x+M.R;0;0];
            M.reflect = reflect;
            
        end
            
        
    end
    
end

