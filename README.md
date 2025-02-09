![XMapTools_Github_developer](https://user-images.githubusercontent.com/54409312/152673005-7bb96f00-b365-427c-9964-17820e6edb73.jpg)

# Welcome to the Developer Repository for XMapTools 4

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/xmaptools/XMapTools_Developers/graphs/commit-activity)
[![Website xmaptools.ch](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](https://xmaptools.ch)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](#)

This repository contains the most recent version of the MATLAB source code of XMapTools not released in a public version yet. All changes compared to the current public version are listed in the <a href="https://github.com/xmaptools/XMapTools_Developers/blob/main/Changelog.md">Changelog</a>. 

XMapTools official website: https://xmaptools.ch

Documentation (work in progress): https://resources.xmaptools.ch  

Public repository: https://github.com/xmaptools/XMapTools_Public 

<a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html"><img alt="GNU-GPLv3" style="border-width:0" src="https://www.gnu.org/graphics/agplv3-with-text-162x68.png" /></a><br />This work is licensed under a <a rel="license" href="https://www.gnu.org/licenses/gpl-3.0.en.html">GPL-3.0 license</a>.

<a href="https://ec.europa.eu/info/research-and-innovation/funding/funding-opportunities/funding-programmes-and-open-calls/horizon-europe_en" target="_blank"><img src="https://user-images.githubusercontent.com/54409312/168419191-401f1d2c-014f-4640-9edc-cfa6f3832a40.png" height="70"/></a>


## How to join the developer team?

Contact pierre.lanari@unil.ch

## How to get started
You can download or fetch the current development version of XMapTools from this directory using the main branch. Since changes are not all committed at the same time, some features of the git version may not work due to compatibility issues. Check the <a href="https://github.com/xmaptools/XMapTools_Public">public repository</a> if you are looking for a stable version of XMapTools. 

### Requirements
- MATLAB R2020b with the Statistics Toolbox, Image Processing Toolbox, Mapping Toolbox (since 4.1), and Deep Learning Toolbox (since 4.4). Compatibility with later versions of MATLAB is not guaranteed, but XMapTools developer seems to behave well in MATLAB 2025a.
- You must use the base version of MATLAB (currently MATLAB R2020b) if you want to share changes made to MLAPP files with the MATLAB App Designer. Note that this is not necessary for editing MATLAB code files (.m), which can be done with more recent versions of MATLAB. 
- For compatibility reasons, and because MLAPP files are binary files and code changes cannot be tracked by GitHub, it is important to export the MLAPP file to a MATLAB code file (.m) in the SourceControl folder so that changes to MLAPP files can be tracked.
 

### Warnings
- Never overwrite the main branch if you're not invited to do so but create a pull request; create your own branch if you want to push changes to the server!  
- We recommend you to copy the files to a separate folder and to work there in order to avoid any modification of the main branch. 

### Installation/Update and first steps
- Pull the current developer version of XMapTools from this directory using one of the active branch
- Copy the files to your XMapTools setup directory (a different folder from the GIT: e.g. Documents/XMapTools4/)
- Install MATLAB 2020b and the required toolboxes (see above); it is recommended to use MATLAB 2020b if you want to change the code of XMapTools via the app designer (older versions won't work, newest versions might cause troubles)
- Open MATLAB and navigate to your setup directory
- Type in the MATLAB Command Window >> install_MATLAB
- Type in the MATLAB Command Window >> RESET_CONFIG
- Change the Current Path in MATLAB to a directory containing data
- To launch XMapTools use the command: >> XMapTools
- To open the app designer, use the command: >> start XMapTools

