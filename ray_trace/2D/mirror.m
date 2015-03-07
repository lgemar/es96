classdef mirror
  properties
    r %radius
    R %radius of curavture
    w % thickness of lens at center
    P0 % 
    normal % normal to the mirror 
    ctr % center of big circle drawn out by mirror
    color % mirror color in animation
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
      
      perp = M.normal * [0 1; -1 0]; % clockwise rotation of normal by 90 degress
      RM = [ M.normal; perp]; % reflection matrix
      th_max = asin(M.r/M.R); % theta max
      theta = th_max * [-1:.2:1]';
      x = [-w; -w; R*(1-cos(theta)); -w]; 
      y = [r; -r; R*sin(theta); r];
      xy = [x,y]*RM + ones(length(x),1)*M.P0; % x outline of mirror shape
      fill(xy(:,1),xy(:,2),M.color); % fill polygon of mirror shape
      M.backside = ray(M.P0 + [-M.w -M.r]*RM, [0 1]*RM);
      M.face = arc(M.P0 + [M.R 0]*RM, M.R, [-th_max th_max]);
    end
  end % End of methods block
end % End of classdef block
