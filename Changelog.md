# CHANGELOG for XMapTools developer

## XMapTools 4 beta 2 (no public release yet)

- Release notes:
  - Add the VIRIDISLITE color palettes from Stéfan van der Walt and Nathaniel Smit
- Import Tool:
  - Add an option to change the type of data. To speed up the importation of LA-ICP-MS maps, this change can be applied to all maps when "isotope" is selected for the first time
  - Add an option to change the destination of all maps at once when one is changed for the first time.  
  - Add an option to edit manually the element/oxide name (input must match an element/oxide from the database). If the name is not matching an entry of the datavase, the raw is displayed in red in the table and it is not possible to import the maps. 
  - Add an option to filter comments out in complex file names. The element should come first followed by _ or - and a comment 
- Converter for LA-ICPMS data:
  - Improved user experience and plotting performances
  - Add an option to generate a calibration check matrix (CCM) for the secondary standard
  - Add an option to export data in a new directory if a folder Maps\_cps already exists
  - Add an option to select a primary standard if the name of the integration is not automatically recognised
  - Add a functionality to import manually a standard file 
- External functions:
  - Add therrmobarometry functions: Phengite\_P\_All
  - Add multi-equilibrium functions: GrtOpx\_T\_All; GrtPh\_T\_All
- Other:
  - Fix an issue in the EPMA calibration assistant resulting the program to crash when no standard is available for the first phase in the list
  - Fix an issue preventing a function description to be displayed for external function with the standalone versions  
