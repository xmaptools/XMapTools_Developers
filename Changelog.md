# CHANGELOG for XMapTools developer


## XMapTools 4.4 (build 250321)

This version is highly recommended for all users as it includes new features, bug fixes and stability improvements to the software.  

- Compatibility information for MacOS users:
Note that the public compiled version of XMapTools 4.4 runs natively on Apple Silicon Macs using MATLAB Runtime 24.3, resulting in a significant performance gain. However, the version of XMapTools 4.4 compatible with the M-Series chip is limited to MacOS Ventura (13), Sonoma (14) and Sequoia (15). The previous MATLAB runtime version v912 can be removed after upgrading to XMapTools 4.4 final release.   

- General:
  - Add a Data Export module to export median and/or mean mineral compositions from merged  quanti and result maps as csv files. This module is available from the Add-ons tab and is compatible with the new sub-mask classification.
  - Add several submask classification tools, including an unsupervised classification method based on the k-means algorithm proposed by Gies et al. (2024), Computers & Geosciences, 189, 105626 and a manual classification method in the Data Visualisation module inspired by Prêt et al. (2010), American Mineralogist, 95, 1379-1388.  
  - Add multi-ROI selection tool in the data visualisation module and the ability to save the manually created maskfile (or submask to a selected maskfile) in XMapTools. These new features can be used in both binary and ternary diagrams.
   - Add the Border Removing Correction (BRC) algorithm from XMapTools 3.4 to the data visualisation module. If checked, the border pixels of the selected mask file will be filtered out. 
  - Add a new structural formula calculation method for biotite based on Waters & Charnley (2002) assuming an 11 oxygen + Ti basis to account for a deprotonation substitution (added by P. Hartmeier).
  - Add a tool to duplicate and adjust the minimum and maximum total values of a set of merged maps (available from the Edit > Map > Duplicate and Adjust menu). This tool allows the user to define a minimum, maximum and sigma value and to rescale all pixels whose sum exceeds this value. It can be used to eliminate some of the artefacts of the EPMA multi-phase calibration routine, especially for mixed pixels that end up with too high totals. 
  - Add the ability to define multiple ROIs to generate a local bulk composition.
  - Add an option to export a merged dataset to text files (available from the Edit > Dataset > Export (Merged) menu).
  - Add an option to convert quanti and merged maps from oxide wt% to oxide moles. These datasets can be used in the data visualisation module. 
  - Add an option to duplicate a training set.
  - Improve the Select and Crop feature and enable it to crop merged maps. This addition was suggested by Cam Davidson for cropping quantitative compositional maps obtained by SEM.

- LA-ICPMS:
  - Improve the LA-ICPMS calibration module by the addition of several Pixel Reconstruction and Improved Precision (PRIP) tools. Manual PRIP mode allows ROIs to be manually selected during calibration to estimate local composition with improved LOD. A comparison with the median composition and LOD of all pixels within each ROI is also provided. The PRIP-AI module allows the calculation of pixel compositions below the LOD using neural networks. These new features are under development and limited in the public version of XMapTools; they will be documented in a publication. Contact Pierre Lanari or Thorsten Markmann for more information.  
  - Add a sweep extraction routine to the converter for LA-ICPMS to export data from all measured sweeps. The generated data are stored in a new file SweepData_Import.mat.
  - The LOD filter is automatically applied in the LA-ICPMS calibration module when a new Quanti dataset is generated.
  - Add an option to the LA-ICPMS calibration module to store unfiltered maps (LOD). If this option is selected, two Quanti datasets will be generated, one filtered (default) and one unfiltered labeled as "no LOD filter".
  - Add a module to select the date format when importing files from LA-ICPMS instruments.
  - Store the results of the last standard calibration test in a last_std_calibration_test.txt file in the working directory. This file is be copied to the map folder when the maps are exported. 
  - Display the mean(sweeps) obtained by the sweep extraction routine when visualising the generated maps using the show button.  
  - Improve signal display and background integrations in the converter module. The count rate of a single sweep is displayed with a dot. Integrations are displayed in black if no count was taken during the interval.
  - Fix minor issues with ROI generation and plot interaction in the Log Generator module.
  
- Classification:
  - Add the ability to use maps from the Other category (e.g. BSE, CL, etc.) for classification.
  - Add a button to remove all the selected maps for classification.
  - Set the number of neighbours to 5 for K-nearest neighbours.
  - Add an option to select a mask with merged data.
  - Disable the log scale of the colour bar when a mask file is selected and displayed.

- Bingo-Antidote 
  - Add the database JUN92_Pourteau2014 as used in Petroccia et al. (2025) JMG 43,21-46. 
  
- Other:
  - Enhance the Generator module by adding the ability to use log, log10 and exp functions.
  - Enhance the Data Visualisation module with the ability to use log scales for binary plots.
  - Add log scale compatibility to multi-plot images and to the gif creation function.
  - Improve the map display engine as a test for compatibility with future versions of MATLAB. To start XMapTools with the 4.3 legacy display engine, simply add an empty legacy.xmt file to your working directory.
  - Fix a problem with the merge function that did not work properly when multiple quanti files had the same name.
  - Fix a problem where the zoom state was lost when exporting the map to a new window. 
  - Fix an aspect ratio error for the RGB image in the Data Visualization module.
  - Fix a problem in the Calibration for EPMA module that could occur if a point was outside the map boundaries; a warning message has been added. Thanks to Stephen Centrella for reporting this issue. 
  - Fix a problem in the calculation of the end member fraction for andradite garnets. Thanks to Rich Taylor for reporting this problem.
  - Fix an issue that prevented the first map from being displayed when a Quanti dataset was selected.
  - Fix an issue with displaying mask names in the Data Visualization module when a mask file was selected. Thanks to Jonas Vanardois and the second year bachelor students at UNIL for reporting this issue. 
  - Fix a issue in the converter for EPMA (JEOL Windows recipe) where the CL maps were not recognised.
  - Solve an issue in the Spider module that prevented the plot from being updated. Thanks to Guillaume Bonnet for reporting this issue.
  - Minor fixes in XMap_MinColors.txt and XMap_MinDensity.txt.
  - Improve compatibility of the Export Plot Tool (opens in a new window) by allowing log scale colour bars to be properly exported.
  - Change the data type from 'wt%' to 'wt/wt' in the Import module.
  - Edit the message displayed when XMapTools is used for the first time.
  - Fix a configuration error for users using the latest developer version via MATLAB.
  - Other minor bug and fixes

Release notes published on 21.03.2025, by Pierre Lanari & Philip Hartmeier.


## XMapTools 4.3 (build 240114)

- General
  - Add a functionality to reorder masks within a maskfile
  - Improve the correlation plots by implementing an option to select a submask
  - Improve the output format of the multi-map export function for all sampling methods
  - Improve the live plot of the sampling method strip
  - Improve the calibration module interface for EPMA data, including a description of the check calibration table 
  - Add a subroutine to check the map size before classification. Display an error message with the map size if there is any problem with the data (problem discovered by Alissa Madera)
  - Update and improve the help files
  
LA-ICP-MS: 
  - Add a multi-file mode for importing LA-ICP-MS data
  - Add a log generator module for data collected in separate files
  - Add a functionality to filter values below LOD in quanti files
  - Add standard files for: NIST614, FGS1, FGS2, STDGL3, MASS1, NiS3, MAPS4, MACS3
  - Modify the export function to append the isotope number to the file name (e.g. Al.txt is now Al_27.txt)
  - Optimize the GUI of the data conversion module for LA-ICP-MS
  
- Classification:
  - Add a classification test and calculate the classification metrics (Accuracy, Precision, Recall, F1 Score); they are displayed in the Information tab, if a mask file is selected. This feature is not available for mask files created with previous versions of XMapTools
  - Improve significantly the performance of classification for sub-mask creation and fix several minor issues 
  - Improve the overall appearance of the graphs generated by the Classification function
  - Improve the composition plot in the classification by implementing the mineral colors

- Data Visualisation Module:
  - Add a submask selection option for plotting 
  - Add an option to fix (hold on) the axis limits in binary plots
  - Add the specific colors of each mask for plotting
  - Improve performance of density map calculation; density maps are now displayed in low resource mode by default
  - Add an option to hide the density map in low resource mode
  - Add an option to set the density map resolution (default: 100)

- Drift correction module:
  - Add a drift correction module to XMapTools 4 with enhanced data visualisation capabilities  
  - Add a 2D correction subroutine based on a single mask that includes data renormalisation 
  
- Sampling Tools (thanks to @hannahcunning on GitHub for suggesting these changes):
  - Add a label showing the orientation of the stip when the shape is modified or rotated. 
  - Improve multi-map export function when a mask is selected from the secondary menu
  - Improve the file format for single-map sampling
  - Add an option to the Sampling menu to hold the ROI. The ROI will not be deleted if the mask selection is changed from the secondary menu and this mode is selected
  
- Other: 
  - Fix an issue in the external function for rutile thermometry for the Kohn (2020) equations (pressure unit, discovered by Mona Lueder)
  - Fix several compatibility issues in the project loader for files created with previous versions of XMapTools
  - Fix an issue in the data visualisation module for binary plots after the mask option was disabled
  - Fix a display issue in the information window for map data containing NaN values
  - Fix an error in the title of the sampling strip plot where colors where switched; the blue curve represents the median and the red curve represents the mean profiles (discovered by Nils Gies)





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
  - The following thermodynamic databases have been tested: JUN92.bs; td-ds55-HP1.txt; td-ds62-mp50-v05.txt; td-ds62-mb50-v07.txt
  
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
	 
