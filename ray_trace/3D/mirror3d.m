function mirror3d( x, y, dir, w, r, R )
% mirror3d( x, y, dir, w, r );
% Draws a 3d mirror with the back face centered at
% (x,y,0) facing in the + or - x direction, depending
% on dir. Width is w, radius is r.
resolution = 50;
dir = sign(dir);


hold all; 


angle_max = asin(r/R); % max angle for mirror as spherical cap

% ***eventually can remove this and use arc(ctr, R, angle_max);
theta=linspace(-angle_max,angle_max,resolution);
phi=linspace(pi/2-angle_max,pi/2+angle_max,resolution);
[phi,theta]=meshgrid(phi,theta);

for i=1:resolution
    for j = 1:resolution
        if (abs(theta(i,j)^2+(phi(i,j)-pi/2)^2)) > (angle_max^2)
            theta(i,j)=NaN; phi(i,j)=NaN;
        end
    end
end

A=R*sin(phi).*cos(theta)*-dir + R;
B=R*sin(phi).*sin(theta);
C=R*cos(phi); 



th = (1:resolution)*2*pi/resolution;
X = x * ones(1,resolution);
X = [ X; X; X+w*dir; X+w*dir ];
Y = y + r * cos(th);
Y = [ y*ones(size(Y)); Y; Y; y*ones(size(Y)) ];
Z = r * sin(th);
Z = [ zeros(size(Z)); Z; Z; zeros(size(Z)) ];

size(A)
size(B)
size(C)
size(X)
size(Y)
size(Z)


surfl(X,Y,Z);
shading flat;
set(gca,'dataaspectratio',[1 1 1]);

