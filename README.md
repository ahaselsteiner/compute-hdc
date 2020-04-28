# compute-hdc: Highest density contour method in Matlab
![Environmental contour](example-environmental-contour.jpg)

A software to compute a highest density environmental contour.

A highest density (HD) contour is one possible definition for an environmental 
contour. This definition has been proposed by Haselsteiner, Ohlendorf, 
Wosniok and Thoben (2017; http://doi.org/10.1016/j.coastaleng.2017.03.002)

## Download and use the repository
To download this repository and its submodules use
```console
git clone --recurse-submodules https://github.com/ahaselsteiner/compute-hdc.git
```

## Individual files and functionality
This software involves a couple of .m files for computing a HD contour: 
* `computeHdc`: Computes the contour. It needs a probabilistic model, 
an exceedance probability and a grid as its input.
* `computeHdcExampleWithCMA`: Cotains examples how to use `computeHdc`.
* `getProbabilisticModel`: Returns some sample probabilistic models, 
which can be used with `computeHdc`. 
* The other functions are subroutines needed for `computeHdc`.

The software also includes implementations of other environmental contour 
methods, which use different definitions for the exceedance probablity 
of an environmental contour:
* `computeIFormContour`: Computes an inverse first order reliablity method 
(IFORM) contour.
* `computeDsContour`: Computes a direct sampling contour.
* `computeISormContour`: Computes an inverse second order reliablity method 
(ISORM) contour.

## Cite as
If you are using this software in your academic work please cite it as 
A.F. Haselsteiner (2020): compute-hdc: Highest density contour method in 
Matlab (version 1.2.3; https://github.com/ahaselsteiner/compute-hdc).
