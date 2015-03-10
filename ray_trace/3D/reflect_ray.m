function new_direction_unit = reflect_ray(p1, p2, n)
    % param[in] @a p1 is the origin of the incoming ray
    % param[in] @a p2 is point of intersection with the plane defined by @a n
    % param[in] @a n is the normal vector defining the plane off of which the ray reflects
    % @a new_direction is the direction of the outgoing ray
    % @returns @a new_direction_unit, which is a unit vector in the direction of outgoing ray


    old_direction = (p2 - p1);
    new_direction = -2 * (old_direction' * n) * n + old_direction;

    new_direction_unit = new_direction / (sqrt(new_direction' * new_direction));
end
