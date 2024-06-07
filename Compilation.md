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
#### THIS IS A BETA VERSION OF XMAPTOOLS: Some features will only be available in the public release ####

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
