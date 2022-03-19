![XMapTools_Github_developer](https://user-images.githubusercontent.com/54409312/152673005-7bb96f00-b365-427c-9964-17820e6edb73.jpg)

# Welcome to the Developer Repository for XMapTools 4

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/xmaptools/XMapTools_Developers/graphs/commit-activity)
[![Website xmaptools.ch](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://xmaptools.ch)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](#)

This repository contains the most recent version of the MATLAB source code of XMapTools not released in a public version yet. All changes compared to the current public version are listed in the <a href="https://github.com/xmaptools/XMapTools_Developers/blob/main/Changelog.md">Changelog</a>. 

XMapTools official website: https://xmaptools.ch

Documentation (work in progress): https://resources.xmaptools.ch  

Public repository: https://github.com/xmaptools/XMapTools_Public 

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

## How to join the developer team?

Contact pierre.lanari@geo.unibe.ch

## How to get started
You can pull the current developer version of XMapTools from this directory using the main branch. As changes are not all pushed at the same time, some functionalities of the git version could not work due to compatibility issues. Check the <a href="https://github.com/xmaptools/XMapTools_Public">public repository</a> if you are looking for a stable version of XMapTools. 

### Requirements
- MATLAB R2020b with the Statistics Toolbox, Image Processing Toolbox, Mapping Toolbox. Compatibility with more recent version of MATLAB is not checked. 
- For compatibility reasons, you must use MATLAB R2020b if you wish to share modifications made with the MATLAB App Designer. 

### Warnings
- Never overwrite the main branch if you're not invited to do so; create your own branch if you want to push changes to the server!  
- We recommend you to copy the files to a separate folder and to work there in order to avoid any modification of the main branch. 

### Installation/Update and first steps
- Pull the current developer version of XMapTools from this directory using the main branch
- Copy the files to the setup directory (a different folder from the GIT)
- Install MATLAB 2020b; it is recommended to use MATLAB 2020b if you want to change the code of XMapTools via the app designer
- Open MATLAB and navigate to the setup directory
- Type in the MATLAB Command Window >> install_MATLAB
- Type in the MATLAB Command Window >> RESET_CONFIG
- Change the Current Path in MATLAB to a directory containing data
- To launch XMapTools use the command: >> XMapTools
- To open the app designer, use the command: >> start XMapTools

