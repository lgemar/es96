function x1 = ray_sphere_solver(p1, p2, sphere_center, sphere_radius)
    % @param[in] p1 is the origin of the ray and p2 - p1 defines the sphere's direction
    % @param[in] p2 is any point on the ray
    % @param[in] sphere_center is a point in 3D space defining the center of the sphere
    % @param[in] sphere_radius is the radius of the sphere being intersected with the line
    % @pre @a p1, @a p2, and @a sphere_center are all column vectors
    % @post @a x1 is returned as a column vector
    % @post x1 is the solution such that (p2 - p1)' * x1 > 0
    % @post x2 is the solution such that (p2 - p1)' * x2 < 0
    % @post if there is no solution, x1 = NaN
    % @returns x1, the point of intersection between the ray and the sphere. 

    % Define the origin and direction for the line in 3D space
    % Imagine the equation of the line is given by x = o + d * l
    o = p1;
    l = (p2 - p1) / sqrt((p2 - p1)' * (p2 - p1)); 

    %% Solve for d
    % Check the discriminants
    discriminant = (l' * (o - sphere_center))^2 - (o - sphere_center)' * (o - sphere_center) + sphere_radius^2;

    % Check how many solutions there are
    if(discriminant) < 0
        disp('There is no solution')
        x1 = NaN; 
        x2 = NaN;
    else
        d1 = -(l' * (o - sphere_center)) + sqrt(discriminant);
        d2 = -(l' * (o - sphere_center)) - sqrt(discriminant);

        solution1 = o + d1 * l;
        solution2 = o + d2 * l;

        % Ensure that the solution is the one that points in the direction of the ray
        if(d1 > 0) 
            x1 = solution1; 
            x2 = solution2; 
        else if(d2 > 0)
            x1 = solution2; 
            x2 = solution1;
        else
            x1 = NaN;
            disp('There is no intersection of the directed ray with the sphere')
        end
    end
end
