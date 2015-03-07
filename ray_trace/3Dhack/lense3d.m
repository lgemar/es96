function lense3d( x, y, r, R )
% lense3d( x, y, r, R );
% r is the radius of the lense.
% R is the radius of curvature of lense
N = 15;
Nr = 50;
a = [0:N N-1:-1:0]'/N;
dx = [ ones(1,N+1) (-ones(1,N)) ]';
X = x + dx .* (sqrt(R^2-a.^2*r^2) - sqrt(R^2-r^2));
th = (0:Nr)*2*pi/Nr;
Y = y+a*r*cos(th);
Z = a*r*sin(th);
X = X * ones(size(th));
surfl(X',Y',Z','light');
colormap copper;
shading flat;
set(gca,'dataaspectratio',[1 1 1]);

