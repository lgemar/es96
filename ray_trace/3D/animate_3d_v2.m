%** 4/10/2015 - NOTE: I, JOY, AM COMMENTING OUT DRAWING PORTIONS OF THE
%CODE AND DISTINGUISHING THESE PORTIONS WITH %** INSTEAD OF JUST %

%% Close all and Clear all
clear variables
close all
hold on

%% Set all parameters and draw mirrors

r = 1.5; % lens radius (in)
R = 30; % radius of curvature of the lens (in)
R1 = cm2in(75); % Lens radii (1) 
R2 = cm2in(75); % Lens radii (2)
w = 0.2; % thickness at center (in)
l = cm2in(50); % cavity length (in)
l1 = l+1.4; % position of collection lens, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1
distance_RIM = 9.84; % distance between RIM mirror and 1st ICOS mirror

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);
mirror3d(-distance_RIM, 0, -1, w, r, R); 

% Draw the lense after the cavity
lense3d( l1, 0, r, 3*r);

% Draw the cube 
cube3d([l1 + 2*r, -0.5, -0.5], 1)
  
% Draw the lens
L = lens([l1, 0, 0], 0.2, r, R1, R2, ray([l1, 0, 0], [1 0 0]));

% Make it look pretty
set(gca,'xlim', [-(distance_RIM+1) lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;

%% Pulse particle Test
p0 = [-(distance_RIM + 1) 1 0.5]'; % Initial position of ray
dir_initial = [1 -0.005 7*-0.005]'; % INitial direction of ray
P_init = PulsePoint(p0, dir_initial); % Initial Pulse

% Radius of curvature of the ICOS mirrors
r = cm2in(75); % cm2in is a utility function that converts cm to in
r_RIM = 39.37; % radius of curvature of the RIM; 

% Calculate the locations of the centers of the ICOS mirrors
ctr1 = [l 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';
ctr_RIM = [-distance_RIM 0 0]' + r_RIM * [1 0 0]'; 

% Lens radii of curvature
lens_r1 = 10; 
lens_r2 = 300; 

% Calculate the centers of curvature for the lens
lens_ctr1 = [l+1 0 0]' + lens_r1 * [1 0 0]'; 
lens_ctr2 = [l+1.5 0 0]' + lens_r2 * [1 0 0]'; 

N = 30; % number of frame updates

% preallocate matrices for mirror and detector spot patterns
numbruns = N;

% This is how you create an empty object
P_cavity = []; 

for i = 1:N   
    % Reflect the incoming ray off the back face of the ICOS mirror
    
    % on the first run of the code, intersect the ray with the back surface
    % of the ICOS mirror
    if i == 1
        [P_cavity, P_RIM] = P_init.vertical_plane_constraint(-w); 
    end
  
    % Intersect the ray with the RIM
    [P_RIM, P_init] = P_RIM.spherical_mirror_constraint(ctr_RIM, r_RIM);
    P_RIM.draw(); 
        
    P = P_cavity; 

    % Extend the pulse to the second lens and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(ctr1, r); 
    P.draw();
    
    % Extend the pulse back to the first lens and create bleedthrough
    [P2, P3] = P2.spherical_mirror_constraint(ctr2, r);
    P2.draw(); 
    
    % Intersect the ray with the first surface of the lens
    P = P.lens_constraint(lens_ctr1, lens_r1, 1, 5); 
    P.draw(); 

    % Intersect the ray with the second surface of the lens
    P = P.lens_constraint(lens_ctr2, lens_r2, 5, 1); 
    P.draw(); 

    % Intersect the ray with the plane of the detector
    [P, ~] = P.vertical_plane_constraint(l1 + 4);
    P.draw();       

    % Reset the cavity pulse as P3
    P_cavity = P3; 
    
    % Draw the pulses up until now
    drawnow;  
end


