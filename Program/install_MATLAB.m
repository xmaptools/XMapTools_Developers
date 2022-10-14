function [] = install_MATLAB()
%

Where = which('XMapTools');
Where = Where(1:end-16);

addpath(Where);

addpath([Where,'/Core']);

addpath([Where,'/Dev']);
addpath([Where,'/Dev/Data_Std_LAICPMS']);
addpath([Where,'/Dev/help']);
addpath([Where,'/Dev/help/img']);
addpath([Where,'/Dev/icons']);
addpath([Where,'/Dev/logo']);
addpath([Where,'/Dev/splash']);

addpath([Where,'/External']);
addpath([Where,'/External/ME']);
addpath([Where,'/External/SF']);
addpath([Where,'/External/TB']);

addpath([Where,'/Modules']);

addpath([Where,'/Addons']);
addpath([Where,'/Addons/XThermoTools']);
addpath([Where,'/Addons/XThermoTools/XTT_Dev/logo']);
addpath([Where,'/Addons/XThermoTools/XTT_Dev/img']);
addpath([Where,'/Addons/XThermoTools/XTT_Core']);
addpath([Where,'/Addons/XThermoTools/XTT_Databases']);
addpath([Where,'/Addons/XThermoTools/XTT_Dev']);
addpath([Where,'/Addons/XThermoTools/XTT_Functions']);
addpath([Where,'/Addons/XThermoTools/XTT_Modules']);

% Bingo Antidote (2022.1)
addpath([Where,'/Addons/BingoAntidote']);
addpath([Where,'/Addons/BingoAntidote/Dev']);
addpath([Where,'/Addons/BingoAntidote/Dev/icons']);
addpath([Where,'/Addons/BingoAntidote/Dev/media']);
addpath([Where,'/Addons/BingoAntidote/Core']);
addpath([Where,'/Addons/BingoAntidote/Databases']);
addpath([Where,'/Addons/BingoAntidote/Functions']);
addpath([Where,'/Addons/BingoAntidote/Modules']);


savepath

disp('Installation completed')

end