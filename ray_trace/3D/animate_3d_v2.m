%% Close all and Clear all
clear variables
close all
hold on

%% note to self: need to enter fields for indices of refraction for mirrors

%% Set all parameters and draw mirrors, lenses, and detectors

% SPECIFICATIONS
    % the RIM
    R_RIM = cm2in(39.37); % radius of curvature of RIM (in)
    distance_RIM = 9.84; % distance between RIM mirror and 1st ICOS mirror
    reflect_RIM = 1;
    % the ICOS mirrors
    r = 1.5; % mirror radius (in)
    R = 30; % radius of curvature of the ICOS mirrors (in)
    w = 0.2; % thickness at center (in)
    l = cm2in(50); % cavity length (in)
    reflect = .99975;
    ctr_thick = cm2in(0.2); % center thickness (in)
    
    % the lenses
    l1 = l+1; % position of first lens, inch past second ICOS mirror
    
    % what is this? it's never used
    lf = l1 + 2*r; % d/f = 1
    % SPECS WE CAN'T CHANGE
    R_CX_1 = cm2in(8.0122); % Lens1 radii (1) 
    R_CC_1 = cm2in(29.8275); % Lens1 radii (2)
    fl1 = cm2in(7.62); % Lens 1 focal length (in)
    ct1 = cm2in(.9); % center thickness of lens
    
    % SPECS WE CAN CHANGE
    ct2 = .2;
    l2 = l1 + fl1; % position of second lens
    l3 = l2 + 1; % position of third lens
    l4 = l3 + 1; % position of fourth lens
    
    second = true; % second lens implemented
    third = false; % third lens implemented?
    fourth = false; % fourth lens implemented?
    
    %the detector
    ld = l2 + 1; % position of detector
    size = cm2in(1); % size of detector

% make and draw two mirrors in cavity
mirror3d(0, 0, 1, w, r, R); 
mirror3d(l, 0, -1, w, r, R);
mirror3d(-distance_RIM, 0, -1, w, r, R); 

% Draw the lenses after the cavity
lens3d( l1, r, R_CX_1, R_CC_1, ct1);
if second
    lens3d( l2, r/2, R_CX_1, R_CC_1, ct2);
end
if third
    lens3d( l3, r, R_CX_1, R_CC_1, ct3);
end
if fourth
    lens3d( l4, r, R_CX_1, R_CC_1, ct3);
end

% Draw the cube 
cube3d([ld, -(size/2), -(size/2)], size);
  
% Draw the lens
L = lens(l1, r, R_CX_1, R_CC_1, ct1);

% Make it look pretty
set(gca,'xlim', [-(distance_RIM+1) ld+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
set(gca,'visible','off');
set(gcf,'color',[.75 .75 1]);
camlight left;
camlight right;
camlight headlight;

%% Pulse particle Test
p0 = [-(distance_RIM + 1) 1 0.5]'; % Initial position of ray
dir_initial = [1 -0.005 7*-0.005]'; % Initial direction of ray
P_init = PulsePoint(p0, dir_initial); % Initial Pulse

% keep track of detector power
detect_pow = 0;

% create mirrors
mirror1 = mirror(0,r,R,reflect, ctr_thick);
mirror2 = mirror(l,r,R,reflect, ctr_thick);
RIMirror = mirror(-distance_RIM,r,R_RIM,reflect_RIM, ctr_thick);

% create lenses
lens1 = lens(l1, r, R_CX_1, R_CC_1, ct1);
if second
    lens2 = lens(l2, r, R_CX_1, R_CC_1, ct1);
end
if third
    lens3 = lens(l3, r, R_CX_1, R_CC_1, ct1);
end

N1 = 3; % number of RIM reflections
N2 = 5; % number of ICOS reflections

n_air = 1; % index of refraction of air
n_ZnSe = 2.4361; % index of refraction of ZnSe

for i = 1:N1 
    
    P_init.draw();
    % Extend the pulse to the first mirror and create bleedthrough P_cavity
    % and reflection P_RIM
    
    % ray intersects flat surface of first mirror, bleedthrough
    [P_inter1] = P_init.vertical_plane_constraint(mirror1.ctr(1) - ctr_thick, n_air, n_ZnSe);
    P_inter1.draw();
    
    % ray intersects reflective curved surface of first mirror, bleedthrough
    % and reflect
    % **CHECK (2) - there's something wrong here when I try to draw P_RIM
    % 11 lines down; does there need to be refraction coming from within
    % the mirror to bleeding through the spherical surface?
    [P_cavity, P_inter2] = P_inter1.spherical_mirror_constraint(mirror1.ctr, mirror1.R);
    
    % draw the ray traveling between flat surface of 1st mirror to curved
    % surface of 1st mirror (within mirror1)
    P_cavity.draw();
 
    % ray bleeds through flat surface of first mirror
    [P_RIM] = P_inter2.vertical_plane_constraint(mirror1.ctr(1) - ctr_thick, n_ZnSe, n_air);
   
    % draw reflected ray within the mirror1
    P_RIM.draw();
    
    % P_RIM is pulse going left through RIM, P_init is pulse going right to ICOS
    % P_init will be used on the next loop as the incoming ray
    [P_RIM,P_init] = P_RIM.spherical_mirror_constraint(RIMirror.ctr,RIMirror.R);
    P_RIM.draw();
    
    for j = 1:N2
        
        P_rt = P_cavity;

        % Extend the pulse back to the second mirror and create bleedthrough
        [P_rt, P_left] = P_rt.spherical_mirror_constraint(mirror2.ctr, mirror2.R);
        P_rt.draw();
        
        % CHECK (3) - when I added this, I ran into the error of
        % lens_constraint complaining that fzero needed a finite and real
        % starting guess...?
        
        % ray intersects flat surface of second mirror, bleedthrough
        % [P_rt] = P_rt.vertical_plane_constraint(mirror2.ctr(1) - ctr_thick, n_ZnSe, n_air);
        % P_rt.draw();        

        % ******* FOLLOWING P_rt ******** 

        % Intersect the ray with the first surface of the first lens
        P = P_rt.lens_constraint(lens1.ctr1, lens1.R_CX, 1, 5); 
        P.draw(); 

        % Intersect the ray with the second surface of the first lens
        P = P.lens_constraint(lens1.ctr2, lens1.R_CC, 5, 1); 
        P.draw(); 

        if second
            % Intersect the ray with the first surface of the second lens
            P = P.lens_constraint(lens2.ctr1, lens2.R_CX, 1, 5); 
            P.draw(); 
            % Intersect the ray with the second surface of the second lens
            P = P.lens_constraint(lens2.ctr2, lens2.R_CC, 5, 1); 
            P.draw();     
        end
        if third
            % Intersect the ray with the first surface of the third lens
            P = P.lens_constraint(lens3.ctr1, lens3.R_CX, 1, 5); 
            P.draw(); 
            % Intersect the ray with the second surface of the third lens
            P = P.lens_constraint(lens3.ctr2, lens3.R_CC, 5, 1); 
            P.draw();  
        end    

        % Intersect the ray with the plane of the detector
        [P] = P.vertical_plane_constraint(ld, 1, 1);
        P.draw();
        
        % Determine if within angle of +/- 15 degrees
         angle = radtodeg(acos(dot(P.dir,[1;0;0])));
         if abs(P.p(2))<cm2in(10) && abs(P.p(3))<cm2in(10)
             detect_pow = detect_pow + P.pow;
         end

        % ******* FOLLOWING P_left in next inner loop ******** 

        % Extend the pulse to the first mirror and reflect back as P_cavity 
        % for next loop
        [P_left, P_cavity] = P_left.spherical_mirror_constraint(mirror1.ctr, mirror1.R); 
        P_left.draw();
        
        % Draw the pulses up until now
        drawnow;  
    end
end
