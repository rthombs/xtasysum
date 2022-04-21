# `xtasysum`
A Stata command to generate and summarize partial sums for modeling asymmetry with panel data.

# Description 
`xtasysum` generates and summarizes partial sums for modeling asymmetry with panel data. If no options are specified then positive and negative partial sums around a threshold of zero are created. The partial sums can be used to model and test for asymmetry using regression analysis as discussed in Thombs, Huang, and Fitzgerald ([2022](https://journals.sagepub.com/doi/full/10.1177/00811750211046307?casa_token=C_JdtpUuVa4AAAAA%3AorO41QdizSvK3JvxrFtVp9zCTWFZejtNLNvH-muj7dHa7ewiwR9Uk_rub2JCc-yNdLWP3BOExWkz1A)). For descriptive purposes, the user may also generate frequencies, summary tables, test for cross-sectional dependence, and generate graphs of the partial sums as well as their frequencies.

# Syntax
    xtasysum varlist [if] [in] [, Threshold(#) Frequency Sum fd al GRSum GRFre NOgen]

## Options

    `Threshold` specifies the threshold by which the partial sums are generated; default is Threshold(0).

    `Frequency` creates a table containing the probability transitions and frequencies of the partial sums by each variable in varlist; see tab and xttrans.

    `Sum` creates a summary table of the partial sums for each variable in varlist; see xtsum.

    `fd` generates a variable containing the first differences that the partial sums are generated from.

    `al` generates the positive and negative changes based on Allison's (2019) definition. When a static model is estimated with the within estimator, this will
    produce equivalent results to the partial sums, but not in the dynamic case (Thombs, Huang, and Fitzgerald 2022).

    `GRSum` generates a line graph of the partial sums by panel. No graph is drawn, but a graph for each variable is saved.

    `GRFre` generates a bar graph of the frequencies of the partial sums by panel. No graph is drawn, but a graph for each variable is saved.

    `NOgen` does not create partial sums for the variable. This option cannot be combined with threshold.

 # Example 
    
An example dataset consisting of annual country-level data for GDP per capita, the percentage of the population residing in urban areas, and total population from 1971 to 2015 is available {browse "https://github.com/rthombs/eiwb/blob/main.dta":here}.

To generate the partial sums:

        xtasysum lngdp

The default threshold is 0, which can be changed with the Threshold option:

        xtasysum lngdp, threshold(.01)

To generate the frequencies and descriptive statistics of the partial sums by each variable:

        xtasysum lngdp, frequency sum

To test for cross-sectional dependence:

        xtasysum lngdp, csd

To generate a graph of the frequencies and partial sums:

        xtasysum lngdp, grsum grfre

To generate variables based on Allison's (2019) definition:

        xtasysum lngdp, al

If the partial sums are already defined:

        xtasysum lngdp_p lngdp_n, nogen csd

The options that can be abbreviated:

        xtasysum lngdp, t f s grs grf no


# Install 

`xtasysum` can be installed by typing the following in Stata:

    net install xtasysum, from("https://raw.githubusercontent.com/rthombs/xtasysum/main")
    
# References 

Allison, Paul, D. 2019. "Asymmetric Fixed-Effects Models for Panel Data." Socius:1-12

Shin, Yongcheol, Byungchul Yu, and Matthew Greenwood-Nimmo. 2014. "Modelling Asymmetric Cointegration and Dynamic Multipliers in a Nonlinear ARDL Framework." Pp. 281–314 in Festschrift in Honor of Peter Schmidt, edited by R. Sickle C. Horrace. New York: Springer.

Thombs, Ryan. P., Xiaorui Huang, and Jared B. Fitzgerald. 2021. "What Goes Up Might Not Come Down: Modeling Directional Asymmetry with Large-N, Large-T Data." Sociological Methodology.


# Author

[**Ryan P. Thombs**](ryanthombs.com)  
**(Boston College)**  
**Contact Me: [thombs@bc.edu](mailto:thombs@bc.edu)**
