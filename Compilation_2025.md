# Deployment of a new release of XMapTools on MacOS with MATLAB 2025a. Note that the deployment tool has changed from previous versions.

__Last update 09.05.2025 (Pierre Lanari)__

- Copy the XMapTools files into a compilation folder.
- Run RESET_CONFIG.
- Run Install_XMapTools_MATLAB.
- Run CleanDirectory to perform pre-compile cleanup tasks (compatibility not tested with this release).
- Open the App Designer (open XMapTools or start XMapTools); the code will automatically be updated to the MATLAB version.

- Change the hardcoded version in the startup function.
- Save the project to update the version and code.

- Click "Share" > "Standalone Desktop App". 
- Add the Splash Screen and the Icon.
- Add the Program folder to "Files required for the app to run" (apparently not really useful).
- Select "Share using a project" in "Manage App Sharing with a MATLAB Project".
- Edit the name to "XMapTools" and click Ok.

- In the the main MATLAB window and the Project tab, click on "Compiler Task Manager" and select the task by clicking in XMapTools Standalone Application. 
- Add the following folders manually (important): 
  - Program/Addons/BingoAntidote/Databases/
  - Program/Addons/BingoAntidote/Dev/
  - Program/Core/
  - Program/Dev/Data_Std_LAICPMS/
  - Program/Dev/help
  - Program/Dev/help/img
  
- Select "Fetch MATLAB Runtime" option and change the name to XMapToolsInstaller_macOS_Intel or XMapToolsInstaller_macOS_AppleSilicon_2025 or XMapToolsInstaller_WIN.  

- Update the Installer Notes: 
```
#### THIS IS A BETA VERSION OF XMAPTOOLS: Some features will only be available in the public release ####

Find out more at https://github.com/xmaptools/XMapTools_Developers/blob/main/Changelog.md
```
  
- Select the splash screen
- Select the icon
- Select the Sidebar Image

- Click "Build and Package"

- If this is a public version, update the version online!  
