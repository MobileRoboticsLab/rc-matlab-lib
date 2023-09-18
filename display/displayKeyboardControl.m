function plotData = displayKeyboardControl(RC, display, plotData)

if ~isempty(plotData)
    return
end

display.Figure.KeyPressFcn = @(~,evt) keyPress(RC, evt.Key);
display.Figure.KeyReleaseFcn = @(~,evt) keyRelease(RC, evt.Key);

% Create a blank plot
plotData = plot(0, 0, 'w'); % 'w' means white; essentially this plots nothing
axis off; % Turn off the axis
xlim([-3 3]);
ylim([-3 3]);
hold on;

% Font size and border size for the letters
fontSize = 36;
borderSize = 1.0;

% Display the keys and borders
drawKeyWithBorder(0, 1, 'W', fontSize, borderSize);
drawKeyWithBorder(-2, -1, 'A', fontSize, borderSize);
drawKeyWithBorder(0, -1, 'S', fontSize, borderSize);
drawKeyWithBorder(2, -1, 'D', fontSize, borderSize);

hold off;
end

% Helper function to draw a key letter with a border
function drawKeyWithBorder(x, y, key, fontSize, borderSize)
text(x, y, key, 'FontSize', fontSize, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
rectangle('Position', [x - borderSize, y - borderSize, 2*borderSize, 2*borderSize], 'EdgeColor', 'k');
end

