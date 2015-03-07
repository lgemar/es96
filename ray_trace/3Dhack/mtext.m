function h = mtext(x, y, t, offset)
% h = mtext(t, offset)
if nargin < 4
  offset = [0 0];
end
h = text(x+offset(1), y+offset(2), t);
set(h, 'HorizontalAlignment', 'center','fontsize',14);
