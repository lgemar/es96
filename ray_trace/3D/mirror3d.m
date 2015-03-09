function mirror3d( x, y, dir, w, r, R )
% mirror3d( x, y, dir, w, r );
% Draws a 3d mirror with the back face centered at
% (x,y,0) facing in the + or - x direction, depending
% on dir. Width is w, radius is r.
resolution = 50;
dir = sign(dir);
th = (0:resolution)*2*pi/resolution;
X = x * ones(1,resolution+1);
X = [ X; X; X+w*dir; X+w*dir ];
Y = y + r * cos(th);
Y = [ ones(size(Y))*y; Y; Y; ones(size(Y))*y ];
Z = r * sin(th);
Z = [zeros(size(Z)); Z; Z; zeros(size(Z)) ];
surfl(X,Y,Z);
shading flat;
set(gca,'dataaspectratio',[1 1 1]);

%%
angle_max = asin(r/R); % max angle for mirror as spherical cap

theta=linspace(-angle_max,angle_max,resolution);
phi=linspace(pi/2-angle_max,pi/2+angle_max,resolution);
[phi,theta]=meshgrid(phi,theta);

% for i=1:resolution
%     if abs(theta(i)^2+(phi(i)-pi/2)^2) > angle_max^2
%         theta(i)=[]; phi(i)=[];
%     end
% end

x=R*sin(phi).*cos(theta);
y=R*sin(phi).*sin(theta);
z=R*cos(phi); 

surf(x,y,z);

