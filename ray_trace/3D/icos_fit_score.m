function goodness = icos_fit_score(r, l, p0, dir_initial)

mirror_diameter = 3; 
w = 0.25; 
dt = 0.1; 
N = 200; % number of frame updates
penalty = 20; 

min_radius = 9.834; % 25 cm
max_radius = 78.74; % 2 m

min_length = 1.9685; % 5 cm
max_length = 23.622; % 60 cm

if(r < min_radius || r > max_radius)
    goodness = penalty * penalty; 
elseif (l < min_length || l > max_length)
    goodness = penalty * penalty; 
else

    P_init = PulsePoint(p0, dir_initial); 
    P_cavity = []; 

    % Calculate the locations of the centers of the ICOS mirrors
    ctr1 = [l 0 0]' - r * [1 0 0]'; 
    ctr2 = [0 0 0]' + r * [1 0 0]';

    % preallocate matrices for mirror and detector spot patterns
    numbruns = N;
    penalties = zeros(numbruns, 1); 
    overall_area = zeros(numbruns, 1);
    mirror_spots = zeros(numbruns, 2);

    counter = 0; 
    P_cavity = [];

    for i = 1:N   
        % Take a care of all of the cavity pulses
        % Reflect the incoming ray off the back face of the ICOS mirror

        if i == 1
            [P_cavity, ~] = P_init.vertical_plane_constraint(-w); 
        end

        % [P_harriet, P_init] = P_harriet.spherical_mirror_constraint(ctr_harriet, r_harriet, dt);
        %P_harriet.draw(); 

        P = P_cavity; 

        index = i;

        % Extend the pulse to the second lens and create bleedthrough
        [P, P2] = P.spherical_mirror_constraint(ctr1, r, dt); 

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
        overall_area(i) = sum(areas);

        % Extend the pulse back to the first lens and create bleedthrough
        [~, P3] = P2.spherical_mirror_constraint(ctr2, r, dt);      

        P_cavity = P3; 

        % Record detector spot pattern
        detector_spots(index,1) = P.p(2);
        detector_spots(index,2) = P.p(3);

    end

    % Penalize paramter combinations that send rays outside of the bounds of
    % the mirrors
    spot_radii_2 = (mirror_spots.^2) * [1; 1]; 
    spot_radii = sqrt(spot_radii_2); 
    penalties = penalty * sum(double(spot_radii > (mirror_diameter / 2))); 
    % plot overlapping area graph
    maximum_cum_sum = conv(30*pi*0.059^2*ones(1, N), ones(1, 30)); 
    running_cum_sum = conv(overall_area, ones(1, 30)); 
    % figure()
    % plot(running_cum_sum)
    % ylim([0, 30*0.3281])

    % "goodness score" 
    goodness_v1 = sum(running_cum_sum) / sum(maximum_cum_sum); 
    goodness = goodness_v1 + penalties; 
end

end