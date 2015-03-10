classdef ray
  properties
    O % origin
    D % direction
    E % endpoint
  end
  methods
    function R = ray(O, D)
      % R = ray(O, D);
      R.O = O;
      R.D = D/sqrt(sum(D.^2));
      R.E = O+D;
    end
    function R = intersect_plane(R, P)
        % Ray.intersect_plane(Plane)
        % Extends Ray to a point where it intersects plane P
        d = dot(P.point - R.O, P.normal) / dot(R.D, P.normal);
        R.E = d*R.D + R.O;
    end
    function R = intersect_arc(R,A)
      % R.interect_arc(A);
      % Extends R to a point where it interects arc A
      % First check that R starts inside A's circle
      intersect_point = ray_sphere_solver(R.O, R.E, A.ctr, A.R); 
      R.E = intersect_point'; 
    end
    function [R,Rr] = reflect_arc(R,A)
      % [R,Rr] = R.reflect_arc(A);
      % Propagate ray R until it intersects arc A,
      % then return reflecting ray Rr.
      intersect_point = ray_sphere_solver(R.O, R.E, A.ctr, A.R); 
      intersect_point = intersect_point'; 
      N = A.normal(intersect_point);
      new_direction = reflect_ray(R.O, R.E, N);
      new_direction = new_direction';
      R = R.intersect_arc(A); 
      Rr = ray(R.E, new_direction);
    end
    function [h_out, th_out] = draw(R, varargin)
	  % draw the raw from origin to endpoint
      x = [R.O(1) R.E(1)];
      y = [R.O(2) R.E(2)];
      z = [R.O(3) R.E(3)];
      h = plot3(x, y, z, 'r');
      % TODO: figure out what this does
      if ~isempty(varargin)
        th = mtext(mean(x), mean(y), varargin{:});
      end
      if nargout > 0
        h_out = h;
        if nargout > 1
          th_out = th;
        end
      end
    end
    function R = propagate(R, distance)
      % This should be fine for 3D 
      % R.propagate;
      % Switches endpoint to origin and extends endpoint along direction
      % R.O = R.E;
      if nargin < 2
        % Defines a default distance to travel
        distance = 1;
      end
      R.E = R.O + distance*R.D;
    end
  end
end
