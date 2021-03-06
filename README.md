
# General
SFEM (Stochastic Finite Element Method) is a toolbox developed in a Matlab environment with a main purpose to numerically examine and/or proof the properties of elliptic partial differential equations (PDEs) with uncertain coefficient of divergence.

The main intention of this toolbox is to provide insight into this technique by allowing arbitrary boundary conditions, domain shapes and two types of PDEs.

# Installation

There is no need of installation. The only thing needed is to include 'functions' folder into the matlab path.
For stochastic-collocation and galerkin method it is necessary to download and include 'sglib' from http://ezander.github.io/sglib/

# Compatibility

The code is tested with Matlab 2017a (9.2). However the non-built in functions in previous matlab vesrions can be always suplemented afterwards.

# Contents

SFEM includes many subroutines, but mainly it is separated into seven divisions, namely these are:
- elliptic PDE solver
- imaging toolbox
- basic finite element procedures
- general functions
- monte carlo sampling method
- collocation sampling method
- stochastic galerkin sampling-free method (generalised polynomial chaos - gPC)

# Other information

The principles and description of methods utilized in the code can be found in an enclosed pdf file and the literature therein.



