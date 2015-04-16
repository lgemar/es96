classdef lens
    % 
    properties
        x % Center of the FIRST FACE of lens, x-coordinate
        r % radius
        R_CX % radius of curvature 1
        R_CC % radius of curvature 2
        ct % center thickness
        ctr1 % (x,y,z) coordinants of center of sphere with radius R_CX
        ctr2 % (x,y,z) coordinants of center of sphere with radius R_CC

    end
    
    methods
        function L = lens(x, r, R_CX, R_CC, ct)
            % L = lens(w, r, R_CX, R_CC, N);
            L.x = x;
            L.r = r;
            L.R_CX = R_CX;
            L.R_CC = R_CC;
            L.ct = ct;
            L.ctr1 = [L.x+R_CX 0 0];
            L.ctr2 = [L.x+L.ct+R_CC 0 0];

        end
    end
end
