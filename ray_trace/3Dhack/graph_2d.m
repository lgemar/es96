%%
% Draw two 2-D mirrors
% r: radius
% R: radius of curvature
% w: thickness at center
% l: Spacing
cd c:\Data\ES96\ICOS
r = 2;
R = 45;
w = 0.2;
l = 8; % cavity lenth
l1 = 9; % position of collection mirror
lf = l1 + r;
FP = [lf 0];
ML = 10e-2;
n_iter = 50;
handles = zeros(n_iter,5);
Hi = 1;
I = NaN * zeros(n_iter*2+10);
Laser = I;
Ix = 1:length(I);
I(1:5) = 0;
Laser(1:5) = 0;
Ii = 5;
II = 1; % Internal Intensity
EI = 0;

clf
ax = nsubplot(4,1,4);
Ii = plotI(ax, Ix, Laser, I, Ii);

ax2 = nsubplot(4,1,[3 3]);
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
R = R.intersect_ray(M1.backside);
handles(Hi,1) = R.draw; %('P',[0 0.3*r]);
R = R.propagate;
%
%h = text(-w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
[R, R2] = R.reflect_arc(M2.face);
handles(Hi,2) = R.draw;%('e^{-\sigma{}Nl}', [0 0.3*r]);
%
RC = ray([l1, -r], [0 1]);
%h = text(l+w/2, 1.2*r, 'L');
%set(h,'HorizontalAlignment','Center');
E1 = R.propagate;
E1 = E1.intersect_ray(RC);
handles(Hi,3) = E1.draw;
F1 = ray(E1.E, FP-E1.E);
handles(Hi,4) = F1.draw;
[R2, R3] = R2.reflect_arc(M1.face);
handles(Hi,5) = R2.draw;
%h = text(R2.O(1)-0.5, R2.O(2)-0.4, '(1-L)');
%set(h,'HorizontalAlignment','Center');
EI = EI*(1-ML) + 1;
I(Ii) = EI;
Laser(Ii) = 1;
Ii = plotI(ax,Ix,Laser,I,Ii);

%%
for Hi = 2:n_iter
  E1a = R2.propagate;
  E1a.D = [-1 0];
  E1a.E = E1a.O+E1a.D;
  handles(Hi,1) = E1a.draw;
  [R3, R2] = R3.reflect_arc(M2.face);
  handles(Hi,2) = R3.draw;
  E2 = R3.propagate;
  E2.D = [1 0];
  E2 = E2.intersect_ray(RC);
  handles(Hi,3) = E2.draw;
  [R2, R3] = R2.reflect_arc(M1.face);
  handles(Hi,4) = R2.draw;
  F2 = ray(E2.E, FP-E2.E);
  handles(Hi,5) = F2.draw;
  II = II * (1-ML);
  EI = EI*(1-ML) + 1;
  I(Ii) = EI;
  Laser(Ii) = 1;
  Ii = plotI(ax,Ix,Laser, I,Ii);
end
%%
Hi=1;
delete(handles(Hi,:));
EI = EI*(1-ML);
I(Ii) = EI;
Laser(Ii) = 0;
Ii = plotI(ax,Ix,Laser,I,Ii);
%%
for Hi = 2:n_iter
  delete(handles(Hi,:));
  EI = EI*(1-ML);
  I(Ii) = EI;
  Laser(Ii) = 0;
  Ii = plotI(ax,Ix,Laser,I,Ii);
end