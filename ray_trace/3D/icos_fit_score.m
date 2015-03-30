function goodness = icos_fit_score(r, l, p0, dir_initial)

%% Set the parameters of the problem
mirror_diameter = 3; % The diameter of the ICOS mirror in inches
w = 0.25; % The width of the ICOS mirror in inches
N = 100; % number of frame updates
K = 30; % the number of relevant rays for overlap caculations
penalty = 0; % The penalty term that results from shooting a ray out of the cavity
infinity = 1; % The maximum penalty

% Calculate the locations of the centers of the ICOS mirrors, using the
% length of the cavity, l, and the radius of curvature of the lenses, r
ctr1 = [l 0 0]' - r * [1 0 0]'; 
ctr2 = [0 0 0]' + r * [1 0 0]';

% The first ray has initial position p0 and initial direction dir_initial
P_init = PulsePoint(p0', dir_initial'); 

% Preallocation of matrices to hold outputs
overall_area = zeros(N, 1); % 
mirror_spots = zeros(N, 2); % preallocate matrix for mirror spot pattern

%% Run the simulation 
% Reflect the incoming ray off the back face of the ICOS mirror
[P_cavity, ~] = P_init.vertical_plane_constraint(-w);  

for i = 1:N   
    % Extend the pulse to the second cavity mirror: P2 is the reflection
    % beam
    [~, P2] = P_cavity.spherical_mirror_constraint(ctr1, r); 

    % Record mirror spot pattern on far ICOS mirror
    mirror_spots(i,1) = P2.p(2);
    mirror_spots(i,2) = P2.p(3);
    
    % Compute the overlap of this point with the last 30 points
    if i > 30
        spot_points = mirror_spots((i-K):(i-1),:);
        yn_zn = repmat([P2.p(2), P2.p(3)], K, 1); 
    else 
        spot_points = mirror_spots(1:(i-1), :); 
        yn_zn = repmat([P2.p(2), P2.p(3)], (i-1), 1); 
    end
    temp = spot_points - yn_zn;
    temp_square = temp.^2;
    d_2 = temp_square*[1;1];
    d = sqrt(d_2);
    areas = arrayfun(@overlap,d(1:min(i-1, 30))); 
    overall_area(i) = sum(areas);

    % Extend the pulse back to the first ICOS mirror and create bleedthrough
    [~, P3] = P2.spherical_mirror_constraint(ctr2, r);      

    % Redefine the cavity pulse
    P_cavity = P3; 
    
    % Check to make sure that the rays are still in the cavity
    if( sqrt(P3.p(2)^2 + P3.p(3)^2) > mirror_diameter / 2 )
        penalty = infinity; 
        break; 
    end
end

% plot overlapping area graph
maximum_cum_sum = 30*pi*0.059^2*ones(N-2*K, 1); 
running_sum = overall_area(K:(N-K), :); 

% Calculate "goodness": the cumulative overlap vs the maximum cumulative overlap 
goodness1 = sum(running_sum) / sum(maximum_cum_sum); 
goodness = goodness1 + penalty; 
end