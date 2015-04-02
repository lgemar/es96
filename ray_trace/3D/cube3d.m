function h = cube3d(v0,l)
% cube3d(v0,l);
% Draws a cube with one vertex at (x0,y0,z0) and
% sides of length l.

% Try it with patches:
% Want 6 surfaces, hence 6 columns each with 5 rows
% The faces are:
%  x = x0, x = x0+l
%  y = y0, y = y0+l
%  z = z0, z = z0+l
% The non-primary sides cycle through:
% z = zeros(5,1);
% o = ones(5,1);
% a = [ 0; 1; 1; 0; 0];
% b = [ 0; 0; 1; 1; 0];
% X = [ z; o; a; a; a; a ] * l + x0;
% Y = [ a; a; z; o; b; b ] * l + y0;
% Z = [ b; b; b; b; z; o ] * l + z0;
% h = patch(X,Y,Z,[0 1 0],'facevertexcdata',[0 1 0]);

if length(l) == 1
  l = l*ones(3,1);
end
v = zeros(8,3);
vi = [0:7]';
for i=1:3
  v(:,i) = mod(vi,2)*l(i)+v0(i);
  vi = floor(vi/2);
end
f = [ 1 3 7 5
      2 4 8 6
      1 2 6 5
      3 4 8 7
      1 2 4 3
      5 6 8 7 ];
fv.faces = f;
fv.vertices = v;
fv.facevertexcdata = 0;
h = patch(fv,'facecolor',[0 0 1]);
