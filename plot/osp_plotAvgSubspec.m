function osp_plotAvgSubspec(MRSCont, ii, in, seq, routine)
% Plot and print the averaged ON/OFF (MEGA) or A–D subspectra (HERMES)
% This is mostly useful for debugging or assessing data quality issues

if strcmp(seq, 'HERMES')
    n_subspec = 4;
    experiment = {'A','B','C','D'};
else
    n_subspec = 2;
    experiment = {'ON','OFF'};
end

% Average subspec
if in.dims.averages > 0
    subspecs = real(squeeze(mean(in.specs, in.dims.averages)));
else
    subspecs = real(in.specs);
end

spec_plot_dir = fullfile(MRSCont.outputFolder, 'Figures', 'OspreyProcess', ...
    'avg_subspecs', routine);
if ~exist(spec_plot_dir, 'dir')
    mkdir(spec_plot_dir);
end

if ishandle(401)
    clf(401);
end
h = figure('Visible', 'off');
if ~isMATLABReleaseOlderThan("R2025a")
    h.Theme = 'light';
end

% First, plot subspectra separately
figDims.w = 0.7;
if strcmp(seq, 'HERMES')
    figDims.h = 0.7;
else
    figDims.h = 0.5;
end
figDims.l = (1 - figDims.w)/2;
figDims.b = (1 - figDims.h)/2;
set(h, 'Color', 'w', 'Units', 'Normalized', ...
    'OuterPosition', [figDims.l figDims.b figDims.w figDims.h]);

p = tiledlayout('flow','TileSpacing','compact','Padding','compact');
for jj = 1:n_subspec
    ax = nexttile(p);
    plot(ax, in.ppm, subspecs(:,jj));
    set(ax, 'XDir', 'reverse', 'XLim', [0.5 4.25], 'box', 'off', ...
        'TickDir', 'out');
    title((experiment{jj}), 'FontSize', 20);
    xlabel('ppm', 'FontSize', 16);
end

[~,fname] = fileparts(MRSCont.files{ii});
if strcmp(seq, 'HERMES')
    png_name = fullfile(spec_plot_dir, [fname '_A-D_subspec_separate.png']);
else
    png_name = fullfile(spec_plot_dir, [fname '_ON_OFF_subspec_separate.png']);
end
exportgraphics(h, png_name, 'Resolution', 300);

% Now plot them overlapped
clf(h);
figDims.w = 0.5;
figDims.h = 0.5;
figDims.l = (1 - figDims.w)/2;
figDims.b = (1 - figDims.h)/2;
set(h, 'OuterPosition', [figDims.l figDims.b figDims.w figDims.h]);

hold on;
for jj = 1:n_subspec
    plot(in.ppm, subspecs(:,jj));
    set(gca, 'XDir', 'reverse', 'XLim', [0.5 4.25], 'box', 'off', ...
        'TickDir', 'out');
    xlabel('ppm', 'FontSize', 16);
end
hold off;
legend(experiment, 'FontSize', 20, 'Box', 'off', 'Location', 'northeast');

if strcmp(seq, 'HERMES')
    png_name = fullfile(spec_plot_dir, [fname '_A-D_subspec_overlapped.png']);
else
    png_name = fullfile(spec_plot_dir, [fname '_ON_OFF_subspec_overlapped.png']);
end
exportgraphics(h, png_name, 'Resolution', 300);

end
