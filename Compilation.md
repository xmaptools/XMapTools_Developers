# Deployment of a new release of XMapTools on MacOS or WINDOWS

__Last update 07.10.2023 (PL)__


- Run the program RESET_CONFIG
- Run install_XMapTools_MATLAB.m if you work from a new directory (recommended)
- Run CleanDirectory.m to perform the pre-compilation cleaning tasks
- Open the App Designer (open XMapTools or start XMapTools)
- Change hardcoded version in the startup function
- Save the project (to update code version)
- Click Share > Standalone

- Select the splash screen
- Select the icon EVEN if it appears already

- Update the text of the description: 

```
Release 4.3 includes new features and updates to XMapTools as well as stability and compatibility improvements. This update is strongly recommended for all users.

Release notes:
- Add new features for LA-ICPMS data reduction following Markmann et al. (2024)
- Improve classification, data visualisation and sampling
- Include several additional bug fixes

Find out more at https://xmaptools.ch/release-4-3/


Release 4.2 includes new features and updates to XMapTools and Bingo-Antidote, as well as stability and compatibility improvements. This update is highly recommended for all users.

Release notes:
- Add a new colour scheme "XMapTools Colour Palette for Minerals"
- Add a new colour editor module
- Add Bingo-Antidote 2.1
- Include several additional bug fixes

Find out more at https://xmaptools.ch/release-4-2/


Release 4.1 includes new functionalities and updates to XMapTools and improvements to stability and compatibility. 

Release notes:
- Add multi-standard calibration for LA-ICPMS data
- Add new features for classification and estimation of mineral modes
- Add a demo version of Bingo-Antidote 2.0
- Improve the Data Visualisation Module
- Additional bug fixes

Find out more at https://xmaptools.ch/release-4-1/


XMapTools 4 updates the core experience of XMapTools with a redesigned interface, the addition of machine learning algorithms for classification and new tools for data calibration and vizualisation.

Release notes (XMapTools 4 beta 4 – October 2022)
- Improvements of compatibility, stability and overall performences 
- Add a new classification tool to create sub-masks (test)
- First test of deployement for a developer version of the new Bingo-Antidote
- Additional bug fixes

Find out more at https://github.com/xmaptools/XMapTools_Developers/blob/main/Changelog.md
```
 
- In additional installer options, select the custom logo for installation
- On macOS, add the following message: 

```
--
  
Remember that you need to update permissions on macOS before to run XMapTools: https://resources.xmaptools.ch/installation-macos/
Open a terminal and type in: chmod -R 755 /Applications/XMapTools/
```

- Select Runtime downloaded from web and change name to XMapToolsInstaller_macOS_Intel or XMapToolsInstaller_macOS_AppleSilicon or XMapToolsInstaller_WIN

- Add the folder "Program" to the files required for your application to run and wait until it updates the display

- Add the License file to the package

- Click "Package"

- If this is a public version, update the version online!  
