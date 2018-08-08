function plotHdc(PM, alpha, gridCenterPoints, fbarjoint, hdrBinary, x1Hdc, x2Hdc, x3Hdc, x4Hdc)
%PLOTHDC plots a highest density contour
%   PM          probabilistic model
%   alpha       probability outside the contour / exceedance probability
%   gridCenterPoints       grid center locations; formatted as cell,
%                          thus gridCenterPoints{1} contains the vector
%                          for the first variable / dimension
%   fbarjoint   cell averaged probability density
%   hdrBinary   highest density region, 1 = is region
%   x1Hdc       coordinate dimension 1 of contour
%   x2Hdc       coordinate dimension 2 of contour
%   x3Hdc       coordinate dimension 3 of contour
%   x4Hdc       coordinate dimension 4 of contour
%
%   4-dimensional data are plotted with only the first 3 dimensions shown 

p = length(gridCenterPoints); % number of dimensions

figure();
titleString = ['pdf: ' PM(1).name ', alpha = ' num2str(alpha, '%.2e')];
if p == 2
    panelA = subplot(1,3,1);
    imagesc(gridCenterPoints{1}, gridCenterPoints{2}, fbarjoint')
    set(gca,'YDir','normal')
    xlabel(PM.labels{1})
    ylabel(PM.labels{2})
    title('pdf');
    colormap(panelA, jet)
    axis square

    panelB = subplot(1,3,2);
    imagesc(gridCenterPoints{1}, gridCenterPoints{2}, hdrBinary');
    set(gca,'YDir','normal')
    xlabel(PM.labels{1})
    ylabel(PM.labels{2})
    title('R(fm)');
    colormap(panelB, flipud(gray))
    axis square
    
    panelC = subplot(1,3,3);
    hold on
    for i = 1:length(x1Hdc)
        plot(x1Hdc{i}, x2Hdc{i}, '-k', 'LineWidth', 2);
    end
    xlim([0 max(gridCenterPoints{1})]);
    ylim([0 max(gridCenterPoints{2})]);
    xlabel(PM.labels{1})
    ylabel(PM.labels{2})
    title('C(fm)');
    axis square

else
    if p >= 3    
        subplot(1,3,1)
        hdrBinaryIndices=find(hdrBinary);
        if p == 3
            [i1,i2,i3] = ind2sub(size(hdrBinary),hdrBinaryIndices);
        else
            if p == 4
                [i1,i2,i3,i4] = ind2sub(size(hdrBinary),hdrBinaryIndices);
            end
        end
        x1Hdr = gridCenterPoints{1}(i1);
        x2Hdr = gridCenterPoints{2}(i2);    
        x3Hdr = gridCenterPoints{3}(i3); 

        pointsHdr = [x1Hdr' x2Hdr' x3Hdr'];
        plot3(x1Hdr, x2Hdr, x3Hdr, '.b');
        view(3)
        xlabel(PM.labels{1});
        ylabel(PM.labels{2});
        zlabel(PM.labels{3});
        title('R(fm)');
        xlim([0 max(gridCenterPoints{1})]);
        ylim([0 max(gridCenterPoints{2})]);
        zlim([0 max(gridCenterPoints{3})]);
        axis square

        subplot(1,3,2)
        plot3(x1Hdc{1}, x2Hdc{1}, x3Hdc{1}, '.r');
        view(3)
        xlabel(PM.labels{1});
        ylabel(PM.labels{2});
        zlabel(PM.labels{3});
        title('C(fm), points');
        xlim([0 max(gridCenterPoints{1})]);
        ylim([0 max(gridCenterPoints{2})]);
        zlim([0 max(gridCenterPoints{3})]);
        axis square
        
        subplot(1,3,3);
        SHRINK_FACTOR_3D = 1;
        k = boundary(pointsHdr,SHRINK_FACTOR_3D); % see https://de.mathworks.com/help/matlab/ref/boundary.html
        trisurf(k,x1Hdr,x2Hdr,x3Hdr,'Facecolor','red','FaceAlpha',0.1);
        view(3)
        xlabel(PM.labels{1});
        ylabel(PM.labels{2});
        zlabel(PM.labels{3});
        title('C(fm), triangulated');
        xlim([0 max(gridCenterPoints{1})]);
        ylim([0 max(gridCenterPoints{2})]);
        zlim([0 max(gridCenterPoints{3})]);
        axis square
        
        if p>3
            titleString = [titleString ', only first 3 dimensions are shown'];
        end

    end
end
if exist('suptitle') == 2
    suptitle(titleString);
else % thanks to: https://de.mathworks.com/matlabcentral/newsreader/view_thread/244434
    set(gcf,'NextPlot','add');
    axes;
    h = title(titleString);
    set(gca,'Visible','off');
    set(h,'Visible','on');
end
end

% code by Andras F. Haselsteiner