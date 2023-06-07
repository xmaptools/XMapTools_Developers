# Deployment of a new release of XMapTools on MacOS or WINDOWS

__Last update 07.06.2023 (PL)__



- Run the program RESET_CONFIG
- Run install_XMapTools_MATLAB.m if you work from a new directory

- Delete XMapTools.prj
- Delete the folder of the previous package "/XMapTools"

- Open the App Designer (open XMapTools or start XMapTools)
- Change hardcoded version in the startup function 
- Click Share > Standalone

- Select the splash screen
- Select the icon EVEN if it appears already

- Update the text of the description: 

```
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
 
- In additional installer options, select the custom logo for installation + on macOS the following message: 

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