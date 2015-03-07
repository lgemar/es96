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
    function R = intersect_ray(R,R2)
      % R1.interect_ray(R2);
      % Extends R1 to a point where it interects R2
      M = [-R.D(2) R.D(1); -R2.D(2) R2.D(1)];
      A = [R.O(2)*R.D(1)-R.O(1)*R.D(2); R2.O(2)*R2.D(1)-R2.O(1)*R2.D(2)];
      R.E = (M\A)';
    end
    function R = intersect_arc(R,A)
      % R.interect_arc(A);
      % Extends R to a point where it interects arc A
      % First check that R starts inside A's circle
      if sum((R.O-A.ctr).^2) >= A.R^2
        error('Ray not inside arc''s circle');
      end
      % Now as we travel along ray from R.O to R.D, the distance
      % from A.ctr will increase from < R to >R
      dtoarc = @(x) sum((R.O + x*R.D - A.ctr).^2) - A.R^2;
      x = fzero(dtoarc, 2*A.R);
      if x < 0
        error('Wrong intersection found');
      end
      R.E = R.O + x*R.D;
    end
    function [R,Rr] = reflect_arc(R,A)
      % [R,Rr] = R.reflect_arc(A);
      % Propagate ray R until it intersects arc A,
      % then return reflecting ray Rr.
      R = R.intersect_arc(A);
      N = A.normal(R.E);
      Rr = ray(R.E, R.D - 2 * sum(N.*R.D)*N);
    end
    function [h_out, th_out] = draw(R, varargin)
      x = [R.O(1) R.E(1)];
      y = [R.O(2) R.E(2)];
      h = plot(x, y, 'r');
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
      % R.propagate;
      % Switches endpoint to origin and extends endpoint along direction
      R.O = R.E;
      if nargin < 2
        distance = 1;
      end
      R.E = R.O + distance*R.D;
    end
  end
end
