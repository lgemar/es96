%% Set up parameter space
num_trials = 500; 

% Define the options for length
min_length = cm2in(45); % 45 cm
max_length = cm2in(55); % 55 cm
lengths = linspace(min_length, max_length, num_trials)'; 

% Define the options for radius of curvature
delta = 0.01; 
min_radius = cm2in(50); % ? cm
max_radius = cm2in(200); % 100 cm
radii = linspace(min_radius, max_radius, num_trials)';

% Define options for the input angle
alpha_min = 0; 
alpha_max = 0.01; 
alpha_space = linspace(alpha_min, alpha_max, num_trials)'; 

% Create a table of input parameters
x_var = radii; 
y_var = alpha_space; 
temp = repmat(x_var', num_trials, 1); 
x_options = temp(:); 
y_options = repmat(y_var, num_trials, 1); 
params = table(x_options, y_options);  

% r/l ratios to explore
r_l_ratio = linspace(1, 4, num_trials); 

%% Goodness vs radius of curvature
to_minimize = @(x) icos_fit_score(x, cm2in(50), [-1 1 0.5], [1 -0.01 -3*0.01]);
goodness_array = arrayfun(to_minimize, radii); 
plot(arrayfun(@in2cm, radii), goodness_array)
ylabel('Laser Spot Overlap / max(Laser Spot Overlap)')
xlabel('Radius of curvature for ICOS mirror (cm)')
ax = gca;
ax.XTick = linspace(50, 200, 7);
ax.YTick = [0.5e-3]; 

%% Goodness vs length of cavity
to_minimize = @(x) icos_fit_score(cm2in(100), x, [-1 1 0.5], [1 -0.01 -5*0.01]);
goodness_array = arrayfun(to_minimize, lengths); 
plot(lengths, goodness_array)
ylabel('Overlap (in^2')
plot(arrayfun(@in2cm, lengths), goodness_array)
ylabel('Overlap (in^2')
xlabel('Length of cavity (cm)')

%% Goodness vs r/l ratio
to_minimize = @(x) icos_fit_score(cm2in(48*x), cm2in(48), [-1 1 0.5], [1 -0.01 -5*0.01]);
goodness_array = arrayfun(to_minimize, r_l_ratio); 
plot(r_l_ratio, goodness_array)
ylabel('Laser Spot Overlap / max(Laser Spot Overlap)')
xlabel('r/l ratio')
ylim([0 1e-3])
ax = gca;
ax.YTick = [0.5e-3]; 

%% Compute goodness scores

% Define the function to minimize
to_minimize = @(x, y) icos_fit_score(x, cm2in(50), [-1 1 0.5], [1 -y -5*y]);
goodness = rowfun(to_minimize, params); 
goodness_array = table2array(goodness); 
conclusion_table = table(goodness_array, x_options, y_options);

%% Plot the results 
x_mat = reshape(arrayfun(@in2cm, x_options), num_trials, num_trials); 
y_mat = reshape(atan(y_options), num_trials, num_trials); 
goodness_mat = reshape(log(goodness_array), num_trials, num_trials);
surf(x_mat, y_mat, goodness_mat)
xlabel('Radius of curvature (cm)')
ylabel('Input angle')
zlabel('Log(loss)')

