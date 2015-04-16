function lense3d( x, y, r, R_CX, R_CC, ct)
% r is the radius of the lense.
% R_CX and R_CC are the radi of curvature, convex and concave
N = 100;
Nr = 100;

a = [0:N N-1:-1:0]'/N;
dx = [ ones(1,N+1) (-ones(1,N)) ]';
X1 = x - dx(1:N+1) .* (sqrt(R_CX^2-a(1:N+1).^2*r^2) - sqrt(R_CX^2-r^2));
X2 = x + dx(N+2:end) .* (sqrt(R_CC^2-a(N+2:end).^2*r^2) - sqrt(R_CC^2-r^2));
% curr_width = X2(end) - X1(1);
% X2 = X2 + ct - curr_width; % difference between what width should be
displacement = (x - ct/2) - X1(1);
X = [X1;X2];
X = X + displacement;

a = [0:N N-1:-1:0]'/N;
th = (0:Nr)*2*pi/Nr;
Y = y+a*r*cos(th);
Z = a*r*sin(th);
X = X * ones(size(th));
surfl(X',Y',Z','light');
%axis equal;
colormap copper;
shading flat;
set(gca,'dataaspectratio',[1 1 1]);

