%% Close all and Clear all
clear variables
close all
hold on

%% Set all parameters and draw mirrors, lenses, and detectors

% SPECIFICATIONS
    % the RIM
    R_RIM = cm2in(39.37); % radius of curvature of RIM (in)
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
    R_CX = cm2in(25); % Lens radii (1) 
    R_CC = cm2in(50); % Lens radii (2)
    ct = .2; % center thickness of lens
    ct2 = .2;
    l2 = l1 + 4; % position of second lens
    l3 = l2 + 2; % position of third lens
    
    second = true; % second lens implemented
    third = false; % third lense implemented?
    
    %the detector
    l4 = l2 + 1; % position of detector
    size = cm2in(1); % size of detector

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);
mirror3d(-distance_RIM, 0, -1, w, r, R); 

% Draw the lense after the cavity
lens3d( l1, r, R_CX, R_CC, ct);
if second
    lens3d( l2, r/2, R_CX, R_CC, ct2);
end
if third
    lens3d( l3, r, R_CX, R_CC, ct3)
end

% Draw the cube 
cube3d([l4, -(size/2), -(size/2)], size)
  
% Draw the lens
L = lens(l1, r, R_CX, R_CC, ct);

% Make it look pretty
set(gca,'xlim', [-(distance_RIM+1) l4+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;

%% Pulse particle Test
p0 = [-(distance_RIM + 1) 1 0.5]'; % Initial position of ray
dir_initial = [1 -0.005 7*-0.005]'; % INitial direction of ray
P_init = PulsePoint(p0, dir_initial); % Initial Pulse

% keep track of detector power
detect_pow = 0;

% create mirrors
mirror1 = mirror(0,r,R,reflect);
mirror2 = mirror(l,r,R,reflect);
RIMirror = mirror(-distance_RIM,r,R_RIM,reflect_RIM);

% create lenses
lens1 = lens(l1, r, R_CX, R_CC, ct);
if second
    lens2 = lens(l2, r, R_CX, R_CC, ct);
end
if third
    lens3 = lens(l3, r, R_CX, R_CC, ct);
end

N = 5; % number of frame updates

for i = 1:N   
    % Reflect the incoming ray off the back face of the ICOS mirror
    
    % on the first run of the code, intersect the ray with the back surface
    % of the ICOS mirror
    if i == 1
        [P_cavity, P_RIM] = P_init.vertical_plane_constraint(-w); 
        P_cavity.draw();
    end
  
%     % Intersect the ray with the RIM
%     [P_RIM, P_init] = P_RIM.spherical_mirror_constraint(RIMirror.ctr, RIMirror.R);
%     P_RIM.draw(); 
        
    P = P_cavity; 

    % Extend the pulse to the second mirror and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(mirror1.ctr, mirror1.R); 
    P.draw();
    
    % Extend the pulse back to the first mirror and create bleedthrough
    [P2, P3] = P2.spherical_mirror_constraint(mirror2.ctr, mirror2.R);
    P2.draw(); 
    
    % ******* FOLLOWING P2 ******** 
    
    % Intersect the ray with the first surface of the first lens
    P = P2.lens_constraint(lens1.ctr1, lens1.R_CX, 1, 5); 
    P.draw(); 

    % Intersect the ray with the second surface of the first lens
    P = P.lens_constraint(lens1.ctr2, lens1.R_CC, 5, 1); 
    P.draw(); 
    
    if second
        % Intersect the ray with the first surface of the second lens
        P = P.lens_constraint(lens2.ctr1, lens2.R_CX, 1, 5); 
        P.draw(); 
        % Intersect the ray with the second surface of the second lens
        P = P.lens_constraint(lens2.ctr2, lens2.R_CC, 5, 1); 
        P.draw();     
    end
    if third
        % Intersect the ray with the first surface of the third lens
        P = P.lens_constraint(lens3.ctr1, lens3.R_CX, 1, 5); 
        P.draw(); 
        % Intersect the ray with the second surface of the third lens
        P = P.lens_constraint(lens3.ctr2, lens3.R_CC, 5, 1); 
        P.draw();  
    end    
    
    % Intersect the ray with the plane of the detector
    [P, ~] = P.vertical_plane_constraint(l4);
    P.draw();
    
    % Determine if within angle of +/- 15 degrees
    angle = radtodeg(acos(dot(P.dir,[1;0;0])));
    P.p
    P.pow
    if abs(P.p(2))<cm2in(10) && abs(P.p(3))<cm2in(10)
        detect_pow = detect_pow + P.pow;
    end

    % ******* FOLLOWING P3 in next loop ******** 
    
    % Reset the cavity pulse as P3
    P_cavity = P3; 
    
    % Draw the pulses up until now
    drawnow;  
end
