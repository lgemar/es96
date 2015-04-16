classdef mirror
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x % Center of face, x-coordinate
        r % radius
        R % radius of curvature
        dir % normal ray for direction (facing detector)
        ctr % (x,y,z) coordinants of center of sphere
        F % face
        reflect % reflectivity
    end
    
    methods
        function M = createmirror(x, dir, r, R, reflect)
            L.x = x;
            L.r = r;
            L.R = R;
            L.dir = dir;
            L.ctr = [L.x+L.R 0 0];
            L.F = sphere;
            L.reflect = reflect;
        end
            
        
    end
    
end

