
# General

SFEM-MC (Stochastic Finite Element Method - Monte Carlo) is a toolbox developed in a Matlab environment with a main purpose to examine 

o recover parameter/s of elliptic and/or parabolic partial differential equations (PDEs) from Neumann-to-Dirichlet (NTD) or Dirichlet-to-Neumann (DTN) data on boundary.

The idea of recovering the spatial distribution of material properties inside a domain of interest using only a boundary measurements dates back to 1930 in geophysics by R. E. Langer (1933), however, the principle of recovering the material information from Cauchy data is being named after Argentinian mathematician Alberto Calderón, who first defined a more profound mathematical formulation in a foundational paper published in 1980. Nowdays the method is most commonly used as a medical imaging technique named Electrical Impedance Tomography (EIT) which utilizes the solution of electrostatics.
The main intention of this toolbox is to provide insight into this technique by allowing arbitrary boundary conditions, domain shapes and two types of PDEs.

----------------------------------------------
                Installation
----------------------------------------------

There is no need of installation. The only thing needed is to include 'functions' folder into the matlab path.

----------------------------------------------
                Compatibility
----------------------------------------------

The code is tested with Matlab 2017a (9.2). However the non-built in functions in previous matlab vesrions can be always suplemented afterwards.

----------------------------------------------
                  Contents
----------------------------------------------

BITM includes many subroutines, but mainly it is separated into five divisions, namely these are:
- elliptic PDE solver
- parabolic PDE solver
- imaging toolbox
- basic finite element procedures
- general functions

----------------------------------------------
              Other information
----------------------------------------------

The principles and description of methods utilized in the code can be found in an enclosed pdf file.
Unfortunately the paper is still in progress.



