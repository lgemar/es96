classdef arc
  properties
    ctr
    R
    thetas
    x
    y
  end
  methods
    function A = arc(ctr, R, thetas)
      A.ctr = ctr;
      A.R = R;
      A.thetas = thetas;
      theta = thetas(1) + (thetas(2)-thetas(1))*[0:.05:1]';
      A.x = A.ctr(1) + R*cos(theta);
      A.y = A.ctr(2) + R*sin(theta);
    end
    function n = normal(A, P)
      % n = A.normal(P);
      % Returns a unit normal vector at the point P
      n = A.ctr - P;
      n = n/sqrt(sum(n.^2));
    end
  end
end