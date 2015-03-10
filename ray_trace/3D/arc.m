classdef arc
  properties
    ctr % 
    R % radius of curvature
    angle % max angle to sweep
    x
    y
    z
  end
  methods
    function A = arc(ctr, R, angle)
      A.ctr = ctr;
      A.R = R;
      A.angle = angle;
      thetas = -A.angle + A.angle*[0:.001:2]';
      phis = -A.angle+pi/2 + A.angle*[0:.001:2]';
      A.x = A.ctr(1) + R*cos(thetas)*sin(phis)';
      A.y = A.ctr(2) + R*sin(thetas)*sin(phis)';
      A.z = A.ctr(3) + R*cos(phis);
    end
    function n = normal(A, P)
      % n = A.normal(P);
      % Returns a unit normal vector at the point P
      n = A.ctr - P;
      n = n/sqrt(sum(n.^2));
    end
  end
end