%** 4/10/2015 - NOTE: I, JOY, AM COMMENTING OUT DRAWING PORTIONS OF THE
%CODE AND DISTINGUISHING THESE PORTIONS WITH %** INSTEAD OF JUST %

%% Close all and Clear all
clear variables
close all
hold on

%% Set all parameters and draw mirrors, lenses, and detectors

r = 1.5; % lens radius (in)

<<<<<<< HEAD:ray_trace/3D/animate_3d_v3.m
% Create the mirror spot pattern figure
figure(1); 
hold on
title('Mirror Spot Projection')
xlim([-1.5 1.5]); 
ylim([-1.5 1.5]);
thetas = 0:0.01:2*pi; 
x_bound = r * sin(thetas); 
y_bound = r * cos(thetas); 
scatter(x_bound, y_bound, 'k')

model_3d = figure('units','pixels','position',[0 0 1280 720]); 
hold on

% SPECIFICATIONS
    % mirror specs
    r = 1.5; % radius of mirror and lens (in)
    R = 30; % radius of curvature of the mirrors (in)
    w = 0.2; % thickness at center (in)
    l = cm2in(50); % cavity length (in)
    % RIM specs
    distance_RIM = 9.84; % distance between RIM and 1st ICOS mirror
    r_RIM = ; % radius of mirror (in)
    R_RIM = ; % radius of curvature (in)
    % lens specs
    R_CX = cm2in(80.122); % Lens radii (1) CX
    R_CC = cm2in(298.275); % Lens radii (2) CC
    ct = cm2in(9); % center thickness of lens
    l1 = l+1.4; % position of collection lens, 1.4 inch past second ICOS mirror
    lf = l1 + 2*r; % focus length where d/f = 1
    % detector spec
    d = .0787402; % size of detector 2mm X 2mm
    
% DRAW THINGS
    % draw two mirrors in cavity
    mirror3d(0, 0, 1, w, r, R); 
    mirror3d(l, 0, -1, w, r, R);
    % draw RIM 'before' the two mirrors
    mirror3d(-distance_RIM, 0, -1, w, r, R); 
    % draw the lense 'after' the cavity
    lense3d(l1, 0, r, R_CX, R_CC, ct);
    % draw the cube for the detector
    cube3d([lf, -d/2, -d/2], d)
    
=======
R = 30; % radius of curvature of the lens (in)
R1 = cm2in(75); % Lens radii (1) 
R2 = cm2in(75); % Lens radii (2)
w = 0.2; % thickness at center (in)
l = cm2in(50); % cavity length (in)
l1 = l+1.4; % position of collection lens, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1
distance_harriet = 9.84; % distance between Harriet mirror and 1st ICOS mirror

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);
mirror3d(-distance_harriet, 0, -1, w, r, R); 

% Draw the lense after the cavity
lense3d( l1, 0, r, 3*r);

% Draw the cube 
cube3d([l1 + 2*r, -0.5, -0.5], 1)
  
% Draw the lens
L = lens([l1, 0, 0], 0.2, r, R1, R2, ray([l1, 0, 0], [1 0 0]));

>>>>>>> simplify:ray_trace/3D/animate_3d_v2.m~
% Make it look pretty
    set(gca,'xlim', [-(distance_RIM+1) lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
    %set(gca,'visible','off');
    set(gcf,'color',[.75 .75 1]);
    camlight left;
    camlight right;
    camlight headlight;



%% Pulse particle Test
<<<<<<< HEAD:ray_trace/3D/animate_3d_v3.m

p0 = [-(distance_RIM + 1) 1 0.5]'; 
dir_initial = [1 -0.005 7*-0.005]'; 
dt = 0.1; 
P_init = PulsePoint(p0, dir_initial); 
=======
p0 = [-(distance_harriet + 1) 1 0.5]'; % Initial position of ray
dir_initial = [1 -0.005 7*-0.005]'; % INitial direction of ray
P_init = PulsePoint(p0, dir_initial); % Initial Pulse
>>>>>>> simplify:ray_trace/3D/animate_3d_v2.m~

% Radius of curvature of the ICOS mirrors
r = cm2in(75); % cm2in is a utility function that converts cm to in
r_harriet = 39.37; % radius of curvature ; 

% Calculate the locations of the centers of the ICOS mirrors
ctr1 = [l 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';
ctr_harriet = [-distance_RIM 0 0]' + r_harriet * [1 0 0]'; 

% Calculate the centers of curvature for the lens
lens_ctr1 = [l1-ct/2 0 0]' + R_CX * [1 0 0]'; 
lens_ctr2 = [l1+ct/2 0 0]' + R_CC * [1 0 0]'; 

<<<<<<< HEAD:ray_trace/3D/animate_3d_v3.m

N = 100; % number of frame updates
=======
N = 30; % number of frame updates
>>>>>>> simplify:ray_trace/3D/animate_3d_v2.m~

% preallocate matrices for mirror and detector spot patterns
numbruns = N;

P_cavity = []; % This is how you create an empty object

for i = 1:N   
    % Reflect the incoming ray off the back face of the ICOS mirror
    
    % on the first run of the code, intersect the ray with the back surface
    % of the ICOS mirror
    if i == 1
        [P_cavity, P_harriet] = P_init.vertical_plane_constraint(-w); 
<<<<<<< HEAD:ray_trace/3D/animate_3d_v3.m
        P_cavity.draw(); 
        % loses 99.975% going through first ICOS Mirror
        power = 0.025;
    end
  
    if (i > 1)
        % update power metric
        power = (0.5)*(0.025)*(0.99975^(2*i)) + power;
    else
        power;
    end
    
    if (i > 1)
        % update power metric
        power = (.05)*(.025)*(0.99975^(2*i)) + power;
    else
        power;
    end
=======
    end
  
    % Intersect the ray with the RIM
    [P_harriet, P_init] = P_harriet.spherical_mirror_constraint(ctr_harriet, r_harriet);
    P_harriet.draw(); 
>>>>>>> simplify:ray_trace/3D/animate_3d_v2.m~
        
    P = P_cavity; 

    % Extend the pulse to the second lens and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(ctr1, r); 
    P.draw();
    
    % Extend the pulse back to the first lens and create bleedthrough
    [P2, P3] = P2.spherical_mirror_constraint(ctr2, r);
    P2.draw(); 
    
    % Intersect the ray with the first surface of the lens
    P = P.lens_constraint(lens_ctr1, R_CX, 1, 2.75); 
    P.draw(); 

    % Intersect the ray with the second surface of the lens
    P = P.lens_constraint(lens_ctr2, R_CC, 2.75, 1); 
    P.draw(); 

    % Intersect the ray with the plane of the detector
<<<<<<< HEAD:ray_trace/3D/animate_3d_v3.m
    [P, ~] = P.vertical_plane_constraint(lf);
    P.draw(); 
    
    % Record mirror spot pattern
    figure(1); 
    mirror_spots(i,1) = P2.p(2);
    mirror_spots(i,2) = P2.p(3); 
    
    % Draw the mirror spot pattern
    c = linspace(1,10 * (i) / N,i);
    scatter(mirror_spots(1:(i),1), mirror_spots(1:(i),2),200, c, '.')
    hold on
    scatter(mirror_spots(i,1), mirror_spots(i,2),200, 'r+');
    hold off

    % Draw the pulses up until now
    drawnow;  
    
    % Grab the current frame
    num_frames = ceil(slow_down(i) * (fps));
    frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
    for j = 1:num_frames
        writeVideo(writerObj, frame);
    end
    
    % Extend the pulse back to the first lens and create bleedthrough
    [P2, P3] = P2.spherical_mirror_constraint(ctr2, r);
    P2.draw();       

    P_cavity = P3; 
    
    % Record detector spot pattern
    detector_spots(i,1) = P.p(2);
    detector_spots(i,2) = P.p(3);
    i
    drawnow;    
    % Grab the current frame
    num_frames = ceil(slow_down(i) * (0.2 *     fps));
    frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
    for j = 1:num_frames
        writeVideo(writerObj, frame);
    end
end

% fits ellipse to mirror spots, then calculates eccentricity of circle
f_ellipse = fit_ellipse(mirror_spots(1:N,1), mirror_spots(1:N,2));
eccen = sqrt(1 - ((f_ellipse.short_axis)/(f_ellipse.long_axis)^2));

% Save the movie
hold off
close(writerObj); % Saves the movie.

figure(1)
scatter(mirror_spots(:,1), mirror_spots(:,2),[], c, '.')
title('Mirror spot pattern')

detector_spot_pattern = figure(3); 
hold on; 
scatter(detector_spots(:,1), detector_spots(:,2),[], c, '.')
title('Detector spot pattern')
=======
    [P, ~] = P.vertical_plane_constraint(l1 + 4);
    P.draw();       

    P_cavity = P3; 
    
    % Draw the pulses up until now
    drawnow;  
end

>>>>>>> simplify:ray_trace/3D/animate_3d_v2.m~

