# CHANGELOG for XMapTools developer

## XMapTools 4 beta 2 (no public release yet)

- Release notes:
  - ...
- Import Tool:
  - Add an option to change the type of data. To speed up the importation of LA-ICP-MS maps, this change can be applied to all maps when "isotope" is selected for the first time 
  - Add an option to edit manually the element/oxide name (input must match an element/oxide from the database). If the name is not matching an entry of the datavase, the raw is displayed in red in the table and it is not possible to import the maps.  
- External functions:
  - Add therrmobarometry functions: Phengite_P_All
  - Add multi-equilibrium functions: GrtOpx_T_All; GrtPh_T_All
- Other:
  - fix an issue in the EPMA calibration assistant resulting the program to crash when no standard is available for the first phase in the list
