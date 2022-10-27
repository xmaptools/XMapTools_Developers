function [Output,Antidote_VARIABLES] = Antidote_4_OptPTX(WorkVariXMap,MinimOptions,Text2Disp,HTML_1,HTML_2,app)
%
%
%

% Load MinimOptions to enable TEST mode
load('MinimOptions.mat');

BinPhaseDef = app.BinPhaseDef(app.SelectedPhaseOptiDropDown.Value);

if ~BinPhaseDef.SelForBA
    uialert(app.BingoAntidote_GUI,'This phase is not selected for BA and cannot be used for optimisation','Bingo-Antidote – Error');
    Output.WeCallBingo = 0;
    Antidote_VARIABLES = [];
    return
end

Tmin = app.TminEditField.Value;
Tmax = app.TmaxEditField.Value;
Pmin = app.PminEditField.Value;
Pmax = app.PmaxEditField.Value;
Res = app.AntidoteGridresolutionEditField.Value;

Ti = [Tmin:(Tmax-Tmin)/(Res-1):Tmax];
Pi = [Pmin:(Pmax-Pmin)/(Res-1):Pmax];

LIMS = [Ti(1),Ti(end),Pi(1),Pi(end)];

[BinSet] = SetBin(app);

Text2Disp = [Text2Disp,['Antidote: Recipe [4] - Find Optimal P-T (single phase)'],'<br />'];
Text2Disp = [Text2Disp,['Bulk: ',BinSet.Bulk2Display],'<br />'];
Text2Disp = [Text2Disp,['Database: ',BinSet.Database],'<br /><br />'];
app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];


if isequal(MinimOptions.Search.Symplex.FirstOpt,1) % Preliminary P-T input
    Text2Disp = [Text2Disp,['##### Exploratory P-T scanning (',num2str(Res),' x ',num2str(Res),') #####'],'<br /><br />'];
    app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];
    
    Compt = 0;
    Compt2 = 0; LimDisp = 5;
    
    ESP = zeros(length(Pi),length(Ti));
    
    for iTC = 1:length(Ti)
        for iP = 1:length(Pi)
            [Res] = OptiBingoPTSinglePhase([1,1],[Ti(iTC),Pi(iP)],LIMS,BinSet,WorkVariXMap,BinPhaseDef,app);
            if Res < 150
                ESP(iP,iTC) = Res;
            else
                ESP(iP,iTC) = 0;
            end
        end
        imagesc(app.UIAxes_LiveAntidote1,Ti,Pi,ESP);
        app.UIAxes_LiveAntidote1.YDir = 'normal';
        colormap(app.UIAxes_LiveAntidote1,[RdYlBu(64);0,0,0]);
        colorbar(app.UIAxes_LiveAntidote1)
        xlabel(app.UIAxes_LiveAntidote1,'Temperature (°C)');
        ylabel(app.UIAxes_LiveAntidote1,'Pressure (GPa)');
        title(app.UIAxes_LiveAntidote1,'Objective function (-Q_{cmp})');
        hold(app.UIAxes_LiveAntidote1,'on')
        
        ShiftVal = 1;  % (in % of Qcmp)
        if max(ESP(:))+ShiftVal > 0
            MaxValuePlot = 0;
        else
            MaxValuePlot = max(ESP(:))+ShiftVal;
        end
        caxis(app.UIAxes_LiveAntidote1,[min(ESP(:))-ShiftVal MaxValuePlot])
        
        drawnow
    end
    ht1 = toc;
    
    ValueMin = min(ESP(:));
    [sP,sTC] = find(ESP==ValueMin);
    
    if length(sP) > 1 && length(sTC) >1 && ValueMin <= -100
        
        Text2Disp = [Text2Disp,[' ** WARNING **'],'<br />'];
        Text2Disp = [Text2Disp,[' The minimum is NON-UNIQUE as the bottom of the objective function is flat'],'<br />'];
        Text2Disp = [Text2Disp,[' with ',num2str(length(sP)),' pixels having a value of ',num2str(ValueMin)],'<br />'];
        Text2Disp = [Text2Disp,[' -> a random selection has been made and Antidote will not converge'],'<br />'];
        Text2Disp = [Text2Disp,[' in this flat region (non-unique minimum)'],'<br /><br />'];
        app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];
        
        WeTake = floor(1+rand(1)*length(sTC));
        
        plot(app.UIAxes_LiveAntidote1,Ti(sTC),Pi(sP),'om')
        plot(app.UIAxes_LiveAntidote1,Ti(sTC(WeTake)),Pi(sP(WeTake)),'*m')
        drawnow
        
        X0 = [round(Ti(sTC(WeTake))),Pi(sP(WeTake))];
        
        
    elseif length(sP) > 1 && length(sTC)>1
        % Starting point from Bingo...
        
        Text2Disp = [Text2Disp,['THE SELECTED PHASE IS NOT STABLE in the PT range -> Let''s try with P-T from Bingo '],'<br /><br />'];
        app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];
        
        X0 = [app.BingoTemperatureEditField.Value,app.BingoPressureEditField.Value];
        
    else
        
        Text2Disp = [Text2Disp,['RESULTS (Exploratory P-T scanning)'],'<br />'];
        Text2Disp = [Text2Disp,['X0(1) = ',num2str(Pi(sP)),' (P,GPa)'],'<br />'];
        Text2Disp = [Text2Disp,['X0(2) = ',num2str(Ti(sTC)),' (T,°C)'],'<br /><br />'];
        app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];
       
        plot(app.UIAxes_LiveAntidote1,Ti(sTC),Pi(sP),'*m')
        drawnow
        
        X0 = [Ti(sTC),Pi(sP)];
    end
    
    Text2Disp = [Text2Disp,['CPU time: ',num2str(ht1),' s'],'<br /><br />'];
    app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];
    
else
    X0 = [app.BingoTemperatureEditField.Value,app.BingoPressureEditField.Value];
end

options = optimset('fminsearch'); options=optimset(options,'TolX',0.0001,'TolFun',0.0001,'display','iter','MaxFunEvals',300,'MaxIter',100);

NORM = X0;
X0 = X0./NORM;

Text2Disp = [Text2Disp,['##### P-T Optimization (from: ',num2str(NORM(2)),' GPa; ',num2str(NORM(1)),' C) #####'],'<br /><br />'];
app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];

tic
f = @OptiBingoPTSinglePhase;
[Result,Res] = fminsearch(f, X0,options,NORM,LIMS,BinSet,WorkVariXMap,BinPhaseDef,app);
ht2 = toc;

TCf = Result(1)*NORM(1);
Pf = Result(2)*NORM(2);

Text2Disp = [Text2Disp,['P = ',num2str(Pf),' GPa'],'<br />'];
Text2Disp = [Text2Disp,['T = ',num2str(TCf),' °C'],'<br /><br />'];
Text2Disp = [Text2Disp,['CPU time: ',num2str(ht2),' s'],'<br /><br />'];
app.HTML_AntidoteReport.HTMLSource = [HTML_1,Text2Disp,HTML_2];

ESP = Res;

app.BingoTemperatureEditField.Value = TCf;
app.BingoPressureEditField.Value = Pf;

Output.WeCallBingo = 1;
Output.WeSaveWorkspace = 1;
Output.Message = 'Success';

w = whos;
for a = 1:length(w)
    if ~isequal(w(a).name,'eventdata') && ~isequal(w(a).name,'hObject') && ~isequal(w(a).name,'handles')
        Antidote_VARIABLES.(w(a).name) = eval(w(a).name); 
    end
end


return