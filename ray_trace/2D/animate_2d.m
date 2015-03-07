%%
% Draw two 2-D mirrors
% r: radius
% R: radius of curvature
% w: thickness at center
% l: Spacing
r = 2;
R = 45;
w = 0.2;
l = 8; % cavity lenth
l1 = 9; % position of collection mirror
lf = l1 + r;

clf
M1 = mirror(r, R, w, [0 0], [1 0]);
hold on;
M2 = mirror(r, R, w, [l 0], [-1 0]);
set(gca,'xlim', [-2.2 lf+1], 'ylim', 1.5*[-r r], 'DataAspectRatio',[1 1 1],'visible','off');
%
rx0 = -2;
ry0 = 0.9*r;
R = ray([rx0 ry0], [1 0]);
%%
R = R.intersect_ray(M1.backside);
R.draw('P',[0 0.3*r]);
R = R.propagate;
%%
h = mtext(-w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
[R, R2] = R.reflect_arc(M2.face);
R.draw('e^{-\sigma{}Nl}', [0 0.3*r]);
%%
RC = ray([l1, -r], [0 1]);
h = mtext(l+w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
E1 = R.propagate;
E1 = E1.intersect_ray(RC);
E1.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
h = mtext(R2.O(1)-0.5, R2.O(2)-0.4, '(1-L)');
% set(h,'HorizontalAlignment','Center');
%%
E1a = R2.propagate;
E1a.D = [-1 0];
E1a.E = E1a.O+E1a.D;
E1a.draw;
[R3, R2] = R3.reflect_arc(M2.face);
R3.draw;
h = mtext(R3.O(1)+0.5, R3.O(2)-0.4, '(1-L)');
% set(h,'HorizontalAlignment','Center');
%%
E2 = R3.propagate;
E2.D = [1 0];
E2 = E2.intersect_ray(RC);
E2.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
%%
L = lens(0.2, M2.r, 15, ray([l1, 0], [1 0]));
E1.draw;
E2.draw;
FP = [lf 0];
F1 = ray(E1.E, FP-E1.E);
F1.draw;
F2 = ray(E2.E, FP-E2.E);
F2.draw;
%%
E1a = R2.propagate;
E1a.D = [-1 0];
E1a.E = E1a.O+E1a.D;
E1a.draw;
[R3, R2] = R3.reflect_arc(M2.face);
R3.draw;
%%
E2 = R3.propagate;
E2.D = [1 0];
E2 = E2.intersect_ray(RC);
E2.draw;
[R2, R3] = R2.reflect_arc(M1.face);
R2.draw;
F2 = ray(E2.E, FP-E2.E);
F2.draw;
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