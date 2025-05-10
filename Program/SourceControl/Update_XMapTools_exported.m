classdef Update_XMapTools_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        Update_XMapTools_GUI   matlab.ui.Figure
        GridLayout             matlab.ui.container.GridLayout
        Image                  matlab.ui.control.Image
        AnewreleaseofXMapToolsisavailableLabel  matlab.ui.control.Label
        Copyright              matlab.ui.control.Label
        EditField              matlab.ui.control.EditField
        CopythecodebelowLabel  matlab.ui.control.Label
        CopyCodeButton         matlab.ui.control.Button
        PressCloseopenaterminalandpastethecodeLabel  matlab.ui.control.Label
        AbortandresumeusingXMapToolnotrecommendedButton  matlab.ui.control.Button
        CloseButton            matlab.ui.control.Button
        UpgradenowtoXXXLabel   matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, XMapToolsapp)
            
            % XMapTools is a free software solution for the analysis of chemical maps
            % Copyright © 2022-2025 University of Lausanne, Institute of Earth Sciences, Pierre Lanari
            
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
            
            
            app.Update_XMapTools_GUI.Visible = 'off';
            
            app.AnewreleaseofXMapToolsisavailableLabel.Text = XMapToolsapp.XMapTools_version.Text;
            
            movegui(app.Update_XMapTools_GUI,'center');
            
            app.Update_XMapTools_GUI.Visible = 'on';
        end

        % Button pushed function: CopyCodeButton
        function CopyCodeButtonPushed(app, event)
            
        end

        % Button pushed function: CloseButton
        function CloseButtonPushed(app, event)
            
        end

        % Button pushed function: 
        % AbortandresumeusingXMapToolnotrecommendedButton
        function AbortandresumeusingXMapToolnotrecommendedButtonPushed(app, event)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create Update_XMapTools_GUI and hide until all components are created
            app.Update_XMapTools_GUI = uifigure('Visible', 'off');
            app.Update_XMapTools_GUI.Position = [100 100 778 549];
            app.Update_XMapTools_GUI.Name = 'About – XMapTools';
            app.Update_XMapTools_GUI.Icon = 'xmaptools_ios_icon_HR.png';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.Update_XMapTools_GUI);
            app.GridLayout.ColumnWidth = {'0.1x', '0.5x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '0.5x', '0.1x'};
            app.GridLayout.RowHeight = {'0.1x', '1x', '1x', '0.5x', '1x', '1x', '0.5x', '1x', '1x', '1x', '1x', '1x', '1x', '0.1x'};

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.Layout.Row = [2 3];
            app.Image.Layout.Column = [2 7];
            app.Image.ImageSource = 'logo_xmap_final.png';

            % Create AnewreleaseofXMapToolsisavailableLabel
            app.AnewreleaseofXMapToolsisavailableLabel = uilabel(app.GridLayout);
            app.AnewreleaseofXMapToolsisavailableLabel.HorizontalAlignment = 'center';
            app.AnewreleaseofXMapToolsisavailableLabel.FontSize = 18;
            app.AnewreleaseofXMapToolsisavailableLabel.Layout.Row = 2;
            app.AnewreleaseofXMapToolsisavailableLabel.Layout.Column = [8 14];
            app.AnewreleaseofXMapToolsisavailableLabel.Text = 'A new release of XMapTools is available!';

            % Create Copyright
            app.Copyright = uilabel(app.GridLayout);
            app.Copyright.HorizontalAlignment = 'center';
            app.Copyright.VerticalAlignment = 'bottom';
            app.Copyright.FontAngle = 'italic';
            app.Copyright.Layout.Row = 13;
            app.Copyright.Layout.Column = [2 14];
            app.Copyright.Text = '© 2021-2025, University of Lausanne, Institute of Earth Sciences, Pierre Lanari';

            % Create EditField
            app.EditField = uieditfield(app.GridLayout, 'text');
            app.EditField.Editable = 'off';
            app.EditField.HorizontalAlignment = 'center';
            app.EditField.FontSize = 14;
            app.EditField.Layout.Row = 6;
            app.EditField.Layout.Column = [3 11];
            app.EditField.Value = 'curl -fsSL https://xmaptools.ch/update.sh | bash';

            % Create CopythecodebelowLabel
            app.CopythecodebelowLabel = uilabel(app.GridLayout);
            app.CopythecodebelowLabel.FontSize = 16;
            app.CopythecodebelowLabel.FontWeight = 'bold';
            app.CopythecodebelowLabel.Layout.Row = 5;
            app.CopythecodebelowLabel.Layout.Column = [3 11];
            app.CopythecodebelowLabel.Text = 'Copy the code below';

            % Create CopyCodeButton
            app.CopyCodeButton = uibutton(app.GridLayout, 'push');
            app.CopyCodeButton.ButtonPushedFcn = createCallbackFcn(app, @CopyCodeButtonPushed, true);
            app.CopyCodeButton.FontSize = 15;
            app.CopyCodeButton.FontWeight = 'bold';
            app.CopyCodeButton.Layout.Row = 6;
            app.CopyCodeButton.Layout.Column = [12 13];
            app.CopyCodeButton.Text = 'Copy Code';

            % Create PressCloseopenaterminalandpastethecodeLabel
            app.PressCloseopenaterminalandpastethecodeLabel = uilabel(app.GridLayout);
            app.PressCloseopenaterminalandpastethecodeLabel.FontSize = 16;
            app.PressCloseopenaterminalandpastethecodeLabel.FontWeight = 'bold';
            app.PressCloseopenaterminalandpastethecodeLabel.Layout.Row = 8;
            app.PressCloseopenaterminalandpastethecodeLabel.Layout.Column = [3 11];
            app.PressCloseopenaterminalandpastethecodeLabel.Text = 'Press Close, open a terminal, and paste the code';

            % Create AbortandresumeusingXMapToolnotrecommendedButton
            app.AbortandresumeusingXMapToolnotrecommendedButton = uibutton(app.GridLayout, 'push');
            app.AbortandresumeusingXMapToolnotrecommendedButton.ButtonPushedFcn = createCallbackFcn(app, @AbortandresumeusingXMapToolnotrecommendedButtonPushed, true);
            app.AbortandresumeusingXMapToolnotrecommendedButton.FontSize = 16;
            app.AbortandresumeusingXMapToolnotrecommendedButton.FontWeight = 'bold';
            app.AbortandresumeusingXMapToolnotrecommendedButton.Layout.Row = 11;
            app.AbortandresumeusingXMapToolnotrecommendedButton.Layout.Column = [3 13];
            app.AbortandresumeusingXMapToolnotrecommendedButton.Text = 'Abort and resume using XMapTool (not recommended)';

            % Create CloseButton
            app.CloseButton = uibutton(app.GridLayout, 'push');
            app.CloseButton.ButtonPushedFcn = createCallbackFcn(app, @CloseButtonPushed, true);
            app.CloseButton.FontSize = 15;
            app.CloseButton.FontWeight = 'bold';
            app.CloseButton.Layout.Row = 8;
            app.CloseButton.Layout.Column = [12 13];
            app.CloseButton.Text = 'Close';

            % Create UpgradenowtoXXXLabel
            app.UpgradenowtoXXXLabel = uilabel(app.GridLayout);
            app.UpgradenowtoXXXLabel.HorizontalAlignment = 'center';
            app.UpgradenowtoXXXLabel.FontSize = 14;
            app.UpgradenowtoXXXLabel.FontAngle = 'italic';
            app.UpgradenowtoXXXLabel.Layout.Row = 3;
            app.UpgradenowtoXXXLabel.Layout.Column = [8 14];
            app.UpgradenowtoXXXLabel.Text = 'Upgrade now to XXX';

            % Show the figure after all components are created
            app.Update_XMapTools_GUI.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Update_XMapTools_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.Update_XMapTools_GUI)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.Update_XMapTools_GUI)
        end
    end
end