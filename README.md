# readprocbactec
MATLAB/OCTAVE code to read, process, and write BACTEC MGIT 960 output files

The function **readprocbactec.m** is intended for automatized processing Excel files, which contain output data on mycobacterial growth from BACTEC MGIT 960 system. The data processing includes reading a standardised spreadsheet, its formatting into continuous columns with respect to the hours of recording and BACTEC intensity units with the subsequent fitting by the Gompertz growth curve. The obtained population growth data and parameters are saved as an Excel spreadsheet as well as the illustrating figures.

The function **procbactecjumps.m** reads the output Excel file produced by the function above, calculates and plots the growth curve, its first and second derivatives and determines the average time intervals between subsequent momenents of changes of the growth regime.

The file *H37Rv.xls* contains an example of real recordings of the growth curve of *M. tuberculosis* (the standard strain H37Rv).

For the usage with GNU Octave, pkg load io should be started first for reading Excel spreadsheets.

The related conference report: 
* Postnikov, E.B., Dogonadze M.Z., Lavrova A.I., "A MATLAB/OCTAVE toolbox for analysis of BACTEC MGIT 960 data for mycobacterial growth." 2020 5th International Conference on Intelligent Informatics and Biomedical Sciences (ICIIBMS). IEEE, 2020. https://ieeexplore.ieee.org/abstract/document/9336199
