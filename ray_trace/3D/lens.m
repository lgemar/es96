classdef lens
  properties
    w % width at center
    r % radius
    R1 % radius of curvature 1
    R2 % radius of curvature 2
    N % normal ray
    C % Center of the lens
    P1 % (x,y,z) coordinants of sphere with radius R1
    P2 % (x,y,z) coordinants of sphere with radius R2
    F1 % face 1
    F2 % face 2
    phiR1Max % Maximum phi for sphere with radius R1
    thetaR1Max % Maximum theta for sphere with radius R1
    phiR2Max % Maximum phi for sphere with radius R2
    thetaR2Max % Maximum theta for sphere with radius R2
    color
  end
  methods
    function L = lens(x, y, z, w, r, R1, R2, N)
      % L = lens(w, r, R1, R2, N);
      L.w = w;
      L.r = r;
      L.R1 = R1;
      L.R2 = R2;
      L.N = N;
      L.color = [.5 .5 1];
      L.C = [x y z];
      L.P1 = [0 0 0];
      L.P2 = [0 0 0];
      L.P1(1) = L.C(1) - sqrt((L.R1-(w/2))^2 - L.C(3)^2*(1-(w/2)*L.R1)^2 + L.C(2)^2*((L.R1-(w/2))^2 - L.C(3)^2*(1-(w/2)*L.R1)^2)/(L.R1^2 + L.C(3)^2));
      L.P2(1) = L.C(1) + sqrt((L.R2-(w/2))^2 - L.C(3)^2*(1-(w/2)*L.R2)^2 + L.C(2)^2*((L.R2-(w/2))^2 - L.C(3)^2*(1-(w/2)*L.R2)^2)/(L.R2^2 + L.C(3)^2));
       
      R.phiR1Max = acos(L.r/L.R1);
      R.thetaR1Max = asin(L.r/L.R1);
     
      R.phiR2Max = acos(L.r/L.R2);
      R.thetaR2Max = asin(L.r/L.R2);
      
      
      
      
    
    end
  end
end
