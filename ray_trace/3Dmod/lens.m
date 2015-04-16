classdef lens
    % 
    properties
        x % Center of the FIRST FACE of lens, x-coordinate
        r % radius
        R_CX % radius of curvature 1
        R_CC % radius of curvature 2
        ct % center thickness
        dir % normal ray for direction (facing detector)
        ctr1 % (x,y,z) coordinants of center of sphere with radius R_CX
        ctr2 % (x,y,z) coordinants of center of sphere with radius R_CC
        F1 % face 1
        F2 % face 2
%         phiR_CXMax % Maximum phi for sphere with radius R_CX
%         thetaR_CXMax % Maximum theta for sphere with radius R_CX
%         phiR_CCMax % Maximum phi for sphere with radius R_CC
%         thetaR_CCMax % Maximum theta for sphere with radius R_CC
    end
    
    methods
        function L = lens(x, r, R_CX, R_CC, ct, dir)
            % L = lens(w, r, R_CX, R_CC, N);
            L.x = x;
            L.r = r;
            L.R_CX = R_CX;
            L.R_CC = R_CC;
            L.ct = ct;
            L.dir = dir;
            L.ctr1 = [L.x+R_CX 0 0];
            L.ctr2 = [L.x+L.ct+R_CC 0 0];
            [x,y,z] = sphere(
            L.F1 = ;
            L.F2 = ;

%             R.phiR_CXMax = acos(L.r/L.R_CX);
%             R.thetaR_CXMax = asin(L.r/L.R_CX);
%             R.phiR_CCMax = acos(L.r/L.R_CC);
%             R.thetaR_CCMax = asin(L.r/L.R_CC);
        end
    end
end
