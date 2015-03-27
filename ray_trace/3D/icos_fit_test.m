num_trials = 10; 

min_radius = 9.834; % 25 cm
max_radius = 78.74; % 2 m
radii = linspace(min_radius, max_radius, num_trials); 

min_length = 7; % 5 cm
max_length = 23.622; % 60 cm

% to_minimize = @(r) icos_fit_score(r, min_length, [-1 0.8 0.8]', [1 -0.2 -0.1]'); 
% goodness = arrayfun(to_minimize, radii); 
figure()
plot(radii, goodness)

to_minimize = @(params) icos_fit_score(params(1), params(2), [-1 0.8 0.8]', [params(3) params(4) params(5)]'); 
optimal_params = fminsearch(to_minimize, [min_radius, min_length, 1, -0.1, -0.05])