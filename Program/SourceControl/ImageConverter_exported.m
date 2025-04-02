classdef ImageConverter_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ImageConverterGUI  matlab.ui.Figure
        GridLayout         matlab.ui.container.GridLayout
        Image              matlab.ui.control.Image
        Image2             matlab.ui.control.Image
        Image2_2           matlab.ui.control.Image
        Image2_3           matlab.ui.control.Image
        Panel              matlab.ui.container.Panel
        GridLayout2        matlab.ui.container.GridLayout
        Label              matlab.ui.control.Label
        Image2_4           matlab.ui.control.Image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, XMapToolsApp)
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ImageConverterGUI and hide until all components are created
            app.ImageConverterGUI = uifigure('Visible', 'off');
            app.ImageConverterGUI.Position = [100 100 967 561];
            app.ImageConverterGUI.Name = 'Image Converter – XMapTools';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.ImageConverterGUI);
            app.GridLayout.ColumnWidth = {'0.5x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '0.5x'};
            app.GridLayout.RowHeight = {'0.1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '0.2x'};

            % Create Image
            app.Image = uiimage(app.GridLayout);
            app.Image.Layout.Row = [2 3];
            app.Image.Layout.Column = [2 9];
            app.Image.ImageSource = 'logo_xmap_final.png';

            % Create Image2
            app.Image2 = uiimage(app.GridLayout);
            app.Image2.Layout.Row = [2 3];
            app.Image2.Layout.Column = [17 18];
            app.Image2.ImageSource = 'IMGConv_image.jpg';

            % Create Image2_2
            app.Image2_2 = uiimage(app.GridLayout);
            app.Image2_2.Layout.Row = [2 3];
            app.Image2_2.Layout.Column = 19;
            app.Image2_2.ImageSource = 'IMGConv_arrow.jpg';

            % Create Image2_3
            app.Image2_3 = uiimage(app.GridLayout);
            app.Image2_3.Layout.Row = [2 3];
            app.Image2_3.Layout.Column = [20 21];
            app.Image2_3.ImageSource = 'IMGConv_text.jpg';

            % Create Panel
            app.Panel = uipanel(app.GridLayout);
            app.Panel.Layout.Row = [2 3];
            app.Panel.Layout.Column = [11 15];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.Panel);
            app.GridLayout2.ColumnWidth = {'1x'};
            app.GridLayout2.RowHeight = {'1x'};
            app.GridLayout2.Padding = [5 5 5 5];

            % Create Label
            app.Label = uilabel(app.GridLayout2);
            app.Label.WordWrap = 'on';
            app.Label.FontSize = 9;
            app.Label.Layout.Row = 1;
            app.Label.Layout.Column = 1;
            app.Label.Text = 'ImageConverter is a module that converts images into numerical values. Load an image file (.bmp, .tif, .tiff, .png, .jpg, .jpeg), check the conversion and save your file to a text file.';

            % Create Image2_4
            app.Image2_4 = uiimage(app.GridLayout);
            app.Image2_4.Layout.Row = [8 9];
            app.Image2_4.Layout.Column = [11 12];
            app.Image2_4.ImageSource = 'IMGConv_arrow.jpg';

            % Show the figure after all components are created
            app.ImageConverterGUI.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageConverter_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ImageConverterGUI)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ImageConverterGUI)
        end
    end
end