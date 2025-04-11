classdef Signal_Selector_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        SignalSelectorGUI         matlab.ui.Figure
        GridLayout                matlab.ui.container.GridLayout
        Tree                      matlab.ui.container.Tree
        Image                     matlab.ui.control.Image
        ManualselectionPanel      matlab.ui.container.Panel
        GridLayout2               matlab.ui.container.GridLayout
        SelecttimeintervalButton  matlab.ui.control.Button
        NameEditFieldLabel        matlab.ui.control.Label
        NameEditField             matlab.ui.control.EditField
        StartEditFieldLabel       matlab.ui.control.Label
        StartEditField            matlab.ui.control.NumericEditField
        EndEditFieldLabel         matlab.ui.control.Label
        EndEditField              matlab.ui.control.NumericEditField
        ADDButton                 matlab.ui.control.Button
        AutomatedselectionPanel   matlab.ui.container.Panel
        GridLayout3               matlab.ui.container.GridLayout
        DeleteButton              matlab.ui.control.Button
        UIAxes                    matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        CallingApp
        Data
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, CallingApp, Data, Mode, DefNameText)
            
            app.SignalSelectorGUI.Visible = 'off';
            
            movegui(app.SignalSelectorGUI,"center");
            
            app.CallingApp = CallingApp;
            app.Data = Data;
            
            switch Mode
                case 'Auto'
                    app.ManualselectionPanel.Visible = 'off';
                    app.AutomatedselectionPanel.Visible = 'off';
                case 'Manual'
                    app.ManualselectionPanel.Visible = 'on';
                    app.AutomatedselectionPanel.Visible = 'on';
            end
            
            app.NameEditField.Value = DefNameText;
            
            plot(app.UIAxes,Data,'-k');
            
            app.UIAxes.YScale = 'log';
            rp = rulerPanInteraction('Dimensions','x');
            app.UIAxes.Interactions = [rp];
            tb = axtoolbar(app.UIAxes,{'export','pan','zoomin','zoomout','restoreview'});
            
            app.SignalSelectorGUI.Visible = 'on';

        end

        % Button pushed function: SelecttimeintervalButton
        function SelecttimeintervalButtonPushed(app, event)
            
            
            
            
            
            keyboard
            
        end

        % Button pushed function: DeleteButton
        function DeleteButtonPushed(app, event)
            
        end

        % Button pushed function: ADDButton
        function ADDButtonPushed(app, event)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create SignalSelectorGUI and hide until all components are created
            app.SignalSelectorGUI = uifigure('Visible', 'off');
            app.SignalSelectorGUI.Position = [100 100 1258 616];
            app.SignalSelectorGUI.Name = 'Signal Selector – XMapTools';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.SignalSelectorGUI);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout.ColumnSpacing = 5;
            app.GridLayout.RowSpacing = 5;

            % Create Tree
            app.Tree = uitree(app.GridLayout);
            app.Tree.Layout.Row = [5 18];
            app.Tree.Layout.Column = [1 5];

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.Layout.Row = [1 2];
            app.Image.Layout.Column = [1 9];
            app.Image.ImageSource = 'logo_xmap_final.png';

            % Create ManualselectionPanel
            app.ManualselectionPanel = uipanel(app.GridLayout);
            app.ManualselectionPanel.TitlePosition = 'centertop';
            app.ManualselectionPanel.Title = 'Manual selection';
            app.ManualselectionPanel.Layout.Row = [1 4];
            app.ManualselectionPanel.Layout.Column = [11 23];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.ManualselectionPanel);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout2.ColumnSpacing = 5;
            app.GridLayout2.RowSpacing = 5;
            app.GridLayout2.Padding = [5 5 5 5];

            % Create SelecttimeintervalButton
            app.SelecttimeintervalButton = uibutton(app.GridLayout2, 'push');
            app.SelecttimeintervalButton.ButtonPushedFcn = createCallbackFcn(app, @SelecttimeintervalButtonPushed, true);
            app.SelecttimeintervalButton.Icon = 'XXX_ExportMap.png';
            app.SelecttimeintervalButton.Layout.Row = 2;
            app.SelecttimeintervalButton.Layout.Column = [1 6];
            app.SelecttimeintervalButton.Text = 'Select time interval';

            % Create NameEditFieldLabel
            app.NameEditFieldLabel = uilabel(app.GridLayout2);
            app.NameEditFieldLabel.HorizontalAlignment = 'right';
            app.NameEditFieldLabel.FontSize = 11;
            app.NameEditFieldLabel.Layout.Row = 1;
            app.NameEditFieldLabel.Layout.Column = [1 2];
            app.NameEditFieldLabel.Text = 'Name';

            % Create NameEditField
            app.NameEditField = uieditfield(app.GridLayout2, 'text');
            app.NameEditField.HorizontalAlignment = 'center';
            app.NameEditField.Layout.Row = 1;
            app.NameEditField.Layout.Column = [3 6];
            app.NameEditField.Value = 'Background';

            % Create StartEditFieldLabel
            app.StartEditFieldLabel = uilabel(app.GridLayout2);
            app.StartEditFieldLabel.HorizontalAlignment = 'right';
            app.StartEditFieldLabel.FontSize = 11;
            app.StartEditFieldLabel.Layout.Row = 3;
            app.StartEditFieldLabel.Layout.Column = 1;
            app.StartEditFieldLabel.Text = 'Start';

            % Create StartEditField
            app.StartEditField = uieditfield(app.GridLayout2, 'numeric');
            app.StartEditField.HorizontalAlignment = 'center';
            app.StartEditField.FontSize = 11;
            app.StartEditField.Layout.Row = 3;
            app.StartEditField.Layout.Column = [2 3];

            % Create EndEditFieldLabel
            app.EndEditFieldLabel = uilabel(app.GridLayout2);
            app.EndEditFieldLabel.HorizontalAlignment = 'right';
            app.EndEditFieldLabel.FontSize = 11;
            app.EndEditFieldLabel.Layout.Row = 3;
            app.EndEditFieldLabel.Layout.Column = 4;
            app.EndEditFieldLabel.Text = 'End';

            % Create EndEditField
            app.EndEditField = uieditfield(app.GridLayout2, 'numeric');
            app.EndEditField.HorizontalAlignment = 'center';
            app.EndEditField.Layout.Row = 3;
            app.EndEditField.Layout.Column = [5 6];

            % Create ADDButton
            app.ADDButton = uibutton(app.GridLayout2, 'push');
            app.ADDButton.ButtonPushedFcn = createCallbackFcn(app, @ADDButtonPushed, true);
            app.ADDButton.Icon = '056-plus.png';
            app.ADDButton.Layout.Row = 2;
            app.ADDButton.Layout.Column = [9 11];
            app.ADDButton.Text = 'ADD';

            % Create AutomatedselectionPanel
            app.AutomatedselectionPanel = uipanel(app.GridLayout);
            app.AutomatedselectionPanel.TitlePosition = 'centertop';
            app.AutomatedselectionPanel.Title = 'Automated selection';
            app.AutomatedselectionPanel.Layout.Row = [1 4];
            app.AutomatedselectionPanel.Layout.Column = [24 36];

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.AutomatedselectionPanel);
            app.GridLayout3.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout3.RowHeight = {'1x', '1x', '1x'};
            app.GridLayout3.ColumnSpacing = 5;
            app.GridLayout3.RowSpacing = 5;
            app.GridLayout3.Padding = [5 5 5 5];

            % Create DeleteButton
            app.DeleteButton = uibutton(app.GridLayout, 'push');
            app.DeleteButton.ButtonPushedFcn = createCallbackFcn(app, @DeleteButtonPushed, true);
            app.DeleteButton.Icon = '057-minus.png';
            app.DeleteButton.Layout.Row = 4;
            app.DeleteButton.Layout.Column = [1 3];
            app.DeleteButton.Text = 'Delete';

            % Create UIAxes
            app.UIAxes = uiaxes(app.GridLayout);
            xlabel(app.UIAxes, 'Sweep')
            ylabel(app.UIAxes, 'Intensity')
            app.UIAxes.XTick = [0 1];
            app.UIAxes.YTick = [0 1];
            app.UIAxes.FontSize = 9;
            app.UIAxes.Layout.Row = [6 18];
            app.UIAxes.Layout.Column = [6 36];

            % Show the figure after all components are created
            app.SignalSelectorGUI.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Signal_Selector_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.SignalSelectorGUI)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.SignalSelectorGUI)
        end
    end
end