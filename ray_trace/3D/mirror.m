classdef mirror
  properties
    r % radius of mirror
    R % radius of curavture
    w % thickness of lens at center
    P0 % position of center of mirror
    normal % normal to the mirror 
    ctr % center of big circle drawn out by mirror
    color % mirror color in animation
    backside % equation of the plane
    face % equation of the arc
  end
  methods
    function M = mirror(r, R, w, P0, normal)
    % M = mirror(ax, r, R, w, P0, normal);
      M.r = r;
      M.R = R;
      M.w = w;
      M.P0 = P0;
      M.normal = normal/norm(normal);
      M.ctr = P0 + R*M.normal;
      M.color = [.5 .5 1];
      
      perp = cross(M.normal,[1 1 1]); % perpendicular vector 
      if isequal(perp,[0 0 0])
          perp = cross( M.normal , [1 1 0]);
      end
      RM = [ M.normal; perp]; % reflection matrix
      
      
      % **** TODO: this requires synchronized changes in ray and arc ****
      M.backside = ray(M.P0 + [-M.w -M.r]*RM, [0 1]*RM);
      % Point P = P0 - [w 0 0]*M.normal;
      % and normal vector = M.normal;
      M.face = arc(M.P0 + [M.R 0]*RM, M.R, [-th_max th_max]);
      % eqn of sphere is x = R + sqrt(R^2-y^2-z^2);
    end
  end % End of methods block
end % End of classdef block
