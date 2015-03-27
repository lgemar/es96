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
%% Set all parameters and draw mirrors

model_3d = figure(1); 
hold on

r = 1.5; % lens radius (in)
R = 30; % radius of curvature of the lens (in)
R1 = 15; % Lens radii (1) 
R2 = 15; % Lens radii (2)
w = 0.2; % thickness at center (in)
l = 15.685; % cavity length (in)
l1 = l+1; % position of collection lens, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1
distance_harriet = 9.84 % distance between Harriet mirror and 1st ICOS mirror

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);
mirror3d(-distance_harriet, 0, -1, w, r, R); 

% Draw the lense after the cavity
lense3d( l1, 0, r, 3*r);

% Draw the cube 
cube3d([l1 + 2*r, -0.5, -0.5], 1)
    
L = lens([l1, 0, 0], 0.2, r, R1, R2, ray([l1, 0, 0], [1 0 0]));

% Make it look pretty
set(gca,'xlim', [-(distance_harriet+1) lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;


%% Pulse particle Test
p0 = [-(distance_harriet + 1) 0.8 0.8]'; 
dir_initial = [1 -0.1 -0.05]'; 
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

% Lens radii of curvature
lens_r1 = 10; 
lens_r2 = 300; 

% Calculate the centers of curvature for the lens
lens_ctr1 = [l+1 0 0]' + lens_r1 * [1 0 0]'; 
lens_ctr2 = [l+1.5 0 0]' + lens_r2 * [1 0 0]'; 

N = 200; % number of frame updates

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
        %P_cavity.draw(); 
    end
    
    % [P_harriet, P_init] = P_harriet.spherical_mirror_constraint(ctr_harriet, r_harriet, dt);
    %P_harriet.draw(); 
        
    P = P_cavity; 

    index = counter+1;

    % Extend the pulse to the second lens and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(ctr1, r, dt); 
    figure(model_3d)
    %P.draw(); 

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
    [P2, P3] = P2.spherical_mirror_constraint(ctr2, r, dt);
    %P2.draw();       

    P_cavity = P3; 
    
    % Intersect the ray with the first surface of the lens
    P = P.lens_constraint(lens_ctr1, lens_r1, 1, 5, dt); 
    %P.draw(); 

    % Intersect the ray with the second surface of the lens
    P = P.lens_constraint(lens_ctr2, lens_r2, 5, 1, dt); 
    %P.draw(); 

    % Intersect the ray with the plane of the detector
    [P, ~] = P.vertical_plane_constraint(l1 + 4);
    %P.draw(); 

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

% plot overlapping area graph
figure()
maximum_cum_sum = conv(30*pi*0.059^2*ones(1, N), ones(1, 30)); 
running_cum_sum = conv(overall_area, ones(1, 30)); 
plot(running_cum_sum)
ylim([0, 30*0.3281])

% "goodness score" 
goodness = sum(running_cum_sum) / sum(maximum_cum_sum)
%>>>>>>> harriet_cell
