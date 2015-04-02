classdef lens
  properties
    ct % center thickness
    r % radius
    R_CX % radius of curvature 1
    R_CC % radius of curvature 2
    N % normal ray
    x % Center of the FIRST FACE of lens, x-coordinate
    P1 % (x,y,z) coordinants of sphere with radius R_CX
    P2 % (x,y,z) coordinants of sphere with radius R_CC
    F1 % face 1
    F2 % face 2
    phiR_CXMax % Maximum phi for sphere with radius R_CX
    thetaR_CXMax % Maximum theta for sphere with radius R_CX
    phiR_CCMax % Maximum phi for sphere with radius R_CC
    thetaR_CCMax % Maximum theta for sphere with radius R_CC
    color
  end
  methods
    function L = lens(x, ct, r, R_CX, R_CC, N)
      % L = lens(w, r, R_CX, R_CC, N);
      L.ct = ct;
      L.r = r;
      L.R_CX = R_CX;
      L.R_CC = R_CC;
      L.N = N;
      L.color = [.5 .5 1];
      L.x = x;
      L.P1 = [0 0 0];
      L.P2 = [0 0 0];
      L.P1(1) = L.x;
      L.P2(1) = L.x + sqrt((L.R_CC-L.ct)^2 / L.R_CC^2 );
       
      R.phiR_CXMax = acos(L.r/L.R_CX);
      R.thetaR_CXMax = asin(L.r/L.R_CX);
     
      R.phiR_CCMax = acos(L.r/L.R_CC);
      R.thetaR_CCMax = asin(L.r/L.R_CC);
    
    end
  end
end
