# CHANGELOG for XMapTools developer


## XMapTools 4.2 RC (no build yet)

- General
  - Add a new colour scheme "XMapTools Colour Palette for Minerals" for plotting mask images that is automatically applied to new classifications. Unrecognised classes are displayed in black 
  - Add a new module "Mask Colour Editor" to edit the colours of the mask image. It is possible to (1) apply the new "XMapTools Colour Palette for Minerals, (2) edit individual colours using a colour picker, (3) apply any of the available colour palettes.
  - Add a menu option to save a result dataset to an hdf5 file available in Menu > Edit > Dataset > Export as hdf5
  - Add a menu option to update the element/oxide indexing for Quanti and Merged datasets, available in Menu > Edit > Dataset > Update Element/Oxide Indexing
  - Implement a stopwatch in the classification function; results are visible in the log file
  - Improve the sampling tools "Circle" and "Area (Polygon)" by exporting all data in a  file Data.txt when the "Multiple Map" option is used
  - Improve the converter module for EPMA by automatically reading the dwell time for JEOL data sets

- LA-ICP-MS: 
  - Add a new data category in the secondary tree menu for LOD data
  - Fix a problem that prevented the AcqMethod.xml file from being read.

- Bingo-Antidote 2.1
  - New GUIwith improved workflow and advanced tools
  - All recipes and previous functionalities have been implemented
  - Add an option to save and load a Bingo-Antidote project
  - Add an option to add new phase definitions using a file AddPhaseDefinitions.txt in the working directory
  - This version of Bingo-Antidote is fully compatible with the latest version of Theriak-Domino (available at https://github.com/Theriak-Domino/)
  - The following thermodynamic databases have been tested: JUN92.bs; td-ds55-HP1.txt; td-ds62-mp50-v05.txt 
  
- Other: 
  - Add a version tracking option in project files to make it easier to identify compatibility issues
  - Improve the scale bar and solve several display and location issues
  - Solve a major issue in the training set that prevented ROI from being added when more than one training set was created.
  - Solve an issue in the import module that prevented the imported quantitative maps expressed in oxide wt% from being used for structural formula calculations
  - Solve several minor issues in the the load function (1) when loading projects created with XMapTools 3 and (2) when the last mask file in the project was deleted
  - Fix a problem in the sampling function (circle and polygon) where zeros were included in the average calculation.
  - Fix a problem with the mask delete function
  - Fix a problem in the Structural Formula module for calculations with a fixed oxygen and number of cations.



## XMapTools 4.1 (build 230102)
Release 4.1 includes new functionalities and updates to XMapTools and improvements to stability and compatibility. 

- General
  - Add tools for single-mask classification and the creation of sub-masks. At the moment, it is recommended to use the Random Algorithm forest for creating sub-masks 
  - Add a point counting tool to evaluate pseudo-modes; XMapTools selects randomly pixels on the map and estimates the modal abundances (in %). A version with uncertainty estimation using Monte-Carlo can be activated
  - Add a functionality to calibrate pixels of a selection of masks for standardisation of EPMA data. Note that merged maps are only generated when the option "Apply to all maps" is selected.
  - Add entropic filters to the classification (TEXTF)
  - Add the old function to run XMapTools and open immediately a project in the MATLAB version using the command: _XMapTools open ProjectName_
  - Add a demo version of Bingo-Antidote 2.0 for test purposes
  - Improve stability of XMapTools when a ROI is drawn or edited

- LA-ICP-MS: 
  - Add a multi-standard calibration option which required several major changes in both the import tool and the calibration module for LA-ICPMS data. This update also includes several improvements and minor corrections. Compatibility with data generated using previous versions is not fully maintained 
  - Add an option to read the sweep time values for each element from an xml file. Note that the file name should be AcqMethod.xml.   
  - Improve performances for plotting and ROI interaction of the Spider module  

- Data Visualisation Module:
  - Improve the global performances of this module by implementing the low ressource mode to all plots. Only 20 % of the data points are plotted when this mode is active; this threshold can be adjusted in the option tab 
  - Add an option to select a range of data (using the fields Xmin and Xmax) when plotting an histogram
  - Add a plotting report generated while plotting a ternary diagram
  - Add an option to create a single-mask maskfile from he pixels selected by the Identify 
  - Add a dropdown menu to select a phase from a maskfile to plot only the pixel compositions of this phase
  - Add an option to avoid plotting zeros; this is important for the fitting tools
  - Fix several issue in the starting function that would prevent the module to open for special cases (e.g. less than 3 maps)

- Import tool:
  - Improve compatibility of the EPMA Converter to import data from JEOL microprobes (Windows)
  - Activate map re-sampling and orientation corrections to all data types in the import tools. This resolves an issue when LA-ICPMS data are imported from Iolite. It is not recommended to use these tools for other data types 

- Other:
  - Add an option to unfreeze the interface after an error by simply requesting to close the app. This  option does not require to have unsaved data as in previous versions
  - Add a checking function for the selected training set before classification
  - Add a mask file signature to ensure data compatibility throughout XMapTools and add-ons 
  - Improve interface behavior for button availability, tooltips and error messages
  - Improve GUI size for screens with low resolution
  -	Improve the plot behaviour of the main tree menu: if a category/dataset from Quanti, Merged, Result, Other, the first element in the list is automatically displayed
  - Export a file Last_LBCsim.txt in the main directory containing each local bulk compositions simulated by XMapTools for estimating the LBC uncertainty. 
  - Fix an issue in the classification function when part of the selected maps have been deleted
  - Fix a minor issue in the variable initialisation for mask files
  - Fix several minor issues in the Converter for LA-ICP-MS; reported by Nils Gies 
  - Fix several minor issues in the behaviour of ROI for training sets; reported by Nils Gies 
  - Fix an issue in the project loading function
  - Other minor bug and fixes




## XMapTools 4.1 Release Candidate (no public release yet)
- Release notes:
  - Improve stability of XMapTools when a ROI is drawn or edited
  - Add a multi-standard calibration option which required several major changes in both the import tool and the calibration module for LA-ICPMS data. This update also includes several improvements and minor corrections. Compatibility with data generated using previous versions is not fully maintained. 
  - Add an option to read the sweep time values for each element from an xml file. Note that the file name should be AcqMethod.xml.   
  - Improve performances for plotting and ROI interaction of the Spider module
- Data visualisation module:
  - Improve the global performances of this module by implementing the low ressource mode to all plots. Only 20 % of the data points are plotted when this mode is active; this threshold can be adjusted in the option tab 
  - Add an option to select a range of data (using the fields Xmin and Xmax) when plotting an histogram
  - Add a plotting report generated while plotting a ternary diagram
  - Add an option to create a single-mask maskfile from he pixels selected by the Identify Pixel Tool.  
- Other:
  - Fix an issue in the project loading function
  - Other minor bug and fixes



## XMapTools 4 beta 4 Developer (no public release yet)
- Release notes:
  - Add tools for single-mask classification and the creation of sub-masks. At the moment, it is recommended to use the Random Algorithm forest for creating sub-masks. 
  - Add a point counting tool to evaluate pseudo-modes; XMapTools selects randomly 300 pixels on the map and estimates the modal abundances (in %). A version with uncertainty estimation using Monte-Carlo can be activated in the developer version.
  - Add a functionality to calibrate pixels of a selection of masks for standardisation of EPMA data. Note that merged maps are only generated when the option "Apply to all maps" is selected.  
  - Add entropic filters to the classification (TEXTF)
  - Activate map re-sampling and orientation correction to all data types in the import tools. This resolves an issue when LA-ICPMS data are imported from Iolite. It is not recommended to use these tools for other data types. 
 - Improve compatibility of the EPMA Converter to import data from JEOL microprobes (Windows) 
- Other:
  - Improve interface behavior for button availability, tooltips and error messages
  - Add an option to unfreeze the interface after an error by simply requesting to close the app. This  option does not require to have unsaved data as in previous versions
  - Add a check of the selected training set before classification
  - Solve an issue in the classification function when part of the selected maps have been deleted
  - Solve a minor issue in the variable initialisation for mask files
  - GUI size adjusted for screens with low resolution
  - Add a mask file signature to ensure data compatibility throughout XMapTools and add-ons  


## XMapTools 4 beta 3 Developer (no public release yet)
- Release notes:
  - Add the old function to run XMapTools and open immediately a project in the MATLAB version using the command: _XMapTools open ProjectName_
  - ...
- Data Visualisation Module:
  - Add a dropdown menu to select a phase from a maskfile to plot only the pixel compositions of this phase
  - Add an option to avoid plotting zeros; this is important for the fitting tools
  - Fix several issue in the starting function that would prevent the module to open for special cases (e.g. less than 3 maps)
- Other:
  -	Improve the plot behaviour of the Tree menu: if a category/dataset from Quanti, Merged, Result, Other, the first element in the list is automatically displayed
  - Export a file Last_LBCsim.txt in the main directory containing each local bulk compositions simulated by XMapTools for estimating the LBC uncertainty. 
  - Fix several minor issues in the Converter for LA-ICP-MS; reported by Nils Gies 
  - Fix several minor issues in the behaviour of ROI for training sets; reported by Nils Gies 
	 
