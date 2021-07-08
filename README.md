# Multi-Dimensional Circuit Dynamics Solver for Photovoltaic Retinal Prosthesis

## Background
The [photovoltaic retinal prosthesis](https://en.wikipedia.org/wiki/Photovoltaic_retinal_prosthesis) stimulates the retinal neurons with an implantable electrode array powered by photodiodes. Because of the spread of electric field in the retina, the electric potentials are spatial coupled among active electrodes of different pixels, which should be considered as a multi-dimensional linear system. We propose using the impedance matrix to quantify the inter-pixel coupling, and, together with the non-linear model of photodiode, to solve for the multi-dimensional circuit dynamics.

This code demonstrates the circuit solver, which is fully described in paper *Electronic “photoreceptors” enable prosthetic vision with acuity matching the natural resolution in rats*. The code is in MATLAB, and uses sample data from [*Vertical-junction photodiodes for smaller pixels in retinal prostheses*](https://doi.org/10.1088/1741-2552/abe6b8) and our public COMSOL model.

## How to Run
MATLAB R2017a or later is recommended.
Run script *Circuit_Dynamics_solve.m* in the directory to solve the circuit dynamics, using the sample device parameters and stimulus in *Model*.
Run script *Synthesize_Efield.m* in the directory to synthesize the waveform measured by the micropipette, by linear combination of the sample elementary fields in *Model*.

Successful execution of the scripts should produce the red curve in Figure 4D of *Electronic “photoreceptors” enable prosthetic vision with acuity matching the natural resolution in rats*.

## Miscellanea
Correspondence should be addressed to [Charles](http://web.stanford.edu/~zcchen/) ( zcchen AT stanford DOT edu ).

To use this code in your research, please refer to the latest version of this repository for citation information.
