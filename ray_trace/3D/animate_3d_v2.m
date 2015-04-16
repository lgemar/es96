%% Close all and Clear all
clear variables
close all
hold on

%% Set all parameters and draw mirrors, lenses, and detectors

% SPECIFICATIONS
    % the RIM
    R_RIM = cm2in(90); % radius of curvature of RIM (in)
    distance_RIM = 9.84; % distance between RIM mirror and 1st ICOS mirror
    reflect_RIM = 1;
    % the ICOS mirrors
    r = 1.5; % mirror radius (in)
    R = 30; % radius of curvature of the ICOS mirrors (in)
    w = 0.2; % thickness at center (in)
    l = cm2in(50); % cavity length (in)
    reflect = .99975;
    % the lenses
    l1 = l+1.4; % position of first lens, inch past second ICOS mirror
    lf = l1 + 2*r; % d/f = 1
    R_CX = cm2in(75); % Lens radii (1) 
    R_CC = cm2in(90); % Lens radii (2)
    ct = .2; % center thickness of lens
    l2 = lf + .2; % position of second lens
    l3 = l2 + 1; % position of third lens
    
    second = true; % second lens implemented
    third = false; % third lense implemented?

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);
mirror3d(-distance_RIM, 0, -1, w, r, R); 

% Draw the lense after the cavity
lense3d( l1, r, R_CX, R_CC, ct)

% Draw the cube 
cube3d([l1 + 2*r, -0.5, -0.5], 1)
  
% Draw the lens
L = lens(l1, r, R_CX, R_CC, ct);

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

% create lenses
lens1 = lens(l1, r, R_CX, R_CC, ct);
if second
    lens2 = lens(l2, r, R_CX, R_CC, ct);
end
if third
    lens3 = lens(l3, r, R_CX, R_CC, ct);
end


% Calculate the locations of the centers of the ICOS mirrors
ctr1 = [l 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';
ctr_RIM = [-distance_RIM 0 0]' + r_RIM * [1 0 0]'; 

% Calculate the centers of curvature for the first lens
lens1_ctr1 = [l1-ct1/2 0 0]' + R_CX * [1 0 0]'; 
lens1_ctr2 = [l1+ct1/2 0 0]' + R_CC * [1 0 0]'; 
% Calculate the centers of curvature for the second lens
if second
    lens2_ctr1 = [l2-ct2/2 0 0]' + R_CX * [1 0 0]'; 
    lens2_ctr2 = [l2+ct2/2 0 0]' + R_CC * [1 0 0]';     
end
% Calculate the centers of curvature for the third lens
if third
    lens3_ctr1 = [l3-ct3/2 0 0]' + R_CX * [1 0 0]'; 
    lens3_ctr2 = [l3+ct3/2 0 0]' + R_CC * [1 0 0]';     
end

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

    % Extend the pulse to the second mirror and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(ctr1, r); 
    P.draw();
    
    % Extend the pulse back to the first mirror and create bleedthrough
    [P2, P3] = P2.spherical_mirror_constraint(ctr2, r);
    P2.draw(); 
    
    % Intersect the ray with the first surface of the first lens
    P = P.lens_constraint(lens1_ctr1, lens_r1, 1, 5); 
    P.draw(); 

    % Intersect the ray with the second surface of the first lens
    P = P.lens_constraint(lens_ctr2, lens_r2, 5, 1); 
    P.draw(); 
    
    if second
        
        % Intersect the ray with the first surface of the second lens
        P = P.lens_constraint(lens1_ctr1, lens_r1, 1, 5); 
        P.draw(); 
 
        % Intersect the ray with the second surface of the second lens
        P = P.lens_constraint(lens_ctr2, lens_r2, 5, 1); 
        P.draw();         
        
    end
    
    if third
        
        % Intersect the ray with the first surface of the third lens
        P = P.lens_constraint(lens_ctr1, lens_r1, 1, 5); 
        P.draw(); 
 
        % Intersect the ray with the second surface of the third lens
        P = P.lens_constraint(lens_ctr2, lens_r2, 5, 1); 
        P.draw();         
        
    end    
    

    % Intersect the ray with the plane of the detector
    [P, ~] = P.vertical_plane_constraint(l1 + 4);
    P.draw();       

    % Reset the cavity pulse as P3
    P_cavity = P3; 
    
    % Draw the pulses up until now
    drawnow;  
end
