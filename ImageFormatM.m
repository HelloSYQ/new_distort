% Input variables:                                                         %
% name of the image, x label and y label font size, title font size,       %
% colormap, xlabel name, ylabel name, title, name of new image.            %



function result = ImageFormatM(imF,fontsize1,fontsize2,colormaP1,xLabel,yLabel,titlE,self_caxis,newname)
    
    imshow(imF,[]);
    set(gcf,'units','normalized','position',[0.1 0.1 0.55 0.8]);
    set(gca,'position',[0.02 0.1 1 0.8]);
%    set(gca,'looseInset',[0 0 0 0]);
%    set(gca,'LooseInset',get(gca,'TightInset'));
%    axis on;
    title(titlE);
    xlabel(xLabel);
    ylabel(yLabel);
    
    caxis(self_caxis);
    colorbar;
    colormap(colormaP1);
    pause(1);
%     caxis([min(min(imF)),max(max(imF))]);
    set(gca,'FontSize',fontsize1);
    set(get(gca,'xlabel'),'FontSize',fontsize1);
    set(get(gca,'ylabel'),'FontSize',fontsize1);
    set(get(gca,'title'),'FontSize',fontsize2);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 7 6])
    print(gcf,'-dpng',newname,'-r300');
    result = newname;
end