# Deployment of a new release of XMapTools on MacOS with MATLAB 2025a. Note that the deployment tool has changed from previous versions.

__Last update 07.02.2026 (Pierre Lanari)__

- Copy the Program/ folder into a compilation folder.
- Run RESET_CONFIG.
- Run Install_XMapTools_MATLAB.
- Run CleanDirectory to perform pre-compile cleanup tasks (compatibility not tested with this release).
- Open the App Designer (open XMapTools or start XMapTools); the code will automatically be updated to the MATLAB version.

- Change the hardcoded version in the startup function.
- Change the version in the Sharing Details of the main XMapTools object. 
- Save the project to update the version and code.

- Click "Share" > "Standalone Desktop App". 
- Select "Share using a project" in "Manage App Sharing with a MATLAB Project".
- Edit the name to "XMapTools" and click Ok.

- In the the main MATLAB window and the Project tab, click on "Compiler Task Manager" and select the task by clicking in XMapTools Standalone Application. 
- Add the following folders manually from the project browser using right-click 'Add Folder to Project (Including Contents)' and adding a label to the files using: Add Label > Additional File: 
  - Program/Addons/BingoAntidote/Databases/ [note: add Additional File label to database files]
  - Program/Addons/BingoAntidote/Dev/
  - Program/Core/
  - Program/Dev/Data_Std_LAICPMS/ [note: add Additional File label to standard files]
  - Program/Dev/help [note: add Additional File label to the help files]
  - Program/Dev/help/img [note: add Additional File label to the image files]
  
- Remove the label "artefact" to the html help files and add the label "Additional File".
  
- Select the icon

- In installer details at the bottom: 
  - Select "Fetch MATLAB Runtime" option
  - Change the name of the installer to (note that the version is not mentionned here but in the zip file below):
    - XMapToolsInstaller_macOS
    - XMapToolsInstaller_Windows. 
  - Select the splash screen
  - Select the icon
  - Select the Sidebar Image

- Click "Build and Package"

- Zip the installer for macOS using: 
```
ditto -c -k --sequesterRsrc --keepParent "XMapToolsInstaller_macOS.app" "XMapToolsInstaller_macOS_AppleSilicon.zip"
```
```
ditto -c -k --sequesterRsrc --keepParent "XMapToolsInstaller_macOS.app" "XMapToolsInstaller_macOS_Intel.zip"
```
```
ditto -c -k --sequesterRsrc --keepParent "XMapToolsInstaller_macOS.app" "XMapToolsInstaller_macOS_Rosetta.zip"
```
```
ditto -c -k --sequesterRsrc --keepParent "XMapTools.app" "XMapTools_macOS_AppleSilicon.zip"
```
- If this is a public version, update the version online!  
