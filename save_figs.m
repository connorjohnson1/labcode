FolderName = 'D:\Users\Connor Johnson\Desktop\ACC Figures\Sociability\approach\familiarmouse';
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for i = 1:length(FigList)
    
  name = strrep(char(all_traces((length(FigList)+2)-i)), ' ', '_');
  %name = num2str(i);
  FigHandle = FigList(i);
  saveas(FigHandle, fullfile(FolderName, [name, '.fig']));
  saveas(FigHandle, fullfile(FolderName, [name, '.png']));
  
end
