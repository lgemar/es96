%%
% Draw two 2-D mirrors
r = 2; % lens radius (in)
R = 45; % radius of curvature of the lens (in)
w = 0.2; % thickness at center (in)
l = 8; % cavity lenth (in)
l1 = 9; % position of collection mirror, inch past second ICOS mirror
lf = l1 + 2*r; % d/f = 1

clf
M1 = mirror(r, R, w, [0 0], [1 0]);
hold on;
M2 = mirror(r, R, w, [l 0], [-1 0]);
L = lens(0.2, M2.r, 15, ray([l1, 0], [1 0]));
set(gca,'xlim', [-2.2 lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
%
rx0 = -2;
ry0 = 0.9*r;
R = ray([rx0 ry0], [1 0]);
%%
% First ray to the mirror
R = R.intersect_ray(M1.backside);
R.draw('P',[0 0.3*r]);
R = R.propagate;
%%
% First ray through the cavity
h = mtext(-w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
[R, R2] = R.reflect_arc(M2.face);
R.draw('e^{-\sigma{}Nl}', [0 0.3*r]);
%%
% First reflection back through the cavity
RC = ray([l1, -r], [0 1]);
h = mtext(l+w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
E1 = R.propagate;
E1 = E1.intersect_ray(RC);
E1.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
% set(h,'HorizontalAlignment','Center');
%%
E1a = R2.propagate;
E1a.D = [-1 0];
E1a.E = E1a.O+E1a.D;
E1a.draw;
[R3, R2] = R3.reflect_arc(M2.face);
R3.draw;
% set(h,'HorizontalAlignment','Center');
%%
E2 = R3.propagate;
E2.D = [1 0];
E2 = E2.intersect_ray(RC);
E2.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
%%
E1.draw;
E2.draw;
FP = [lf 0];
%%
for i=1:50
  E1a = R2.propagate;
  E1a.D = [-1 0];
  E1a.E = E1a.O+E1a.D;
  E1a.draw;
  [R3, R2] = R3.reflect_arc(M2.face);
  R3.draw;
  drawnow;
  %%
  E2 = R3.propagate;
  E2.D = [1 0];
  E2 = E2.intersect_ray(RC);
  E2.draw;
  [R2, R3] = R2.reflect_arc(M1.face);
  R2.draw;
  F2 = ray(E2.E, FP-E2.E);
  F2.draw;
  drawnow;
end
