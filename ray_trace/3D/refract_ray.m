function new_direction_unit = refract_ray(p1, p2, n, n1, n2)
    % p1 original position, p2 on actual surface, n is normal vector
    n = n / sqrt(n' * n); % normal vector (make sure it's a unit vector)
    old_direction = (p2 - p1); % old direction vector
    old_direction = (old_direction) / sqrt((old_direction' * old_direction)); 
    
    r_parallel = (n' * old_direction) * n; 
    r_perp_old = old_direction - r_parallel; 
    
    r_perp_new = (n1 / n2) * r_perp_old; 
    
    new_direction = (r_parallel + r_perp_new); 
    new_direction_unit = new_direction / sqrt(new_direction' * new_direction); 
end