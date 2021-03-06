# `xtasysum`
A Stata command to generate, summarize, and visualize partial sums for modeling asymmetry with panel data.

# Description 
`xtasysum` generates, summarizes, and visualizes partial sums for modeling asymmetry with panel data. If no options are specified then positive and negative partial sums around a threshold of zero are created. The two new variables appear as *var*_p and *var*_n, respectively. The partial sums can be used to model and test for asymmetry using regression analysis as discussed in Thombs, Huang, and Fitzgerald ([2022](https://journals.sagepub.com/doi/full/10.1177/00811750211046307?casa_token=C_JdtpUuVa4AAAAA%3AorO41QdizSvK3JvxrFtVp9zCTWFZejtNLNvH-muj7dHa7ewiwR9Uk_rub2JCc-yNdLWP3BOExWkz1A)). The user may also generate frequencies and summary tables, test for cross-sectional dependence and non-stationarity, and generate graphs of the partial sums as well as their frequencies.

# Syntax
    xtasysum varlist [if] [in] [, Threshold(#) Frequency Sum fdm GRSum GRFre grssave(string) grfsave(save) csd CSDOpt(string asis) cips(numlist integer min=2 max=2) CIPSOpt(string asis) NOgen]

## Options

`Threshold` specifies the threshold by which the partial sums are generated; default is `Threshold(0)`.

`Frequency` creates a table containing the frequencies of the partial sums by each variable in varlist.

`Sum` creates a summary table of the partial sums for each variable in varlist; see `xtsum`. When `nogen` is specified, a summary table of the original variable is provided.

`fdm` generates a variable of the partial sums based on the first difference method (see Allison (2019) and York and Light (2017)).

`GRSum` generates a line graph of the partial sums by panel. No graph is drawn, but a graph for each variable is saved.

`GRFre` generates a bar graph of the frequencies of the partial sums by panel. No graph is drawn, but a graph for each variable is saved.

`grssave(string)` saves the line graph of the partial sums by panel with a specified name.

`grfsave(string)` saves the bar graph of the partial sums by panel with a specified name.

`csd` reports the Pesaran (2015) test for weak cross-sectional dependence and the exponent of cross-sectional dependence (Bailey, Kapetanios, and Pesaran 2016, 2019); This is a wrapper of Ditzen's (2021) `xtcse2` program. When `nogen` is specified, test results correspond to the original variable.

`CSDOpt(string asis)` passes options to `xtcse2`.

`cips(numlist integer min=2 max=2)` reports the Pesaran (2007) panel unit-root test in the presence of cross-sectional dependence. This is a wrapper of the `xtcips` program (Burdisso and Sangi??como 2016). When specified, the first integer refers to the maximum number of lags included in the test, and the second number is the autocorrelation order used in the Lagrange multiplier test (see `xtcips`). When `nogen` is specified, test results correspond to the original variable.

`CIPSOpt(string asis)` passes options to `xtcips`.

`NOgen` does not create partial sums for the variable. This option cannot be combined with `threshold` or `fdm`. This option is useful if the partial sums have already been created or you are interested in examining the original variable.

 # Example 
    
An example dataset consisting of annual country-level data for GDP per capita, the percentage of the population residing in urban areas, and total population from 1971 to 2015 is available [here](https://github.com/rthombs/xtasysum/blob/main/example.dta).

To generate the partial sums:

        xtasysum lngdp

The default threshold is 0, which can be changed with the `Threshold` option:

        xtasysum lngdp, threshold(.01)

To generate the frequencies and descriptive statistics of the partial sums by each variable:

        xtasysum lngdp, frequency sum

To test for cross-sectional dependence and non-stationarity:

        xtasysum lngdp, csd cips(3 3)

To generate variables based on the first difference method:

        xtasysum lngdp, fdm

If the partial sums are already defined, then use `nogen` option to test for cross-sectional dependence:

        xtasysum lngdp_p lngdp_n, nogen csd
        
To generate a graph of the frequencies and partial sums:

        xtasysum lngdp, grsum grfre
        
This will produce the following graphs: 

![lngdp_sums](https://user-images.githubusercontent.com/40503845/180295093-73f50599-3291-4cbe-af99-de62ae4d1f52.png)


![lngdp_fre](https://user-images.githubusercontent.com/40503845/180295091-98821c7a-4467-4dca-93c4-de0c0e10130e.png)

# Install 

`xtasysum` can be installed by typing the following in Stata:

    net install xtasysum, from("https://raw.githubusercontent.com/rthombs/xtasysum/main") replace
    
# References 

Allison, Paul D. 2019. "Asymmetric Fixed-Effects Models for Panel Data." *Socius*: 1-12. 

Bailey, Natalia, George Kapetanios, and M. Hashem Pesaran. 2016. "Exponent of Cross-Sectional Dependence: Estimation and Inference." *Journal of Applied Econometrics* 31: 929-960.

Bailey, Natalia, George Kapetanios, and M. Hashem Pesaran. 2019. "Exponent of Cross-sectional Dependence for Residuals." *Sankhya B* 81: 46???102. 

Burdisso, Tamara and M??ximo Sangi??como. 2016. "Panel Time Series: Review of the Methodological Evolution." *The Stata Journal* 16(2): 424-442.

Ditzen, Jan. 2021. "Estimating Long-Run Effects and the Exponent of Cross-Sectional Dependence: An Update to xtdcce2." *The Stata Journal* 21(3): 687-707.

Pesaran, M. Hashem. 2015. "Testing Weak Cross-Sectional Dependence in Large Panels." *Econometric Reviews* 34(6-10): 1089???1117.

Shin, Yongcheol, Byungchul Yu, and Matthew Greenwood-Nimmo. 2014. "Modelling Asymmetric Cointegration and Dynamic Multipliers in a Nonlinear ARDL Framework." Pp. 281???314 in Festschrift in Honor of Peter Schmidt, edited by R. Sickle C. Horrace. New York: Springer.

Thombs, Ryan. P., Xiaorui Huang, and Jared B. Fitzgerald. 2022. "What Goes Up Might Not Come Down: Modeling Directional Asymmetry with Large-N, Large-T Data." *Sociological Methodology* 52(1): 1-29. 

York, Richard and Ryan Light. 2017. "Directional Asymmetry in Sociological Analyses." *Socius* 3.

# Acknowledgements

Special thanks to Jared Fitzgerald and Xiaorui Huang for helpful comments and suggestions. 

# Author

[**Ryan P. Thombs**](ryanthombs.com)  
**(Boston College)**  
**Contact Me: [thombs@bc.edu](mailto:thombs@bc.edu)**
