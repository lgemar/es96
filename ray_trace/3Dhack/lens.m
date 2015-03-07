classdef lens
  properties
    w % width at edges
    r % radius
    R % radius of curvature
    N % normal ray
    F1 % face 1
    F2 % face 2
    halfangle
    rotangle
    color
  end
  methods
    function L = lens(w, r, R, N)
      % L = lens(w, r, R, N);
      L.w = w;
      L.r = r;
      L.R = R;
      L.N = N;
      L.color = [.5 .5 1];
      L.halfangle = asin(L.r/L.R);
      L.rotangle = atan2(N.D(2), N.D(1));
      L.F1 = arc(L.N.O+(L.w/2-L.R*cos(L.halfangle))*L.N.D, L.R, [-L.halfangle L.halfangle]+L.rotangle);
      L.F2 = arc(L.N.O-(L.w/2-L.R*cos(L.halfangle))*L.N.D, L.R, [-L.halfangle L.halfangle]+L.rotangle+pi);
      fill([L.F1.x; L.F2.x; L.F1.x(1)], [L.F1.y; L.F2.y; L.F1.y(1)], L.color);
    end
  end
end
