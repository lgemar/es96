%% Close all and Clear all
clear variables
close all
hold on

% Questions for Harriet cell
% 1) how is power effected by the radius of curvature of the harriet cell
% mirror? What is the maximum power we can achieve? 
% 2) What is the angle of incidence for the incoming beam? 
% 3) What is the "best" diameter of the Harriet cell
% 
% What do we need for this to happen? 
% 1) Insert correct values for ICOS mirrors (in) - Sophie
% 2) Add in power losses at each surface (in PulsePoint) - Sophie, and
% Lukas will check 
% 3) (Insert correct values for the Lens) - Lukas
% 4) Adjust parameters for Harriet cell and input beam (**p0** and
% **dir_initial** are the initial position and direction of the laser beam)
% - Sophie
%% Set all parameters and draw mirrors, lenses, and detectors

model_3d = figure(1); 
hold on

% SPECIFICATIONS
    % mirror specs
    r = 1.5; % radius of mirror and lens (in)
    R = 30; % radius of curvature of the mirrors (in)
    w = 0.2; % thickness at center (in)
    l = 15.685; % cavity length (in)
    distance_harriet = 9.84; % distance between Harriet mirror and 1st ICOS mirror
    % lens specs
    R_CX = 3.15441; % Lens radii (1) CX
    R_CC = 11.7431; % Lens radii (2) CC
    ct = .354331; % center thickness of lens
    l1 = l+1; % position of collection lens, inch past second ICOS mirror
    lf = l1 + 3.0; % focus length where d/f = 1
    % detector spec
    d = .0787402; % size of detector 2mm X 2mm
    HACK = 1.55; %%%%%%%%%% 
    
% DRAW THINGS
    % draw two mirrors in cavity
    mirror3d(0, 0, 1, w, r, R); 
    mirror3d(l, 0, -1, w, r, R);
    % draw Harriet mirror 'before' the two mirrors
    mirror3d(-distance_harriet, 0, -1, w, r, R); 
    % draw the lense 'after' the cavity
    lense3d(l1, 0, r, R_CX, R_CC, ct);
    % draw the cube for the detector
    cube3d([lf - HACK, -d/2, -d/2], d)
    
% Make it look pretty
    set(gca,'xlim', [-(distance_harriet+1) lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
    %set(gca,'visible','off');
    set(gcf,'color',[.75 .75 1]);
    camlight left;
    camlight right;
    camlight headlight;

% MAKE OBJECTS
    L = lens(l1, ct, r, R_CX, R_CC, ray([l1, 0, 0], [1 0 0]));




%% Pulse particle Test

p0 = [-(distance_harriet + 1) 1 0.5]'; 
dir_initial = [1 -0.01 5*-0.01]'; 
dt = 0.1; 
P_init = PulsePoint(p0, dir_initial); 
P_cavity = []; 


% Radius of curvature of the ICOS mirrors
r = 39.37; 
r_harriet = 39.37; %19.685; 

% Calculate the locations of the centers of the ICOS mirrors
ctr1 = [l 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';
ctr_harriet = [-distance_harriet 0 0]' + r_harriet * [1 0 0]'; 

% Calculate the centers of curvature for the lens
lens_ctr1 = [l1-ct/2 0 0]' + R_CX * [1 0 0]'; 
lens_ctr2 = [l1+ct/2 0 0]' + R_CC * [1 0 0]'; 


N = 500; % number of frame updates

% preallocate matrices for mirror and detector spot patterns
numbruns = N;
mirror_spots = zeros(numbruns, 2);
detector_spots = zeros(numbruns, 2);
overall_area = zeros(numbruns, 1);

%color gradient
c = linspace(1,10,numbruns);

% 1) Think about laser overlap
% 2) Plotting points on mirror in 2D 
% Outer loop is the number of frame updates
% Inner loop updates each individual pulse
counter = 0; 
P_cavity = [];
for i = 1:N   
    % Take a care of all of the cavity pulses
    % Reflect the incoming ray off the back face of the ICOS mirror
    
    if i == 1
        [P_cavity, P_harriet] = P_init.vertical_plane_constraint(-w); 
        P_cavity.draw(); 
    end
    
    % [P_harriet, P_init] = P_harriet.spherical_mirror_constraint(ctr_harriet, r_harriet, dt);
    %P_harriet.draw(); 
        
    P = P_cavity; 

    index = counter+1;

    % Extend the pulse to the second lens and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(ctr1, r); 
    figure(model_3d)
    P.draw(); 

    % Record mirror spot pattern
    mirror_spots(index,1) = P2.p(2);
    mirror_spots(index,2) = P2.p(3);
    if index > 30
        spot_points = mirror_spots((index-30):(index-1),:);
        yn_zn = repmat([P2.p(2), P2.p(3)], 30, 1); 
    else 
        spot_points = mirror_spots(1:(index-1), :); 
        yn_zn = repmat([P2.p(2), P2.p(3)], (index-1), 1); 
    end
    temp = spot_points - yn_zn;
    temp_square = temp.^2;
    d_2 = temp_square*[1;1];
    d = sqrt(d_2);
    areas = arrayfun(@overlap,d(1:min(index-1, 30))); 
    % disp([d, areas]); 
    overall_area(i) = sum(areas);

    % Extend the pulse back to the first lens and create bleedthrough
    [P2, P3] = P2.spherical_mirror_constraint(ctr2, r);
    P2.draw();       

    P_cavity = P3; 
    
    % Intersect the ray with the first surface of the lens
    P = P.lens_constraint(lens_ctr1, R_CX, 1, 5); 
    P.draw(); 

    % Intersect the ray with the second surface of the lens
    P = P.lens_constraint(lens_ctr2, R_CC, 5, 1); 
    P.draw(); 

    % Intersect the ray with the plane of the detector
    [P, ~] = P.vertical_plane_constraint(lf-HACK);
    P.draw(); 

    % Record detector spot pattern
    detector_spots(index,1) = P.p(2);
    detector_spots(index,2) = P.p(3);

    % Update the cavity pulse ray
    counter = counter + 1; 

    drawnow;
end

mirror_spot_pattern = figure(2); 
hold on; 
title('Mirror spot pattern')

detector_spot_pattern = figure(3); 
hold on; 
title('Detector spot pattern')

% plot mirror spot pattern 
figure(mirror_spot_pattern)
scatter(mirror_spots(:,1), mirror_spots(:,2),[], c, '.')

% plot detector spot pattern
figure(detector_spot_pattern)
scatter(detector_spots(:,1), detector_spots(:,2),[], c, '.')
