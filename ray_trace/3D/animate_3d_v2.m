%% Close all and Clear all
clear variables
close all
hold on

%% Set all parameters and draw mirrors, lenses, and detectors

r = 1.5; % lens radius (in)

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
    distance_harriet = 9.84; % distance between Harriet mirror and 1st ICOS mirror
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
    % draw Harriet mirror 'before' the two mirrors
    mirror3d(-distance_harriet, 0, -1, w, r, R); 
    % draw the lense 'after' the cavity
    lense3d(l1, 0, r, R_CX, R_CC, ct);
    % draw the cube for the detector
    cube3d([lf, -d/2, -d/2], d)
    
% Make it look pretty
    set(gca,'xlim', [-(distance_harriet+1) lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
    %set(gca,'visible','off');
    set(gcf,'color',[.75 .75 1]);
    camlight left;
    camlight right;
    camlight headlight;




%% Pulse particle Test

p0 = [-(distance_harriet + 1) 1 0.5]'; 
dir_initial = [1 -0.005 7*-0.005]'; 
dt = 0.1; 
P_init = PulsePoint(p0, dir_initial); 

% Radius of curvature of the ICOS mirrors
r = cm2in(75); 
r_harriet = 39.37; %19.685; 

% Calculate the locations of the centers of the ICOS mirrors
ctr1 = [l 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';
ctr_harriet = [-distance_harriet 0 0]' + r_harriet * [1 0 0]'; 

% Calculate the centers of curvature for the lens
lens_ctr1 = [l1-ct/2 0 0]' + R_CX * [1 0 0]'; 
lens_ctr2 = [l1+ct/2 0 0]' + R_CC * [1 0 0]'; 


N = 100; % number of frame updates

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
P_cavity = [];

% Set up the movie capture
% Set up the movie.
Az = -45; 
El = 26; 
view([Az El]); 
zoom(2)
writerObj = VideoWriter('out.avi'); % Name it.
fps = 60; 
writerObj.FrameRate = fps; % How many frames per second.
open(writerObj);

% Set up the frame slow down vector
decay_constant = 0.1; 
slow_down = exp(-decay_constant * (1:N)); 


for i = 1:N   
    figure(model_3d)
 
    % Reflect the incoming ray off the back face of the ICOS mirror
    
    if i == 1
        [P_cavity, P_harriet] = P_init.vertical_plane_constraint(-w); 
        P_cavity.draw(); 
        % loses 99.975% going through first ICOS Mirror
        power = .025;
    end
    
    if (i > 1)
        % update power metric
        power = (.05)*(.025)*(0.99975^(2*i)) + power;
    else
        power;
    end
        
    P = P_cavity; 

    % Extend the pulse to the second lens and create bleedthrough
    [P, P2] = P.spherical_mirror_constraint(ctr1, r); 
    P.draw();
    
    % Intersect the ray with the first surface of the lens
    P = P.lens_constraint(lens_ctr1, R_CX, 1, 2.75); 
    P.draw(); 

    % Intersect the ray with the second surface of the lens
    P = P.lens_constraint(lens_ctr2, R_CC, 2.75, 1); 
    P.draw(); 

    % Intersect the ray with the plane of the detector
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

    drawnow;    
    % Grab the current frame
    num_frames = ceil(slow_down(i) * (0.2 *     fps));
    frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
    for j = 1:num_frames
        writeVideo(writerObj, frame);
    end
end

% fits ellipses to mirror spots, then calculates eccentricity of circle
f_ellipse = fit_ellipse(mirror_spots(1:N,1), mirror_spots(1:N,2));
eccen = sqrt(1 - ((f_ellipse.short_axis)/(f_ellipse.long_axis)^2));

% Save the movie
hold off
close(writerObj); % Saves the movie.

figure(1)
scatter(mirror_spots(:,1), mirror_spots(:,2),[], c, '.')
title('Mirror spot pattern')

detector_spot_pattern = figure(2); 
hold on; 
scatter(detector_spots(:,1), detector_spots(:,2),[], c, '.')
title('Detector spot pattern')

