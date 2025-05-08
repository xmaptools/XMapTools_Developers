# Deployment of a new release of XMapTools on MacOS with MATLAB 2025a

__Last update 05.05.2025 (Pierre Lanari)__


- Run the program RESET_CONFIG.
- Run Install_XMapTools_MATLAB.m if you work from a new directory (recommended).
- Run CleanDirectory.m to perform the pre-compilation cleaning tasks.
- Open the App Designer (open XMapTools or start XMapTools); the code will automatically be updated to the MATLAB version.

- Change hardcoded version in the startup function.
- Save the project (to update code version).

- Click "Share" > "Standalone Desktop App" 
- Add the Splash Screen and the Icon
- Add the Program folder to "Files required for the app to run"
- Select "Share using a project" in "Manage App Sharing with a MATLAB Project".
- Edit the name to "XMapTools" and click Ok.

- In the the main MATLAB window and the Project tab, click on "Compiler Task Manager" and select the task. 
- Add the following folders manually: 
  - BingoAntidote/Databases/
  - Dev/Data_Std_LAICPMS/
  - Dev/help
  - Dev/help/img
  
- Select "Fetch MATLAB Runtime" option and change the name to XMapToolsInstaller_macOS_Intel or XMapToolsInstaller_macOS_AppleSilicon_2025 or XMapToolsInstaller_WIN  

- Update the Installer Notes: 
```
#### THIS IS A BETA VERSION OF XMAPTOOLS: Some features will only be available in the public release ####

Find out more at https://github.com/xmaptools/XMapTools_Developers/blob/main/Changelog.md
```
```
--
  
Remember that you need to update permissions on macOS before to run XMapTools: https://resources.xmaptools.ch/installation-macos/
Open a terminal and type in: chmod -R 755 /Applications/XMapTools/
```  
  
- Select the splash screen
- Select the icon
- Select the Sidebar Image

- Click "Build and Package"

- If this is a public version, update the version online!  
