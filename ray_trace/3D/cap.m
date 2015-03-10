classdef cap
  properties
    ctr % 
    R % radius of curvature
    theta % max theta to sweep
    phi % max phi to sweep
    x
    y
    z
  end
  methods
      function C = cap(ctr, R, theta, phi)
      C.ctr = ctr;
      C.R = R;
      C.theta = theta;
      C.phi = phi;
      thetas = -C.theta + C.theta*[0:.001:2]';
      phis = -C.phi + C.phi*[0:.001:2]';
      C.x = C.ctr(1) + R*cos(thetas)*sin(phis)';
      C.y = C.ctr(2) + R*sin(thetas)*sin(phis)';
      C.z = C.ctr(3) + R*cos(phis);
    end
    function n = normal(A, P)
      % n = A.normal(P);
      % Returns a unit normal vector at the point P
      n = A.ctr - P;
      n = n/sqrt(sum(n.^2));
    end
  end
end