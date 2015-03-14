%%
%% What variables are most useful to parameterize
% ICOS Mirrors

% distance between ICOS mirrors 50cm 
% radius of curvature 1m 
% 99.95% reflectivity
% Thickness 5+ mm

% Harriot cell mirror
% Radius of curvature 1m 

% Target path length
% Output power 
% Low noise alignment 
% Tomorrow at 11 to look at Harreit cells
% 1) Distance to Harriet cell
% 2) Angle of laser input to Harriet cell 
% Focus the light for the detector -- focus the light for the detector
% Path length
%% MAIN TODOS: done by Sunday night
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


clear all;
clf
hold on; 

% Set all parameters
r = 2; % lens radius (in)
R = 30; % radius of curvature of the lens (in)
R1 = 15; % Lens radii (1) 
R2 = 15; % Lens radii (2)
w = 0.2; % thickness at center (in)
l = 8; % cavity length (in)
l1 = l+1; % position of collection lens, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1

% make and draw two mirrors in cavity
M1 = mirror(r, R, w, [0 0 0], [1 0 0]);
mirror3d(0, 0, 1, w, r, R); 
M2 = mirror(r, R, w, [l 0 0], [-1 0 0]);
mirror3d(l, 0, -1, w, r, R);


% Make the mirrors
% TODO: This mirror will need curvature defined by R
% TODO: Make mirror into an object in 3D, with a  backside and face


% TODO: make this 3D 
L = lens([l1, 0, 0], 0.2, r, R1, R2, ray([l1, 0, 0], [1 0 0]));

% Make it look pretty
set(gca,'xlim', [-2.2 lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;

% Location of the incoming ray
rx0 = -2;
ry0 = 0;
rz0 = 0.8*r; 

% TODO: make our own 3D ray class
R = ray([rx0 ry0 rz0], [1 0.1 -0.1]);
%%
% Intersect the incoming beam with backside of first mirror
R = R.intersect_plane(M1.backside);
%% 
R = R.intersect_arc(M2.face); 
R.draw; 
[R, R2] = R.reflect_arc(M2.face);
%%
R2 = R2.intersect_arc(M1.face);
R2.draw
[R2, R] = R2.reflect_arc(M1.face);
% set(h,'HorizontalAlignment','Center');
%%
% TODO: what is this? Focal Point
FP = [lf 0];
%%
for i=1:1000
    %%
    % R is always going in the positive X direction
    R = R.intersect_arc(M2.face); 
    R.draw; 
    drawnow; 
    [R, R2] = R.reflect_arc(M2.face);
    %%
    % R2 is going in the negative X direction
    R2 = R2.intersect_arc(M1.face);
    R2.draw
    [R2, R] = R2.reflect_arc(M1.face);
    drawnow;
end
