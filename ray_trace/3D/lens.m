classdef lens
  properties
    w % width at center
    r % radius
    R1 % radius of curvature 1
    R2 % radius of curvature 2
    N % normal ray
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
      
      L.P1 = [x y z];
      L.P2 = [x y z];
      L.P1(1) = L.P1(1) - sqrt((L.R1-(w/2))^2 - L.P1(3)^2*(1-(w/2)*L.R1)^2 + L.P1(2)^2*((L.R1-(w/2))^2 - L.P1(3)^2*(1-(w/2)*L.R1)^2)/(L.R1^2 + L.P1(3)^2));
      L.P2(1) = L.P2(1) + sqrt((L.R2-(w/2))^2 - L.P2(3)^2*(1-(w/2)*L.R2)^2 + L.P2(2)^2*((L.R2-(w/2))^2 - L.P2(3)^2*(1-(w/2)*L.R2)^2)/(L.R2^2 + L.P2(3)^2));
    
    
    end
  end
end
