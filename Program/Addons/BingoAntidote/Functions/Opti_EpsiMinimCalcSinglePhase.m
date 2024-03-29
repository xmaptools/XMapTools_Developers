function [ESP,CompoMod] = Opti_EpsiMinimCalcSinglePhase(WorkVariMod,WorkVariXMap,BinPhaseDef,app)
% 

NameSel = BinPhaseDef.DBMinName;
ElsSel = BinPhaseDef.ListVariAntidote;
WeightSel = BinPhaseDef.ListWeightAntidote; 

WherePhaseInMod = find(ismember(WorkVariMod.Names,NameSel));
WherePhaseInXMap = find(ismember(WorkVariXMap.Names,NameSel));

[Yes1,WhereElemInMod] = ismember(ElsSel,WorkVariMod.Els);
[Yes2,WhereElemInXMap] = ismember(ElsSel,WorkVariXMap.Els);

KeepElement = find(WhereElemInMod ~= 0);

ElemsList = WorkVariMod.Els;

if length(WherePhaseInMod) %&& sum(Yes1) == length(Yes1)
    
    % Correction of O for H in the structural formula:
    WhereH = find(ismember(ElemsList,'H'));
    if WhereH
        TheHValues = WorkVariMod.COMP(:,WhereH);
        WorkVariMod.COMP(1:WorkVariMod.NbPhases,WhereH) = zeros(WorkVariMod.NbPhases,1);
    else
        TheHValues = 0;
    end
    
    WhereO = find(ismember(ElemsList,'O'));
    if WhereO
        WorkVariMod.COMP(1:WorkVariMod.NbPhases,WhereO) = WorkVariMod.COMP(1:WorkVariMod.NbPhases,WhereO)-0.5*TheHValues;
    end

%     % Calcul of the structural formula from theriak output...  OLD version // commented PL 09.06.17   
%     WhereO = find(ismember(WorkVariMod.Els,'O'));
%     NormFact = WorkVariXMap.COMP(WherePhaseInXMap,1)/WorkVariMod.COMP(WherePhaseInMod,WhereO);
%     
    CompoMod = zeros(size(WhereElemInMod));
    CompoXMap = zeros(size(WhereElemInMod));
    Unc1s = zeros(size(WhereElemInMod));
    
    CompoMod(find(WhereElemInMod)) = WorkVariMod.COMP(WherePhaseInMod,WhereElemInMod(find(WhereElemInMod))); %.*repmat(NormFact,1,length(WhereElemInMod(find(WhereElemInMod))));
    CompoXMap(find(WhereElemInXMap)) = WorkVariXMap.COMP(WherePhaseInXMap,WhereElemInXMap(find(WhereElemInXMap)));
    Unc1s(find(WhereElemInXMap)) = WorkVariXMap.UNC(WherePhaseInXMap,WhereElemInXMap(find(WhereElemInXMap)));
    
    %CompoMod 
    if ~isequal(length(CompoMod),length(CompoXMap)) % ,length(WeightSel))   PL ** 03.03.19
        disp('Oups something went wrong in Opti_EpsiMinimCalcSinglePhase')
        keyboard
    end 
    
    % Eqation (3) in Duesterhoeft & Lanari (in prep)
    DIFFabs = abs(CompoMod-CompoXMap); 
    
    % Parameters for calculating Qcmp:
    Fac1 = 1;                    % plateau at 1 sigma for Qcmp of 100 %
    Fac2 = 5;               % NOTE: the zero is at Fac1+Fac2 (6 sigma)!
    
    % Check for Unc < 0.01 and replace by 0.01                     (PL)
    WhereTOOLOW = find(Unc1s > 0 & Unc1s <0.01);
    if length(WhereTOOLOW)
        Unc1s(WhereTOOLOW) = 0.01*ones(size(Unc1s(WhereTOOLOW)));
    end
    
    DIFF2 = DIFFabs-(Unc1s/Fac1);
    
    WhereNEGZ = find(DIFF2<=0);
    if length(WhereNEGZ)
        DIFF2(WhereNEGZ) = zeros(size(WhereNEGZ));
    end
    WherePOSZ = find(DIFF2>Fac2*Unc1s);
    if length(WherePOSZ)
        DIFF2(WherePOSZ) = Fac2*Unc1s(WherePOSZ).*ones(size(WherePOSZ));
    end
    
    
    % -------------------------------------------------------------------------
    % Qcmp_ij - Eqation (4) in Duesterhoeft & Lanari (in prep)
    QUALsmall = (1-DIFF2./(Fac2*Unc1s)).^(CompoMod+1);
    
    % -------------------------------------------------------------------------
    
    % Note: This equation was updated by PL (21.06.2019) to fit the MS
    % the old version was: %QUALsmall = 1*((Fac2*Unc1s-DIFF2)./(Fac2*Unc1s)).^(CompoMod+1);
    
    
    WhereNAN = find(isnan(QUALsmall));
    if WhereNAN
        % zero concentration in the map (must be zero
        % quality)
        QUALsmall(WhereNAN) = zeros(size(WhereNAN));
    end
    
    
    % -------------------------------------------------------------------------
    % Weighting - see Eqation (5) in Duesterhoeft & Lanari (in prep)
    ESP = -mean(QUALsmall(KeepElement)).*100;
    
    
    % -------------------------------------------------------------------------
    % Attempt to optimize in the 100 % region (kicking the -1s out)
    % PL 21.06.2019
    if isequal(ESP,-100)
        
        QUALnoSigma = (1-DIFFabs./(Fac2*Unc1s)).^(CompoMod+1);
        ESPnoSigma = mean(QUALnoSigma(KeepElement));
        %disp(num2str(ESPnoSigma))
        ESP = ESP-ESPnoSigma;
        
    end
    %disp(num2str(ESP))
    
    
else
    ESP = 1e18;
    CompoMod = zeros(length(ElsSel),1);
end
return