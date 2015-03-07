function Ii = plotI(ax, Ix, Laser, I, Ii)
plot(ax, Ix, Laser*8, 'r', Ix, I, '*b');
set(ax,'xlim',[0 max(Ix)+1], 'ylim',[0 10],'XTickLabel',[],'YTickLabel',[]);
Ii = Ii+1;
drawnow;
