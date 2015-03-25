%% Close all and Clear all
clear variables
close all
hold on

%% Set all parameters and draw mirrors

model_3d = figure(1); 
hold on

r = 2; % lens radius (in)
R = 30; % radius of curvature of the lens (in)
R1 = 15; % Lens radii (1) 
R2 = 15; % Lens radii (2)
w = 0.2; % thickness at center (in)
l = 8; % cavity length (in)
l1 = l+1; % position of collection lens, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);

% Draw the lense after the cavity
lense3d( l1, 0, r, 3*r);

% Draw the cube 
cube3d([l1 + 2*r, -0.5, -0.5], 1)
    
L = lens([l1, 0, 0], 0.2, r, R1, R2, ray([l1, 0, 0], [1 0 0]));

% Make it look pretty
set(gca,'xlim', [-2.2 lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;


%% Pulse particle Test
p0 = [-1 0.8 0.8]'; 
dir_initial = [1 -0.1 -0.06]'; 
dt = 0.1; 
P_init = PulsePoint(p0, dir_initial); 

r = 30; 
ctr1 = [8 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';

lens_r1 = 10; 
lens_r2 = 300; 
lens_ctr1 = [9 0 0]' + lens_r1 * [1 0 0]'; 
lens_ctr2 = [9.5 0 0]' + lens_r2 * [1 0 0]'; 

mirror_spot_pattern = figure(2); 
hold on; 
title('Mirror spot pattern')

detector_spot_pattern = figure(3); 
hold on; 
title('Deetector spot pattern')
xlim([-0.5 0.5])
ylim([-0.5 0.5])

cavity_pulses = {P_init};
harriet_pulses = {}; 
% 1) Think about laser overlap
% 2) Plotting points on mirror in 2D 
% Outer loop is the number of frame updates
% Inner loop updates each individual pulse
for i = 1:1000   
    % Take a care of all of the cavity pulses
    for j = 1:length(cavity_pulses)  
        % Grab the current pulse that will travel through the system
        P = cavity_pulses{j};
        
        % Extend the pulse to the second lens and create bleedthrough
        [P, P2] = P.spherical_mirror_constraint(ctr1, r, dt); 
        figure(model_3d)
        P.draw(); 
        
        % Switch to spot pattern plot
        figure(mirror_spot_pattern)
        plot(P2.p(2), P2.p(3), 'ro')
        
        % Switch back to 3d model
        figure(model_3d)
        
        % Extend the pulse back to the first lens and create bleedthrough
        [P2, P3] = P2.spherical_mirror_constraint(ctr2, r, dt);
        P2.draw(); 
        
        % Intersect the ray with the first surface of the lens
        P = P.lens_constraint(lens_ctr1, lens_r1, 1, 5, dt); 
        P.draw(); 
        
        % Intersect the ray with the second surface of the lens
        P = P.lens_constraint(lens_ctr2, lens_r2, 5, 1, dt); 
        P.draw(); 
        
        % Intersect the ray with the plane of the detector
        P = P.vertical_plane_constraint(l1 + 4);
        P.draw(); 
        
        % Switch to detector spot pattern plot
        figure(detector_spot_pattern)
        plot(P.p(2), P.p(3), 'r.')
        
        % Switch back to 3d model
        figure(model_3d)
        
        % Update the cavity pulse ray
        cavity_pulses = {P3};
    end
    drawnow;
end