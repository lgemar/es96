%% Specify interface for ICOS fns
% param[in] @a n_lens is the number of lenses
% param[in] @a d_lens is the diameter of the lens, an 1xn_lens row vector
% param[in] @a f_lens is the focal length of the lens, an 1xn_lens row
%   vector
% param[in] @a w_lens is the center thickness of the lenses, a 1xn_lens
%   row vector
% param[in] @a R1 is the concave radius of curvature for the lens, a
%   n_lensx1 vector
% param[in] @a R2 is the convex radius of curvature for the lens
%   n_lensx1 vector
% param[in] @a gap_lens is the distance from the back of the ICOS cell
% param[in] @a r_icos is the radius of curvature for ICOS mirrors
% param[in] @a l_cavity is the length of the ICOS cavity

% General: if you are confused about any Matlab function, search it on
%   google. Mathworks has fantastic documentation! 
% 1) TODO: wrap the animate_3d_v2 test in a function, where interesting
% variables are inputs, rather than constants, and metrics are outputs
%   - see icos_fit_score for an example of how to do this
%   - see
%   http://www.mathworks.com/help/matlab/ref/function.html?refresh=true for
%   info on how to write a function in Matlab and specify the interface
% 2) TODO: create table of trials by substituting real parameter
%   configurations for the dummy ones here. remember that each row of the
%   "trials" table is a parameter configuration
% 3) TODO: substitute the "myfun" with the animate_3d_v2 function once it
%   is turned into functional form

% The Big Picture 

% Step 1: 
% Create a table of parameters, where each row is a set of parameters used
%   to run through the simulation. The table might look like this in the
%   simple case: 
%   r_icos    l_cavity      f 
%   50        48       [20 21 22 23] 
%   50        48.5     [23 24 25 26]
%   50        49       [27 28 29 30]
%   50        49.5     [19 21 23 25]

% Step 2: 
% Apply the icos simulation to every row in the parameter configuration
%   table
% For example, pretend the icos simulation was called "icos_simulation" 
% First, rowfun will apply icos_simulation(50, 48), then it will apply
% icos_simulation(50, 48.5), and so on, storing the output in an array.
% Storing the results in a table that looks like 
%   output 
%   <metric result for (50, 48)> 
%   <metric result for (50, 48.5)> 
%   <metric result for (50, 49)>
%   <metric result for (50, 49.5)>

% Step 3: 
% Examine the output table to see how good each configuration was at
% meeting the metric you've defined

% Step 4: 
% Choose to sweep over whatever parameters you like, keeping the other
% parameters constant. Remember, the trials table must have a value for
% every parameter in each row in order to run the trial

% Define the number of trials
N = 20; 
n_lens = 2; % fix the number of lenses to consider

% Define a dummy function for testing. Your icos simulation will replace
% this. See TODO #1
% myfun = @(d_lens, f_lens, w_lens, R1, R2, gap_lens, r_icos, l_cavity) d_lens;  
% 
% %% Configurations with 2 lenses
% % Pick the diameters to use for each of the N trials
% min_d_lens = 1.5; % units of inches, TODO: use cm2in or in2cm, as needed
% max_d_lens = 3; 
% d_lens_array = linspace(min_d_lens, max_d_lens, N);
% 
% d_lens_trials = [d_lens_array', d_lens_array']; 
% 
% % Pick the focus lengths to use for the N trials
% min_f_lens = 2; 
% max_f_lens = 4; 
% f_lens_array = linspace(min_f_lens, max_f_lens, N); 
% 
% f_lens_trials = [f_lens_array', f_lens_array']; 
% 
% % Pick the lens widths to use for the N trials
% min_w_lens = 0.1; 
% max_w_lens = 0.4; 
% w_lens_array = linspace(min_w_lens, max_w_lens, N); 
% 
% w_lens_trials = [w_lens_array', w_lens_array']; 
% 
% % Pick the R1s to use for the N trials
% min_R1 = 15; 
% max_R1 = 20; 
% R1_array = linspace(min_R1, max_R1, N); 
% 
% R1_trials = [R1_array', R1_array']; 
% 
% % Pick the R2s to use for the N trials
% min_R2 = 15; 
% max_R2 = 20; 
% R2_array = linspace(min_R2, max_R2, N); 
% 
% R2_trials = [R2_array', R2_array']; 
% 
% % Pick the lens gap values that you want for the N trials
% min_gap_lens = 0.5; 
% max_gap_lens = 2; 
% gap_lens_trials = linspace(min_gap_lens, max_gap_lens, N)'; 
% 
% % Pick the ICOS mirror radius of curvature needed for the trials
% min_r_icos = cm2in(100); 
% max_r_icos = cm2in(100);  
% r_icos = linspace(min_r_icos, max_r_icos, N); 
% r_icos_trials = r_icos'; 
% 
% % Pick the ICOS mirror radius of curvature needed for the trials
% min_l_cavity = cm2in(48); 
% max_l_cavity = cm2in(48);  
% l_cavity = linspace(min_l_cavity, max_l_cavity, N); 
% l_cavity_trials = l_cavity'; 
%% pick values to iterate over

lens_cat_no1 = {'custom', 'custom'};
lens_cat_no2 = {'ZC-PM-25-25', 'ZC-PM-25-38'};
lens_cat_nos = [lens_cat_no1', lens_cat_no2'];

radius1 = [1.5, 1.5];
radius2 = [0.5, 0.5];
radius = [radius1', radius2'];

R_CX_1 = [cm2in(8.0122), cm2in(8.0122)];
R_CX_2 = [cm2in(22.91/10), cm2in(38.04/10)];
R_CXs = [R_CX_1', R_CX_2'];

R_CC_1 = [cm2in(29.8275), cm2in(29.8275)];
R_CC_2 = [cm2in(58.34/10), cm2in(122.73/10)];
R_CCs = [R_CC_1', R_CC_2'];

ct1 = [cm2in(.9), cm2in(.9)];
ct2 = [cm2in(4.40/10), cm2in(3.60/10)];
cts = [ct1', ct2'];

length1 = [cm2in(2/10), cm2in(2/10)];
length2 = [cm2in(1.1) + 2, cm2in(1.1) + 2];
lengths = [ length1', length2'];

%implement focal lengths later

    
%% Create the table for trials. Etach row is a trial
trials = table(radius, R_CXs, R_CCs, cts, lengths, lens_cat_nos); 

%% Apply the icos simulation to every row of the trials table
%output = rowfun(myfun, trials); % The output is a table of results
output = rowfun(@icos_lens_sims, trials); % The output is a table of results
