classdef mirror
  properties
    r
    R
    w
    P0
    normal
    ctr
    color
    backside
    face
  end
  methods
    function M = mirror(r, R, w, P0, normal)
    % M = mirror(ax, r, R, w, P0, normal);
      M.r = r;
      M.R = R;
      M.w = w;
      M.P0 = P0;
      M.normal = normal/sqrt(sum(normal.^2));
      M.ctr = P0 + R*M.normal;
      M.color = [.5 .5 1];
      
      perp = M.normal * [0 1; -1 0];
      RM = [ M.normal; perp];
      th_max = asin(M.r/M.R);
      theta = th_max * [-1:.2:1]';
      x = [-w; -w; R*(1-cos(theta)); -w];
      y = [r; -r; R*sin(theta); r];
      xy = [x,y]*RM + ones(length(x),1)*M.P0;
      fill(xy(:,1),xy(:,2),M.color);
      M.backside = ray(M.P0 + [-M.w -M.r]*RM, [0 1]*RM);
      M.face = arc(M.P0 + [M.R 0]*RM, M.R, [-th_max th_max]);
    end
  end % End of methods block
end % End of classdef block