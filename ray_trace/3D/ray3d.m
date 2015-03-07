function h = ray3d( x0, x1, y, r, dth, N0, N1, x2, x3 );
% h = ray3d( x0, x1, y, r, dth, N0, N1 );
% Draws rays from pass N0 to N1 between mirror
% surfaces at x0 and x1 (x0 < x1). y is specified.
% z is 0. r is the radius of the beams. dth is
% the angle through which the beam rotates on one
% pass.
% If x2 and x3 are specified, exit beams are included
% which go straight to x2, then converge at x3.
Nmin = floor(N0);
Nmax = ceil(N1);
N = [Nmin:Nmax];
th = N*dth;
xi = [ x0, x1 ];
X = xi(mod(N,2)+1);
Y = -r*sin(th);
Z = r*cos(th);
if N0 > N(1)
  NV = N(1:2);
  X(1) = interp1(NV,X(1:2),N0);
  Y(1) = interp1(NV,Y(1:2),N0);
  Z(1) = interp1(NV,Z(1:2),N0);
end
if N1 < N(end)
  i = [length(N)-1 length(N)];
  NV = N(i);
  X(end) = interp1(NV,X(i),N1);
  Y(end) = interp1(NV,Y(i),N1);
  Z(end) = interp1(NV,Z(i),N1);
end
h = plot3(X,Y,Z);

% Handle exit rays
i = find(mod(N,2) & N<N1 & N>N0);
if nargin >= 9 & length(i) > 0
  onei = ones(1,length(i));
  XE = [ X(i); x2*onei; x3*onei ];
  YE = [ Y(i); Y(i); y*onei ];
  ZE = [ Z(i); Z(i); 0*onei ];
  h = [ h; plot3(XE,YE,ZE) ];
end
