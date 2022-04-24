{smcl}
{* *! Version 1.0 4jan2022}
{hi:help xtasysum}{right: Version 1.0 January 4, 2022}
{hline}
{title:Title}

{phang}
{bf:xtasysum {hline 2} Generate and summarize partial sums for modeling asymmetry with panel data.}

{title:Syntax}

{phang}
{cmd:xtasysum} {varlist} {ifin} [{cmd:,} {cmd:Threshold(}{it:#}{cmd:)} {cmd:Frequency} {cmd:Sum} {cmd:csd} {cmd:fd} {cmd:al} {cmd:GRSum} {cmd:GRFre} {cmd:NOgen}]


{title:Description}

{p 4 4}{cmd:xtasysum} generates and summarizes partial sums for modeling asymmetry with panel data. If no options are specified then positive and negative partial sums around a threshold of zero are created. The variables can then be used to model and test for asymmetry using regression analysis. For descriptive purposes, the user may also generate frequencies, transition probabilities, and summary tables, as well graphs for the frequencies and partial sums. 


{title:Options}

{phang}{opt Threshold} specifies the threshold by which the partial sums are generated; default is {cmd:Threshold(0)}. 

{phang}{opt Frequency} creates a table containing the frequencies of the partial sums by each variable in {varlist}; see {help tab}.

{phang}{opt csd} reports the Pesaran (2015) test for weak cross-sectional dependence and the exponent of cross-sectional dependence (Bailey, Kapetanios, and Pesaran 2016, 2019); This is a wrapper of Ditzen's (2021) {stata xtcse2} program.

{phang}{opt Sum} creates a summary table of the partial sums for each variable in {varlist}; see {help xtsum}.

{phang}{opt fd} generates a variable containing the first differences that the partial sums are generated from. 

{phang}{opt al} generates the positive and negative changes based on Allison's (2019) definition. When a static model is estimated with the within estimator, this will produce the same results as the partial sums, but not in the dynamic case (see Thombs, Huang, and Fitzgerald 2022).

{phang}{opt GRSum} generates a line graph of the partial sums by panel. No graph is drawn, but a graph for each variable is saved. 

{phang}{opt GRFre} generates a bar graph of the frequencies of the partial sums by panel. No graph is drawn, but a graph for each variable is saved. 

{phang}{opt NOgen} does not create partial sums for the variable. This option cannot be combined with {opt threshold}. 



{title:Examples}

{p 4 4}An example dataset consisting of annual country-level data for GDP per capita, the percentage of the population residing in urban areas, and total population from 1971 to 2015 is available {browse "https://github.com/rthombs/eiwb/blob/main/example.dta":here}.

{p 4}To generate the partial sums:

{p 8}{stata xtasysum lngdp} 

{p 4}The default threshold is 0, which can be changed with the {opt Threshold} option:

{p 8}{stata xtasysum lngdp, threshold(.01)} 

{p 4 4}To generate the frequencies and descriptive statistics of the partial sums by each variable:

{p 8}{stata xtasysum lngdp, frequency sum} 

{p 4 4}To test for cross-sectional dependence:

{p 8}{stata xtasysum lngdp, csd} 

{p 4}To generate a graph of the frequencies and partial sums:

{p 8}{stata xtasysum lngdp, grsum grfre} 

{p 4}To generate variables based on Allison's (2019) definition:

{p 8}{stata xtasysum lngdp, al} 

{p 4}If the partial sums are already defined:

{p 8}{stata xtasysum lngdp_p lngdp_n, nogen csd} 

{p 4}The options that can be abbreviated:

{p 8}{stata xtasysum lngdp, t f s grs grf} 



{marker references}{title:References}

{p 4 8} Allison, Paul, D. 2019. "Asymmetric Fixed-Effects Models for Panel Data." {it:Socius}:1-12

{p 4 8} Bailey, Natalia., George Kapetanios, and M. Hashem Pesaran. 2016. "Exponent of Cross-Sectional Dependence: Estimation and Inference." {it:Journal of Applied Econometrics} 31: 929-960.

{p 4 8} Bailey, Natalia, George Kapetanios, and M. Hashem Pesaran. 2019. "Exponent of Cross-sectional Dependence for Residuals." {it:Sankhya B} 81: 46–102.

{p 4 8} Ditzen, Jan. 2021. "Estimating Long-Run Effects and the Exponent of Cross-Sectional Dependence: An Update to xtdcce2." {it:The Stata Journal}, 21(3): 687-707.

{p 4 8} Pesaran, M. Hashem. 2015. "Testing Weak Cross-Sectional Dependence in Large Panels." {it:Econometric Reviews} 34(6-10): 1089–1117

{p 4 8} Shin, Yongcheol, Byungchul Yu, and Matthew Greenwood-Nimmo. 2014. "Modelling Asymmetric Cointegration and Dynamic Multipliers in a Nonlinear ARDL Framework." Pp. 281–314 in {it:Festschrift in Honor of Peter Schmidt}, edited by R. Sickles and W. C. Horrace. New York: Springer.

{p 4 8} Thombs, Ryan. P., Xiaorui Huang, and Jared B. Fitzgerald. 2022. "What Goes Up Might Not Come Down: Modeling Directional Asymmetry with Large-N, Large-T Data." {it:Sociological Methodology} 52(1): 1-29.



{marker about}{title:Author}

{p 4}Ryan Thombs (Boston College){p_end}
{p 4}Email: {browse "mailto:thombs@bc.edu":thombs@bc.edu}{p_end}
{p 4}Web: {browse "www.ryanthombs.com":ryanthombs.com}{p_end}



