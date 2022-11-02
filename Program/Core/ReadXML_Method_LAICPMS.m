function [EN,DT,MZ] = ReadXML_Method_LAICPMS(FileName)
% 
%
% Created by P. Lanari (02.11.2022)

DT = [];
EN = {};
MZ = [];

fid = fopen(FileName);

while 1
    NextLine = fgetl(fid);
    
    if isequal(NextLine,-1)
        break
    end
    
    Str = textscan(NextLine,'%s','delimiter',{'>','<'});
    Str = Str{1};
    
    if length(Str) > 2
        if isequal(Str{2},'IntegrationTime')
            DT(end+1) = str2num(Str{3});
        end
        if isequal(Str{2},'MZ')
            MZ(end+1) = str2num(Str{3});
        end
        if isequal(Str{2},'ElementName')
            EN{end+1} = Str{3};
        end
        if isequal(Str{2},'OptimizeID')
            break
        end
    end
    
    if length(Str) > 1 
        
    end
end

fclose(fid);

% convert DT in ms
DT = DT * 1e3;

end