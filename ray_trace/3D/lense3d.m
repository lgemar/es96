function lense3d( x, y, r, R_CX, R_CC)
% r is the radius of the lense.
% R_CX and R_CC are the radi of curvature, convex and concave
N = 15;
Nr = 100;

a = [0:N N-1:-1:0]'/N;
dx = [ ones(1,N+1) (-ones(1,N)) ]';
X1 = x - dx(1:N+1) .* (sqrt(R_CC^2-a(1:N+1).^2*r^2) - sqrt(R_CC^2-r^2));
X2 = x + dx(N+2:end) .* (sqrt(R_CX^2-a(N+2:end).^2*r^2) - sqrt(R_CX^2-r^2));
X = [X1;X2];

a = [0:N N-1:-1:0]'/N;
th = (0:Nr)*2*pi/Nr;
Y = y+a*r*cos(th);
Z = a*r*sin(th);
X = X * ones(size(th));
surfl(X',Y',Z','light');
colormap copper;
shading flat;
set(gca,'dataaspectratio',[1 1 1]);

