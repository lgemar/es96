%%
clear all 
clf
% Draw two 2-D mirrors
r = 2; % lens radius (in)
R = 45; % radius of curvature of the lens (in)
w = 0.2; % thickness at center (in)
l = 8; % cavity lenth (in)
l1 = 9; % position of collection mirror, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1

% MAIN TODOS: done by Sunday night
% 1) Mirror --> to 3D (Crystal) 
% --> Frontside equation (start here --> curved surface, equation of
% surface) 
% --> Backside equation (second priority) 
% 2) Rays --> to 3D 
% --> Intersect Plane (Jordan) 
% --> Intersect Arc (Lukas) 
% 3) Lens --> to 3D (Jordan) 
% 4) Ray dissipation --> add to Ray structure? 

% Monday
% Integrate changes into a working animation


% Make the mirrors
% TODO: This mirror will need curvature defined by R
% TODO: Make mirror into an object in 3D, with a  backside and face
mirror3d(0, 0, 1, w, r); 
hold on;
mirror3d(l, 0, -1, w, r);

% TODO: make this 3D 
L = lens(0.2, M2.r, 15, ray([l1, 0], [1 0]));

% Make it look pretty
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;

% Location of the incoming ray
rx0 = -2;
ry0 = 0;
rz0 = 0.9*r; 

% TODO: make our own 3D ray class
R = ray([rx0 ry0 rz0], [1 0 0]);
%%
% TODO: Make sure 3D mirror has a backside, which is a plane
% TODO: update function to handle a plane
R = R.intersect_ray(M1.backside);
% TODO: figure out what the parameters here are for
R.draw('P',[0 0.3*r]); % First --> text above line; Second --> not sure
R = R.propagate;
%%
h = mtext(-w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
% TODO: Make sure M2 has a face, which is now 3D surface
% TODO: update the function, reflect arc, for 3D rays and 3D surfaces
[R, R2] = R.reflect_arc(M2.face);
R.draw('e^{-\sigma{}Nl}', [0 0.3*r]);
%%
% First reflection back through the cavity
% TODO: figure out what RC is 
RC = ray([l1, -r], [0 1]);
%set(h,'HorizontalAlignment','Center');
E1 = R.propagate;
E1 = E1.intersect_ray(RC);
E1.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
% set(h,'HorizontalAlignment','Center');
%%
E1a = R2.propagate;
E1a.D = [-1 0];
E1a.E = E1a.O+E1a.D;
E1a.draw;
[R3, R2] = R3.reflect_arc(M2.face);
R3.draw;
% set(h,'HorizontalAlignment','Center');
%%
E2 = R3.propagate;
E2.D = [1 0];
E2 = E2.intersect_ray(RC);
E2.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
%%
E1.draw;
E2.draw;

% TODO: what is this? 
FP = [lf 0];
%%
for i=1:50
  E1a = R2.propagate;
  E1a.D = [-1 0];
  E1a.E = E1a.O+E1a.D;
  E1a.draw;
  [R3, R2] = R3.reflect_arc(M2.face);
  R3.draw;
  drawnow;
  %%
  E2 = R3.propagate;
  E2.D = [1 0];
  E2 = E2.intersect_ray(RC);
  E2.draw;
  [R2, R3] = R2.reflect_arc(M1.face);
  R2.draw;
  F2 = ray(E2.E, FP-E2.E);
  F2.draw;
  drawnow;
end
