classdef DriftCorrector_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        DriftCorrectorGUI               matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        Image                           matlab.ui.control.Image
        GridLayout2                     matlab.ui.container.GridLayout
        AppyCorrection                  matlab.ui.control.Button
        ApplytoAllMapsCheckBox          matlab.ui.control.CheckBox
        SaveastxtfilesCheckBox          matlab.ui.control.CheckBox
        MaskSelectionOptionsPanel       matlab.ui.container.Panel
        GridLayout3                     matlab.ui.container.GridLayout
        DropDownMask                    matlab.ui.control.DropDown
        MaskLabel                       matlab.ui.control.Label
        FilterCheckBox                  matlab.ui.control.CheckBox
        DropDownFilter                  matlab.ui.control.DropDown
        CorrectionschemePanel           matlab.ui.container.Panel
        GridLayout3_2                   matlab.ui.container.GridLayout
        CorrectionLabel                 matlab.ui.control.Label
        DropDownCorrection              matlab.ui.control.DropDown
        ApplyAutoButton                 matlab.ui.control.StateButton
        DisplaytheCorrectionMapButton   matlab.ui.control.Button
        ResolutionValuePxInput          matlab.ui.control.EditField
        RespixelsLabel                  matlab.ui.control.Label
        SaveCorrectionMapasaFileButton  matlab.ui.control.Button
        Image2                          matlab.ui.control.Image
        AutoContrast_Button             matlab.ui.control.Button
        MaxEditField                    matlab.ui.control.NumericEditField
        MinEditField                    matlab.ui.control.NumericEditField
        MinLabel                        matlab.ui.control.Label
        MaxLabel                        matlab.ui.control.Label
        UIAxes                          matlab.ui.control.UIAxes
        UIAxes2                         matlab.ui.control.UIAxes
        UIAxes3                         matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        XMapToolsApp
        MaskId
        MapID
        Mask
        Map
        
        
        Data4Correction
        DataCorrected
        BRC
        
        CorrectionMapVq
        WaitBar % Description
    end
    
    methods (Access = private)
        
        function PlotFunction(app)
            
            cla(app.UIAxes3,'reset');
            cla(app.UIAxes2,'reset');
            
            app.UIAxes3.Visible = 'off';
            app.AutoContrast_Button.Visible = 'off';
            app.Image2.Visible = 'off';
            app.MaxLabel.Visible = 'off';
            app.MinLabel.Visible = 'off';
            app.MinEditField.Visible = 'off';
            app.MaxEditField.Visible = 'off';
            app.AutoContrast_Button.Visible = 'off';
            app.UIAxes.Visible = 'off';
            app.UIAxes2.Visible = 'off';
            
            if app.DropDownCorrection.Value > 0
                app.CorrectionschemePanel.Visible = 'on';
                app.UIAxes.Visible = 'on';
                app.UIAxes3.Visible = 'on';
                app.AutoContrast_Button.Visible = 'on';
                app.Image2.Visible = 'on';
                app.MaxLabel.Visible = 'on';
                app.MinLabel.Visible = 'on';
                app.MinEditField.Visible = 'on';
                app.MaxEditField.Visible = 'on';
                app.AutoContrast_Button.Visible = 'on';
                app.UIAxes2.Visible = 'on';
            end
            
            if isequal(app.DropDownCorrection.Value,1) 
                app.UIAxes3.Visible = 'off';
            elseif isequal(app.DropDownCorrection.Value,0)
                app.UIAxes2.Visible = 'off';
                app.UIAxes3.Visible = 'off';
            else
                app.UIAxes3.Visible = 'on';
            end
            
            app.DisplaytheCorrectionMapButton.Visible = 'off';
            
            Data2Plot = app.Map;
            
            ValueMask = app.DropDownMask.Value;
            
            if ValueMask
                UnselectedPx = find(app.Mask.MaskMap ~= ValueMask);
                Data2Plot(UnselectedPx) = 0;
            end
            
            if app.FilterCheckBox.Value
                Data2Plot = Data2Plot .* app.BRC;
            end
            
            imagesc(app.UIAxes,Data2Plot)
            axis(app.UIAxes,'image')
            colorbar(app.UIAxes)
            colormap(app.UIAxes,app.XMapToolsApp.ColorMapValues)
            
            if app.DropDownCorrection.Value && isequal(app.ApplyAutoButton.Value,1)
                
                if app.DropDownCorrection.Value && isequal(app.DropDownMask.Value,0)
                    
                    % We calculate a correction for multiple phases
                    ApplySelectedDataCorrectionMultiPhase(app);
                    
                else
                    % We calculate a correction for a single phase
                    app.Data4Correction = Data2Plot;
                    ApplySelectedDataCorrection(app);
                end
                
            end
            
            app.WaitBar = uiprogressdlg(app.DriftCorrectorGUI,'Title','XMapTools','Indeterminate','on');
            app.WaitBar.Message = 'Final update of the plots';
            
            if app.DropDownCorrection.Value
                Corrected = app.DataCorrected;
                
                if ValueMask
                    UnselectedPx = find(app.Mask.MaskMap ~= ValueMask);
                    Corrected(UnselectedPx) = 0;
                end
                
                if app.FilterCheckBox.Value
                    Corrected = Corrected .* app.BRC;
                end
                
                imagesc(app.UIAxes2,Corrected)
                axis(app.UIAxes2,'image')
                colorbar(app.UIAxes2)
                colormap(app.UIAxes2,app.XMapToolsApp.ColorMapValues)
                
                app.UIAxes2.XTick = [];
                app.UIAxes2.YTick = [];
                
                app.DisplaytheCorrectionMapButton.Visible = 'on';
                app.AppyCorrection.Enable = 'on';
            else
                app.DisplaytheCorrectionMapButton.Visible = 'off';
                app.AppyCorrection.Enable = 'off';
            end
            
            DataPlot = ExtractAllDataValuesFromPlot(app);
            
            app.MinEditField.Value = min(DataPlot);
            app.MaxEditField.Value = max(DataPlot);
            
            caxis(app.UIAxes,[app.MinEditField.Value,app.MaxEditField.Value]);
            
            if app.DropDownCorrection.Value
                caxis(app.UIAxes2,[app.MinEditField.Value,app.MaxEditField.Value]);
            end
            
            close(app.WaitBar)
            
        end
        
        function AdjustMinMax(app,Mode)
            
            ImageData = ExtractAllDataValuesFromPlot(app);          % extract ImageData from the figure
            ImageData = ImageData(find(ImageData));                 % exclude zeros (new 4.0.0)
            IdxNotNan = find(~isnan(ImageData));
            if length(IdxNotNan) > 0
                ImageData = ImageData(IdxNotNan);
            end
            SortedData = sort(ImageData(:));
            SelCrit = round(numel(SortedData) * 0.065);
            
            Min1 = SortedData(SelCrit);
            Max1 = SortedData(end-SelCrit);
            
            SortedData2 = SortedData(SelCrit:end-SelCrit);
            SelCrit2 = round(numel(SortedData2) * 0.065);
            
            Min2 = SortedData2(SelCrit2);
            Max2 = SortedData2(end-SelCrit2);
            
            %             Q = quantile(SortedData,12);
            %             Min1 = Q(1);
            %             Max1 = Q(10);
            %             Min2 = Q(2);
            %             Max2 = Q(9);
            
            % Current values:
            [Min,Max] = caxis(app.UIAxes);
            
            % Check values:
            if isequal(Min,Min1) && isequal(Max,Max1)
                Min = Min2;
                Max = Max2;
            elseif isequal(Min,Min2) && isequal(Max,Max2)
                Min = min(ImageData(:));
                Max = max(ImageData(:));
            else
                Min = Min1;
                Max = Max1;
            end
            
            app.MinEditField.Value = Min;
            app.MaxEditField.Value = Max;
            
            caxis(app.UIAxes,[app.MinEditField.Value,app.MaxEditField.Value]);
            if app.DropDownCorrection.Value
                caxis(app.UIAxes2,[app.MinEditField.Value,app.MaxEditField.Value]);
            end
        end
        
        function DataPlot = ExtractAllDataValuesFromPlot(app)
            
            h1 = findall(app.UIAxes,'Type','Image');
            if ~isempty(h1)
                DataPlot = h1.CData(find(h1.CData));
            end
            
            h2 = findall(app.UIAxes2,'Type','Image');
            if ~isempty(h2)
                DataPlot = [DataPlot;h2.CData(find(h2.CData))];
            end
            
        end
        
        function ApplySelectedDataCorrection(app)
            
            Xray = app.Data4Correction;
            
            % Already applied before sending the data
            %
            %             if app.FilterCheckBox.Value
            %                 Xray = Xray .* app.BRC;
            %             end
            
            switch app.DropDownCorrection.Value
                
                case 1    % 2D
                    dX = 50;
                    
                    GridX = [1+dX/2:dX:size(Xray,2)-dX/2];
                    GridY = [1+dX/2:dX:size(Xray,1)-dX/2];
                    
                    Grid = nan(numel(GridY),numel(GridX));
                    
                    for i = 1:numel(GridX)
                        for j = 1:numel(GridY)
                            PxSel1 = Xray(GridY(j)-dX/2:GridY(j)+dX/2,GridX(i)-dX/2:GridX(i)+dX/2);
                            PxSel = find(PxSel1 > 0);
                            if length(PxSel) > 0.15*dX^2   % at least 5 % of the pixels
                                Grid(j,i) = median(PxSel1(PxSel));
                            end
                        end
                    end
                    
                    Xq = [1:size(Xray,2)];
                    Yq = [1:size(Xray,1)];
                    
                    [X,Y] = meshgrid(GridX,GridY);
                    
                    Where = find(Grid > 1e-4);
                    F = scatteredInterpolant(X(Where), Y(Where), Grid(Where));
                    
                    [xq,yq] = meshgrid(Xq,Yq);
                    Vq = F(xq,yq);
                    
                    app.CorrectionMapVq = Vq;
                    
                    app.DataCorrected = ApplyCorrection2Map(app,Vq,app.Map);
                    
                case 2    % 1D (horizontal)
                    
                    [Profile,xc,yc,trend,trend4disp] = Interpolation1D(app, Xray, 'h');
                    
                    plot(app.UIAxes3,Profile,'.k')
                    hold(app.UIAxes3,'on');
                    
                    plot(app.UIAxes3,xc,yc,'.r')
                    
                    plot(app.UIAxes3, trend4disp, '-b');
                    hold(app.UIAxes3,'off');
                    
                    app.CorrectionMapVq = repmat(trend',[size(Xray,1),1]);
                    app.DataCorrected = ApplyCorrection2Map(app,app.CorrectionMapVq,app.Map);
                    
                case 3    % 1D (vertical)
                    
                    [Profile,xc,yc,trend,trend4disp] = Interpolation1D(app, Xray, 'v');
                    
                    plot(app.UIAxes3,Profile,'.k')
                    hold(app.UIAxes3,'on');
                    
                    plot(app.UIAxes3,xc,yc,'.r')
                    
                    plot(app.UIAxes3, trend4disp, '-b');
                    hold(app.UIAxes3,'off');
                    
                    app.CorrectionMapVq = repmat(trend,[1,size(Xray,2)]);
                    app.DataCorrected = ApplyCorrection2Map(app,app.CorrectionMapVq,app.Map);
                    
                    
            end
            
        end
        
        function ApplySelectedDataCorrectionMultiPhase(app)
            
            % Prepare the data
            
            AllData = app.Map;
            AllData4Correction(1).Data = [];
            
            for i = 1:app.DropDownMask.ItemsData(end)
                AllDataDuplicate = AllData;
                
                UnselectedPx = find(app.Mask.MaskMap ~= i);
                AllDataDuplicate(UnselectedPx) = 0;
                
                if app.FilterCheckBox.Value
                    AllDataDuplicate = AllDataDuplicate .* app.BRC;
                end
                
                AllData4Correction(i).Data = AllDataDuplicate;
                
            end
            
            switch app.DropDownCorrection.Value
                
                case 2    % 1D (horizontal)
                    MultiPhaseInterpolation(app,AllData4Correction,'h');
                
                case 3    % 1D (vertical)
                    MultiPhaseInterpolation(app,AllData4Correction,'v');
                    
                case 4
                    cla(app.UIAxes3,'reset')
                    if ~isequal(app.CorrectionMapVq(1,1), mean(app.CorrectionMapVq(1,:)))
                        plot(app.UIAxes3,app.CorrectionMapVq(1,:),'-r','LineWidth',2);
                    else
                        plot(app.UIAxes3,app.CorrectionMapVq(:,1),'-r','LineWidth',2);
                    end
                    app.DataCorrected = (1 ./ app.CorrectionMapVq) .* app.Map;
            end
            
            
        end
        
        
        function MultiPhaseInterpolation(app,AllData4Correction,Direction)
                
                for i = 1:numel(AllData4Correction)
                    switch Direction
                        case 'h'
                            [AllData4Correction(i).Profile, AllData4Correction(i).xc, AllData4Correction(i).yc, AllData4Correction(i).trend, AllData4Correction(i).trend4disp] = Interpolation1D(app, AllData4Correction(i).Data, 'h');
                            
                        case 'v'
                            [AllData4Correction(i).Profile, AllData4Correction(i).xc, AllData4Correction(i).yc, AllData4Correction(i).trend, AllData4Correction(i).trend4disp] = Interpolation1D(app, AllData4Correction(i).Data, 'v');
                    end
                end
                
                % Normalisation to the median of the non-zero values
                for i = 1:numel(AllData4Correction)
                    MedianValue(i) = median(AllData4Correction(i).trend4disp(find(AllData4Correction(i).trend4disp)),'omitnan');
                    AllData4Correction(i).trend4dispNORM = AllData4Correction(i).trend4disp ./ MedianValue(i);
                end
                
                cla(app.UIAxes3,'reset');
                hold(app.UIAxes3,'on');
                DataPlotted = [];
                Data4Interp = [];
                for i = 1:numel(AllData4Correction)
                    plot(app.UIAxes3, AllData4Correction(i).trend4dispNORM,'.k');
                    DataPlotted = [DataPlotted;AllData4Correction(i).trend4dispNORM];
                    Data4Interp = [Data4Interp,AllData4Correction(i).trend4dispNORM];
                end
                ylim(app.UIAxes3,[1-2*std(DataPlotted,'omitnan'),1+2*std(DataPlotted,'omitnan')])
                
                %% Weighted common drift profile from Data4Interp
                [nPt, nEl] = size(Data4Interp);
                X = (1:nPt)';
                
                % --- 0. Weights (one per element, e.g. median intensities) --------------
                Wel = MedianValue(:)';
                Wel = Wel / max(Wel);                % scale only, ratios are what matter
                
                Wmat = repmat(Wel, nPt, 1);
                Wmat(isnan(Data4Interp)) = NaN;      % same mask as the data
                
                % --- 1. Segment limits --------------------------------------------------
                Ref = fillmissing(median(Data4Interp,2,'omitnan'), 'linear', 'EndValues','nearest');
                bp  = findchangepts(Ref, 'MaxNumChanges', 4, 'Statistic', 'mean');
                seg = [1; bp(:); nPt+1];
                segID = discretize(X, seg);
                
                % --- 2. Weighted robust moving estimate ---------------------------------
                W      = 20;         % half-window in analysis points
                MinW   = 3;          % min summed weight in the window
                SigMin = 0.005;      % floor on the robust sigma
                Drift  = nan(nPt,1);
                
                for i = 1:nPt
                    in = abs(X - i) <= W & segID == segID(i);
                    v  = Data4Interp(in,:);   w = Wmat(in,:);
                    ok = ~isnan(v);
                    v  = v(ok);               w = w(ok);
                    if sum(w) < MinW, continue, end
                    
                    m = wmedian(app, v, w);                                  % weighted centre
                    s = max(1.4826 * wmedian(app,abs(v - m), w), SigMin);   % weighted MAD
                    keep = abs(v - m) <= 3*s;
                    if sum(w(keep)) < MinW, keep = true(size(v)); end   % safety net
                    
                    Drift(i) = sum(w(keep) .* v(keep)) / sum(w(keep));  % weighted mean
                end
                
                Drift = fillmissing(Drift, 'linear', 'EndValues', 'nearest');
                % Drift = movmean(Drift, 5);
                
                plot(app.UIAxes3, Drift, 'r-', 'LineWidth', 2)
                
                hold(app.UIAxes3,'off');
                
                switch Direction
                    case 'h'
                        app.CorrectionMapVq = repmat(Drift',[size(app.Map,1),1]);
                    case 'v'
                        app.CorrectionMapVq = repmat(Drift,[1,size(app.Map,2)]);
                end
                
                app.DataCorrected = (1 ./ app.CorrectionMapVq) .* app.Map;
                
                
        end
        
        
        function CalculateBRC(app)
            
            TheNbPx = 3;
            TheNbPxOnGarde = 80;
            
            switch app.DropDownFilter.Value
                case 'BRC (3,80)'
                    TheNbPx = 3;
                    TheNbPxOnGarde = 80;
                case 'BRC (3,100)'
                    TheNbPx = 3;
                    TheNbPxOnGarde = 100;
                case 'BRC (5,100)'
                    TheNbPx = 5;
                    TheNbPxOnGarde = 100;
                case 'BRC (9,100)'
                    TheNbPx = 9;
                    TheNbPxOnGarde = 100;
            end
            
            % Proceed to the correction
            TheLin = size(app.Mask.MaskMap,1);
            TheCol = size(app.Mask.MaskMap,2);
            %CoordMatrice = reshape([1:TheLin*TheCol],TheLin,TheCol);
            
            TheMaskFinal = zeros(size(app.Mask.MaskMap));
            
            Position = round(TheNbPx/2);
            TheNbPxInSel = TheNbPx^2;
            TheCriterion = TheNbPxInSel*TheNbPxOnGarde/100;
            
            for i=1:length(app.Mask.Names) - 1                % for each phase
                
                TheMask = zeros(size(app.Mask.MaskMap));
                VectorOk = find(app.Mask.MaskMap == i);
                
                TheMask(VectorOk) = ones(size(VectorOk));
                
                TheWorkingMat = zeros(size(TheMask,1)*size(TheMask,2),TheNbPxInSel+1);
                
                VectMask = TheMask(:);
                TheWorkingMat(find(VectMask)) = 1000*ones(size(find(VectMask)));
                
                Compt = 1;
                for iLin = 1:TheNbPx
                    
                    
                    for iCol = 1:TheNbPx
                        
                        % SCAN
                        TheTempMat = zeros(size(TheMask));
                        TheTempMat(Position:end-(Position-1),Position:end-(Position-1)) = TheMask(iLin:end-(TheNbPx-iLin),iCol:end-(TheNbPx-iCol));
                        Compt = Compt+1;
                        TheWorkingMat(:,Compt) = TheTempMat(:);
                        
                    end
                end
                
                TheSum = sum(TheWorkingMat,2);
                OnVire1 = find(TheSum < 1000+TheCriterion & TheSum > 1000);
                TheMaskFinal(OnVire1) = ones(size(OnVire1));
                
            end
            
            app.BRC = ones(size(TheMaskFinal));
            app.BRC(find(TheMaskFinal(:) == 1)) = zeros(length(find(TheMaskFinal(:) == 1)),1);
            
        end
        
        function DataCorrected = ApplyCorrection2Map(app,Vq,Map)
            
            [Value,IndinInd] =  max(Vq(:));
            
            CorrectionMatrix = Value-Vq;
            CorrectionMatrixPer = CorrectionMatrix./Vq;
            
            DataCorrected = Map + CorrectionMatrix;
            
            % Apply a new correction to keep the same average
            MeanInit = mean(Map(:));
            newMean = mean(DataCorrected(:));
            
            Delta = newMean-MeanInit;
            
            DataCorrected = DataCorrected - Delta;
            
        end
        
        
        
        function [Profile,xc,yc,trend,trend4disp] = Interpolation1D(app, Xray, Direction)
            
            Xray(find(Xray == 0)) = NaN;
            
            switch Direction
                case 'h'
                    Profile = median(Xray,1,"omitnan");
                case 'v'
                    Profile = median(Xray,2,"omitnan");
            end
            
            x = (1:numel(Profile))';
            y = Profile(:);
            
            invalidRaw = isnan(y);
            validRaw = ~isnan(y);
            x = x(validRaw);
            y = y(validRaw);
            
            %% 1. Outlier rejection
            mask = ~isoutlier(y);
            xc = x(mask);
            yc = y(mask);
            
            %% 2. Bin the data (robust median per bin) to suppress noise before fitting
            binWidth = 10;
            edges = min(xc):binWidth:max(xc)+binWidth;
            binIdx = discretize(xc, edges);
            
            binCenters = edges(1:end-1) + binWidth/2;
            binMedian = accumarray(binIdx, yc, [numel(binCenters) 1], @median, NaN);
            binCount  = accumarray(binIdx, 1,  [numel(binCenters) 1], @sum, 0);
            
            validBin = ~isnan(binMedian) & binCount > 0;
            bx = binCenters(validBin)';
            by = binMedian(validBin);
            bw = binCount(validBin);             % weight = how many points supported this bin
            bw = bw / max(bw);
            
            %% 3. Fit smoothing spline on binned data
            f = fit(bx, by, 'smoothingspline', 'Weights', bw, 'SmoothingParam', 0.99);
            
            trendAtBins = feval(f, bx);
            
            %% 4. Linear interp/extrap onto full profile length
            xFull = (1:numel(Profile))';
            trend = interp1(bx, trendAtBins, xFull, 'linear', 'extrap');
            
            trend4disp = trend;
            trend4disp(invalidRaw) = NaN;
            
        end
        
        
        function m = wmedian(app, v, w)
            v = v(:);  w = w(:);
            if isscalar(v), m = v; return, end
            [v, ix] = sort(v);  w = w(ix);
            c = (cumsum(w) - 0.5*w) / sum(w);
            m = interp1(c, v, 0.5, 'linear', 'extrap');
        end
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, XMapToolsApp, MapID, MaskId)
            
            % XMapTools is a free software solution for the analysis of chemical maps
            % Copyright © 2022-2026 University of Lausanne, Institute of Earth Sciences, Pierre Lanari
            
            % XMapTools is free software: you can redistribute it and/or modify
            % it under the terms of the GNU General Public License as published by
            % the Free Software Foundation, either version 3 of the License, or any
            % later version.
            
            % XMapTools is distributed in the hope that it will be useful,
            % but WITHOUT ANY WARRANTY; without even the implied warranty of
            % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
            % GNU General Public License for more details.
            
            % You should have received a copy of the GNU General Public License
            % along with XMapTools. If not, see https://www.gnu.org/licenses.
            
            app.DriftCorrectorGUI.Visible = 'off';
            
            movegui(app.DriftCorrectorGUI,'center');
            
            app.XMapToolsApp = XMapToolsApp;
            app.MaskId = MaskId;
            app.MapID = MapID;
            
            app.Mask = app.XMapToolsApp.XMapToolsData.MapData.MaskFile.Masks(MaskId);
            
            app.Map = app.XMapToolsApp.XMapToolsData.MapData.It.Data(MapID).Map;
            
            app.AppyCorrection.Enable = 'off';
            
            app.UIAxes3.Visible = 'off';
            app.AutoContrast_Button.Visible = 'off';
            app.Image2.Visible = 'off';
            app.MaxLabel.Visible = 'off';
            app.MinLabel.Visible = 'off';
            app.MinEditField.Visible = 'off';
            app.MaxEditField.Visible = 'off';
            app.AutoContrast_Button.Visible = 'off';
            app.UIAxes.Visible = 'off';
            app.UIAxes2.Visible = 'off';
            
            app.DropDownMask.Items = app.Mask.Names;
            app.DropDownMask.ItemsData = [0:length(app.Mask.Names)-1];
            
            app.DropDownCorrection.ItemsData = [0:length(app.DropDownCorrection.Items)-1];
            
            CalculateBRC(app); 
            
            app.DriftCorrectorGUI.Visible = 'on';
            
            PlotFunction(app);
            
            app.WaitBar = uiprogressdlg(app.DriftCorrectorGUI,'Title','XMapTools','Indeterminate','on');
            app.WaitBar.Message = 'Starting the module';
            
            DropDownCorrectionValueChanged(app);
            
            close(app.WaitBar)
            %keyboard
            
        end

        % Value changed function: DropDownMask
        function DropDownMaskValueChanged(app, event)
            DropDownCorrectionValueChanged(app,1);
            
        end

        % Value changed function: ApplyAutoButton
        function ApplyAutoButtonValueChanged(app, event)
            PlotFunction(app);
            
        end

        % Button pushed function: SaveCorrectionMapasaFileButton
        function SaveCorrectionMapasaFileButtonPushed(app, event)
            
            CorrectionMapVq = app.CorrectionMapVq;
            
            save('last_correction_map.txt','CorrectionMapVq','-ascii');
            
            uialert(app.DriftCorrectorGUI, 'File successfully saved', 'XMapTools', 'Icon','success');
            
        end

        % Value changed function: DropDownCorrection
        function DropDownCorrectionValueChanged(app, event)
            app.WaitBar = uiprogressdlg(app.DriftCorrectorGUI,'Title','XMapTools','Indeterminate','on');
            app.WaitBar.Message = 'Applying the correction and updating the plots';
            
            app.SaveCorrectionMapasaFileButton.Visible = 'off';
            app.ResolutionValuePxInput.Visible = 'off';
            app.RespixelsLabel.Visible = 'off';
            
            switch app.DropDownCorrection.Value
                case 1
                    app.ResolutionValuePxInput.Visible = 'on';
                    app.RespixelsLabel.Visible = 'on';
                    
                    switch app.DropDownMask.Value
                        case 0
                            uialert(app.DriftCorrectorGUI, 'This method is not available for multiphase. Use the mask dropdown menu to select a phase.', 'XMapTools', 'Icon','warning');
                            close(app.WaitBar)
                            return
                    end
                    
                case 2
                    app.SaveCorrectionMapasaFileButton.Visible = 'on';
                    
                case 3
                    app.SaveCorrectionMapasaFileButton.Visible = 'on';
                    
                case 4
                    try
                        app.CorrectionMapVq = load("last_correction_map.txt");
                    catch
                        uialert(app.DriftCorrectorGUI, 'Error, there is no last_correction_map.txt file available in the current working directory', 'XMapTools', 'Icon','Error');
                        close(app.WaitBar);
                        return
                    end
                    
            end
            
            PlotFunction(app);
            
            close(app.WaitBar)
            
        end

        % Value changed function: MinEditField
        function MinEditFieldValueChanged(app, event)
            AdjustMinMax(app,'auto');
        end

        % Value changed function: MaxEditField
        function MaxEditFieldValueChanged(app, event)
            AdjustMinMax(app,'auto');
        end

        % Button pushed function: AutoContrast_Button
        function AutoContrast_ButtonPushed(app, event)
            AdjustMinMax(app,'magic');
        end

        % Value changed function: FilterCheckBox
        function FilterCheckBoxValueChanged(app, event)
            PlotFunction(app);
        end

        % Value changed function: DropDownFilter
        function DropDownFilterValueChanged(app, event)
            CalculateBRC(app);
            PlotFunction(app);
        end

        % Button pushed function: DisplaytheCorrectionMapButton
        function DisplaytheCorrectionMapButtonPushed(app, event)
            
            
            [Value,IndinInd] =  max(app.CorrectionMapVq(:));
            
            CorrectionMatrix = Value-app.CorrectionMapVq;
            CorrectionMatrixPer = CorrectionMatrix./app.CorrectionMapVq;
            
            figure,
            tiledlayout('flow')
            
            nexttile
            imagesc(CorrectionMatrix), axis image, title('Correction matrix')
            colormap(app.XMapToolsApp.ColorMapValues)
            
            nexttile
            imagesc(CorrectionMatrix), axis image, title('Correction matrix (in %)')
            colormap(app.XMapToolsApp.ColorMapValues)
            
            
        end

        % Callback function
        function ResolutionValuePxInputValueChanged(app, event)
            PlotFunction(app);
        end

        % Button pushed function: AppyCorrection
        function AppyCorrectionButtonPushed(app, event)
            if isequal(app.ApplytoAllMapsCheckBox.Value,0)
                app.XMapToolsApp.XMapToolsData.MapData.It.Data(app.MapID).Map = app.DataCorrected;
                
                if isequal(app.SaveastxtfilesCheckBox.Value,1)
                    [Success,Message,MessageID] = mkdir('Corrected-Maps');
                    Map2Save = app.DataCorrected;
                    Name = char(app.XMapToolsApp.XMapToolsData.MapData.It.Names{app.MapID});
                        if length(Name) >= 5
                            if isequal(Name(end-2:end),'EDS')
                                Name = Name(1:end-3);
                            end
                        end
                    save(fullfile(cd,'Corrected-Maps',[app.MapID,'.txt']),'Map2Save','-ascii');
                end
                
            else
                % Apply the correction to all maps
                for i = 1:length(app.XMapToolsApp.XMapToolsData.MapData.It.Data)
                    app.XMapToolsApp.XMapToolsData.MapData.It.Data(i).Map = (1 ./ app.CorrectionMapVq) .* app.XMapToolsApp.XMapToolsData.MapData.It.Data(i).Map;
                end
                
                if isequal(app.SaveastxtfilesCheckBox.Value,1)
                    app.WaitBar = uiprogressdlg(app.DriftCorrectorGUI,'Title','XMapTools');
                    app.WaitBar.Message = 'Saving corrected maps';
                    [Success,Message,MessageID] = mkdir('Corrected-Maps');
                    for i = 1:length(app.XMapToolsApp.XMapToolsData.MapData.It.Data)
                        Map2Save = app.XMapToolsApp.XMapToolsData.MapData.It.Data(i).Map;
                        Name = char(app.XMapToolsApp.XMapToolsData.MapData.It.Names{i});
                        if length(Name) >= 5
                            if isequal(Name(end-2:end),'EDS')
                                Name = Name(1:end-3);
                            end
                        end
                        save(fullfile(cd,'Corrected-Maps',[Name,'.txt']),'Map2Save','-ascii');
                        app.WaitBar.Value = i/length(app.XMapToolsApp.XMapToolsData.MapData.It.Data);
                    end
                    close(app.WaitBar)
                end
                
%                 if ~isempty(app.XMapToolsApp.XMapToolsData.MapData.Ot.Names)
%                     Answer = uiconfirm(app.DriftCorrectorGUI, 'Do you want to apply the corrections to the maps in Others?)', 'XMapTools', 'Options', {'Yes','No'});
%                     if isequal('Answer','Yes')
%                         for i = 1:length(app.XMapToolsApp.XMapToolsData.MapData.Ot.Data)
%                             app.XMapToolsApp.XMapToolsData.MapData.Ot.Data(i).Map = (1 ./ app.CorrectionMapVq) .* app.XMapToolsApp.XMapToolsData.MapData.Ot.Data(i).Map;
%                         end
%                     end
%                 end
                
            end
            
            close(app.DriftCorrectorGUI)
            
            
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create DriftCorrectorGUI and hide until all components are created
            app.DriftCorrectorGUI = uifigure('Visible', 'off');
            app.DriftCorrectorGUI.Position = [100 100 1152 796];
            app.DriftCorrectorGUI.Name = 'Drift Correction Module  – XMapTools';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.DriftCorrectorGUI);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.RowSpacing = 5;

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.Layout.Row = [1 3];
            app.Image.Layout.Column = [1 11];
            app.Image.ImageSource = 'logo_xmap_final.png';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GridLayout);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {'0.1x', '1x', '0.6x'};
            app.GridLayout2.Padding = [10 5 10 5];
            app.GridLayout2.Layout.Row = [1 3];
            app.GridLayout2.Layout.Column = [26 35];

            % Create AppyCorrection
            app.AppyCorrection = uibutton(app.GridLayout2, 'push');
            app.AppyCorrection.ButtonPushedFcn = createCallbackFcn(app, @AppyCorrectionButtonPushed, true);
            app.AppyCorrection.Icon = '044-repeat.png';
            app.AppyCorrection.FontSize = 14;
            app.AppyCorrection.FontWeight = 'bold';
            app.AppyCorrection.Layout.Row = 2;
            app.AppyCorrection.Layout.Column = [2 9];
            app.AppyCorrection.Text = 'Apply Changes';

            % Create ApplytoAllMapsCheckBox
            app.ApplytoAllMapsCheckBox = uicheckbox(app.GridLayout2);
            app.ApplytoAllMapsCheckBox.Text = 'Apply to All Maps';
            app.ApplytoAllMapsCheckBox.FontSize = 11;
            app.ApplytoAllMapsCheckBox.Layout.Row = 3;
            app.ApplytoAllMapsCheckBox.Layout.Column = [2 5];

            % Create SaveastxtfilesCheckBox
            app.SaveastxtfilesCheckBox = uicheckbox(app.GridLayout2);
            app.SaveastxtfilesCheckBox.Text = 'Save as txt files';
            app.SaveastxtfilesCheckBox.FontSize = 11;
            app.SaveastxtfilesCheckBox.Layout.Row = 3;
            app.SaveastxtfilesCheckBox.Layout.Column = [6 9];

            % Create MaskSelectionOptionsPanel
            app.MaskSelectionOptionsPanel = uipanel(app.GridLayout);
            app.MaskSelectionOptionsPanel.TitlePosition = 'centertop';
            app.MaskSelectionOptionsPanel.Title = 'Mask Selection & Options';
            app.MaskSelectionOptionsPanel.Layout.Row = [4 6];
            app.MaskSelectionOptionsPanel.Layout.Column = [1 12];
            app.MaskSelectionOptionsPanel.FontWeight = 'bold';
            app.MaskSelectionOptionsPanel.FontSize = 14;

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.MaskSelectionOptionsPanel);
            app.GridLayout3.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout3.RowHeight = {'0.5x', '1x'};
            app.GridLayout3.ColumnSpacing = 5;
            app.GridLayout3.RowSpacing = 5;

            % Create DropDownMask
            app.DropDownMask = uidropdown(app.GridLayout3);
            app.DropDownMask.ValueChangedFcn = createCallbackFcn(app, @DropDownMaskValueChanged, true);
            app.DropDownMask.Layout.Row = 2;
            app.DropDownMask.Layout.Column = [1 4];

            % Create MaskLabel
            app.MaskLabel = uilabel(app.GridLayout3);
            app.MaskLabel.HorizontalAlignment = 'center';
            app.MaskLabel.VerticalAlignment = 'bottom';
            app.MaskLabel.FontSize = 11;
            app.MaskLabel.FontAngle = 'italic';
            app.MaskLabel.Layout.Row = 1;
            app.MaskLabel.Layout.Column = [1 4];
            app.MaskLabel.Text = 'Mask';

            % Create FilterCheckBox
            app.FilterCheckBox = uicheckbox(app.GridLayout3);
            app.FilterCheckBox.ValueChangedFcn = createCallbackFcn(app, @FilterCheckBoxValueChanged, true);
            app.FilterCheckBox.Text = 'Filter';
            app.FilterCheckBox.Layout.Row = 2;
            app.FilterCheckBox.Layout.Column = [5 6];
            app.FilterCheckBox.Value = true;

            % Create DropDownFilter
            app.DropDownFilter = uidropdown(app.GridLayout3);
            app.DropDownFilter.Items = {'BRC (3,80)', 'BRC (3,100)', 'BRC (5,100)', 'BRC (9,100)'};
            app.DropDownFilter.ValueChangedFcn = createCallbackFcn(app, @DropDownFilterValueChanged, true);
            app.DropDownFilter.Layout.Row = 2;
            app.DropDownFilter.Layout.Column = [7 9];
            app.DropDownFilter.Value = 'BRC (3,80)';

            % Create CorrectionschemePanel
            app.CorrectionschemePanel = uipanel(app.GridLayout);
            app.CorrectionschemePanel.TitlePosition = 'centertop';
            app.CorrectionschemePanel.Title = 'Correction scheme';
            app.CorrectionschemePanel.Layout.Row = [4 6];
            app.CorrectionschemePanel.Layout.Column = [13 35];
            app.CorrectionschemePanel.FontWeight = 'bold';
            app.CorrectionschemePanel.FontSize = 14;

            % Create GridLayout3_2
            app.GridLayout3_2 = uigridlayout(app.CorrectionschemePanel);
            app.GridLayout3_2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout3_2.RowHeight = {'0.5x', '1x'};
            app.GridLayout3_2.ColumnSpacing = 5;
            app.GridLayout3_2.RowSpacing = 5;

            % Create CorrectionLabel
            app.CorrectionLabel = uilabel(app.GridLayout3_2);
            app.CorrectionLabel.HorizontalAlignment = 'center';
            app.CorrectionLabel.VerticalAlignment = 'bottom';
            app.CorrectionLabel.FontSize = 11;
            app.CorrectionLabel.FontAngle = 'italic';
            app.CorrectionLabel.Layout.Row = 1;
            app.CorrectionLabel.Layout.Column = [14 16];
            app.CorrectionLabel.Text = 'Correction';

            % Create DropDownCorrection
            app.DropDownCorrection = uidropdown(app.GridLayout3_2);
            app.DropDownCorrection.Items = {'--- Select a correction method', 'Auto 2D', 'Auto 1D (horizontal)', 'Auto 1D (vertical)', 'Auto from file (last_correction_map.txt)'};
            app.DropDownCorrection.ItemsData = {'0', '1', '2', '3', '4'};
            app.DropDownCorrection.ValueChangedFcn = createCallbackFcn(app, @DropDownCorrectionValueChanged, true);
            app.DropDownCorrection.Layout.Row = 2;
            app.DropDownCorrection.Layout.Column = [1 6];
            app.DropDownCorrection.Value = '0';

            % Create ApplyAutoButton
            app.ApplyAutoButton = uibutton(app.GridLayout3_2, 'state');
            app.ApplyAutoButton.ValueChangedFcn = createCallbackFcn(app, @ApplyAutoButtonValueChanged, true);
            app.ApplyAutoButton.Text = 'Apply Auto';
            app.ApplyAutoButton.FontWeight = 'bold';
            app.ApplyAutoButton.Layout.Row = 2;
            app.ApplyAutoButton.Layout.Column = [14 16];
            app.ApplyAutoButton.Value = true;

            % Create DisplaytheCorrectionMapButton
            app.DisplaytheCorrectionMapButton = uibutton(app.GridLayout3_2, 'push');
            app.DisplaytheCorrectionMapButton.ButtonPushedFcn = createCallbackFcn(app, @DisplaytheCorrectionMapButtonPushed, true);
            app.DisplaytheCorrectionMapButton.FontSize = 9;
            app.DisplaytheCorrectionMapButton.FontWeight = 'bold';
            app.DisplaytheCorrectionMapButton.Layout.Row = 2;
            app.DisplaytheCorrectionMapButton.Layout.Column = [12 13];
            app.DisplaytheCorrectionMapButton.Text = {'Display the'; 'Correction Map'};

            % Create ResolutionValuePxInput
            app.ResolutionValuePxInput = uieditfield(app.GridLayout3_2, 'text');
            app.ResolutionValuePxInput.HorizontalAlignment = 'center';
            app.ResolutionValuePxInput.Layout.Row = 2;
            app.ResolutionValuePxInput.Layout.Column = [7 8];
            app.ResolutionValuePxInput.Value = '20';

            % Create RespixelsLabel
            app.RespixelsLabel = uilabel(app.GridLayout3_2);
            app.RespixelsLabel.HorizontalAlignment = 'center';
            app.RespixelsLabel.FontSize = 9;
            app.RespixelsLabel.Layout.Row = 1;
            app.RespixelsLabel.Layout.Column = [7 8];
            app.RespixelsLabel.Text = 'Resolution (px)';

            % Create SaveCorrectionMapasaFileButton
            app.SaveCorrectionMapasaFileButton = uibutton(app.GridLayout3_2, 'push');
            app.SaveCorrectionMapasaFileButton.ButtonPushedFcn = createCallbackFcn(app, @SaveCorrectionMapasaFileButtonPushed, true);
            app.SaveCorrectionMapasaFileButton.FontSize = 9;
            app.SaveCorrectionMapasaFileButton.FontWeight = 'bold';
            app.SaveCorrectionMapasaFileButton.Layout.Row = 2;
            app.SaveCorrectionMapasaFileButton.Layout.Column = [10 11];
            app.SaveCorrectionMapasaFileButton.Text = {'Save Correction '; 'Map as a File'};

            % Create Image2
            app.Image2 = uiimage(app.GridLayout);
            app.Image2.Layout.Row = [19 21];
            app.Image2.Layout.Column = [17 19];
            app.Image2.ImageSource = 'Arrow.png';

            % Create AutoContrast_Button
            app.AutoContrast_Button = uibutton(app.GridLayout, 'push');
            app.AutoContrast_Button.ButtonPushedFcn = createCallbackFcn(app, @AutoContrast_ButtonPushed, true);
            app.AutoContrast_Button.Icon = 'XXX_magic-wand.png';
            app.AutoContrast_Button.Layout.Row = 18;
            app.AutoContrast_Button.Layout.Column = 18;
            app.AutoContrast_Button.Text = '';

            % Create MaxEditField
            app.MaxEditField = uieditfield(app.GridLayout, 'numeric');
            app.MaxEditField.ValueChangedFcn = createCallbackFcn(app, @MaxEditFieldValueChanged, true);
            app.MaxEditField.HorizontalAlignment = 'center';
            app.MaxEditField.Layout.Row = 23;
            app.MaxEditField.Layout.Column = [18 19];

            % Create MinEditField
            app.MinEditField = uieditfield(app.GridLayout, 'numeric');
            app.MinEditField.ValueChangedFcn = createCallbackFcn(app, @MinEditFieldValueChanged, true);
            app.MinEditField.HorizontalAlignment = 'center';
            app.MinEditField.Layout.Row = 22;
            app.MinEditField.Layout.Column = [17 18];

            % Create MinLabel
            app.MinLabel = uilabel(app.GridLayout);
            app.MinLabel.FontSize = 11;
            app.MinLabel.FontAngle = 'italic';
            app.MinLabel.Layout.Row = 22;
            app.MinLabel.Layout.Column = [19 20];
            app.MinLabel.Text = 'Min';

            % Create MaxLabel
            app.MaxLabel = uilabel(app.GridLayout);
            app.MaxLabel.HorizontalAlignment = 'right';
            app.MaxLabel.FontSize = 11;
            app.MaxLabel.FontAngle = 'italic';
            app.MaxLabel.Layout.Row = 23;
            app.MaxLabel.Layout.Column = [16 17];
            app.MaxLabel.Text = 'Max';

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            app.UIAxes.PlotBoxAspectRatio = [1.78723404255319 1 1];
            app.UIAxes.XTick = [];
            app.UIAxes.YTick = [];
            app.UIAxes.FontSize = 9;
            app.UIAxes.Box = 'on';
            app.UIAxes.Layout.Row = [16 24];
            app.UIAxes.Layout.Column = [1 15];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.GridLayout);
            app.UIAxes2.PlotBoxAspectRatio = [1.78723404255319 1 1];
            app.UIAxes2.XTick = [];
            app.UIAxes2.YTick = [];
            app.UIAxes2.FontSize = 9;
            app.UIAxes2.Box = 'on';
            app.UIAxes2.Layout.Row = [16 24];
            app.UIAxes2.Layout.Column = [21 35];

            % Create UIAxes3
            app.UIAxes3 = uiaxes(app.GridLayout);
            app.UIAxes3.PlotBoxAspectRatio = [4.43522267206478 1 1];
            app.UIAxes3.FontSize = 9;
            app.UIAxes3.Layout.Row = [7 15];
            app.UIAxes3.Layout.Column = [1 35];

            % Show the figure after all components are created
            app.DriftCorrectorGUI.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = DriftCorrector_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.DriftCorrectorGUI)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.DriftCorrectorGUI)
        end
    end
end