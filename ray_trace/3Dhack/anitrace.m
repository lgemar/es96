function anitrace(basename)
nframes = 40;
n=[0:nframes]/nframes; % 60 frames
N = n.^2 * 300;
az = (2*n.^3-1) * 37.5;
zf = 2*n.^3+1;
el = 20;
for i = 1:length(N)
  % trace3d(5,1,.11,N(i));
  trace3d(5,1,2.112,N(i));
  % trace3d(75,2,2.11,N(i));
  %view(az(i),el);
  camzoom(1.8);
  set(gcf,'InvertHardcopy','off');
  drawnow; shg;
  if nargin > 0
    fname = sprintf( '%s%03d.png', basename, i );
    eval([ 'print -r0 -dpng ' fname ]);
  end
end
