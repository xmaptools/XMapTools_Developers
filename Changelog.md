# CHANGELOG for XMapTools developer

## XMapTools 4 beta 2 (no public release yet)

- Release notes:
  - Add a new data category "Images" available in the primary menu in which specific images with their settings (color palette and range, etc.) can be stored. Three types are available: (1) Multi-plot image for plotting several images and generating a gif, (2) Multi-layer Image (shared scale) to combine several maps with a shared scale, (3) Multi-layer Image (multi-scale) to combine several maps but with different color palettes.
  - Add new features to save data obtained with the sampling functions either for the selected map (single map) or all maps in the same data category (multiple map)  
  - Add an option to inverse the color sequence of the selected color palette
  - Improve significantly the plotting engine for single and multi maps. This update should solve most of the display issues reported with beta 1
  - Improve the ROI (general): calculations and plots are only performed/updated once the ROI has been moved and not while it is moving as it was before. This change improves the overal performance of the program. 
  - Improve the conversion of CAMECA data and resolve several issues. The compatible formats are described at: https://resources.xmaptools.ch/converting-cameca-data/
  - The position of spots (internal standards) can be edited manually for the spot selected in the secondary menu; data and plots are automatically updated after a spot position is changed 
  - Add the VIRIDISLITE color palettes from Stéfan van der Walt and Nathaniel Smit
  - Add a new color palette from Nils Gies (Nils OH)
- Import Tool:
  - Add an option to change the type of data. To speed up the importation of LA-ICP-MS maps, this change can be applied to all maps when "isotope" is selected for the first time
  - Add an option to change the destination of all maps at once when one is changed for the first time.  
  - Add an option to edit manually the element/oxide name (input must match an element/oxide from the database). If the name is not matching an entry of the datavase, the raw is displayed in red in the table and it is not possible to import the maps. 
  - Add an option to filter comments out in complex file names. The element should come first followed by _ or - and a comment 
- Converter for LA-ICPMS data:
  - Improved user experience and plotting performances
  - Add an option to generate a calibration check matrix (CCM) for the secondary standard
  - Add an option to export data in a new directory if a folder Maps\_cps already exists
  - Add an option to select data for primary/secondary standards if the name of the integration is not automatically recognised
  - Add a functionality to import manually a standard file 
  - Add the possibility to process several maps from the same dataset in case multiple areas were analysed during the same session
- Classification:
  - Improve the selection of input data for classification
  - Add an option to select the method used for data scaling
  - Add an option to ensure reproducibility of the classification algorithms based on random numbers (using seeds for the random number generator)
  - Add an option to select the number of trees in the random forest algorithm.
- External functions:
  - Add thermobarometry functions: Phengite\_P\_All
  - Add multi-equilibrium functions: GrtOpx\_T\_All; GrtPh\_T\_All
  - Add Ti-in-biotite thermometer of Wu & Chen (2015)
  - Number of oxygen for normalisation in function StructFctSerpentine changed to 14 (was 14.5) and add the output variable Si_ratio = Si./(Si+Fe+Mg)
- Other:
  - The same color palette is used for the pie chart when exporting the mineral modes
  - Fix an issue in the EPMA calibration assistant resulting the program to crash when no standard is available for the first phase in the list
  - Fix an issue preventing a function description to be displayed for external function with the standalone versions  
  - Resolve a problem in the internal configuration file that could prevent XMapTools to start 
  - Fix an issue in the function opening projects in case the standard variable is corrupted
  - Fix an issue in the plot function for filtering infinite data out (e.g. in ratio maps)
  - Fix an issue that the filter value for the 3D surface was not saved in the project
  - Fix an issue in the merging function when some pixel values are NaN 
  - Fix an issue preventing a single map file to be imported
	 
