%% Set up parameter space
num_trials = 5; 

% Define the options for length
min_length = cm2in(30); % 45 cm
max_length = cm2in(60); % 55 cm
lengths = linspace(min_length, max_length, num_trials)'; 

% Define the options for radius of curvature
delta = 0.01; 
min_radius = max_length / 2 + delta; % ? cm
max_radius = cm2in(1000); % 100 cm
radii = linspace(min_radius, max_radius, num_trials)';

% Define options for the input angle
alpha_min = 0; 
alpha_max = 0.1; 
alpha_space = linspace(alpha_min, alpha_max, num_trials)'; 

% Create a table of input parameters
x_var = radii; 
y_var = lengths; 
temp = repmat(x_var', num_trials, 1); 
x_options = temp(:); 
y_options = repmat(y_var, num_trials, 1); 
params = table(x_options, y_options); 

% Define the function to minimize
to_minimize = @(x, y) icos_fit_score(x, y, [-1 0.8 0.8], [1 -0.01 -0.005]); 

%% Compute goodness scores
goodness = rowfun(to_minimize, params); 
goodness_array = table2array(goodness); 
x_array = arrayfun(@in2cm, x_options); 
y_array = arrayfun(@in2cm, y_options); 
conclusion_table = table(goodness_array, x_array, y_array);

%% Plot the results 
x_mat = reshape(x_array, num_trials, num_trials); 
y_mat = reshape(y_array, num_trials, num_trials); 
goodness_mat = reshape(log(goodness_array), num_trials, num_trials);
surf(x_mat, y_mat, goodness_mat)
xlabel('X Var')
ylabel('Y Var')
zlabel('Log(loss)')

