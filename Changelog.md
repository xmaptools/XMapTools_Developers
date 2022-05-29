# CHANGELOG for XMapTools developer

## XMapTools 4 beta 3 (no public release yet)
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
	 
