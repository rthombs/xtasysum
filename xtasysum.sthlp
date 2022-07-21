{smcl}
{* *! Version 1.2 20Jul2022}
{hi:help xtasysum}{right: Version 1.2 July 20, 2022}
{hline}
{title:Title}

{phang}
{bf:xtasysum {hline 2} Generate, summarize, and visualize partial sums for modeling asymmetry with panel data.}

{title:Syntax}

{phang}
{cmd:xtasysum} {varlist} {ifin} [{cmd:,} {cmd:Threshold(}{it:#}{cmd:)} {cmd:Frequency} {cmd:Sum} {cmd:fdm} {cmd:GRSum} {cmd:GRFre} {cmd:grssave(}{it:string}{cmd:)} 
{cmd:grfsave(}{it:string}{cmd:)} {cmd:csd} {cmd:CSDOpt(}{it:string asis}{cmd:)} {cmd:cips(}{it:numlist integer min=2 max=2}{cmd:)} 
{cmd:CIPSOpt(}{it:string asis}{cmd:)} {cmd:NOgen}]

{phang}You must {cmd:xtset} your data before using; see {help xtset}.

{phang}{cmd:xtdcce2}, {cmd:xtcd2}, {cmd:xtcse2}, and {cmd:xtcips} must be installed. 


{title:Description}

{p 4 4 4}{cmd:xtasysum} generates, summarizes, and visualizes partial sums for modeling asymmetry with panel data. If no options are specified then positive and 
negative partial sums around a threshold of zero are created. The two new variables appear as {it:var}_p and {it:var}_n, respectively. The variables can then be 
used to model and test for asymmetry using regression analysis. The user may also generate frequencies and summary statistics, test for cross-sectional dependence
and non-stationarity, and generate graphs of the frequencies and partial sums. 


{title:Options}

{phang}{opt Threshold(#)} specifies the threshold by which the partial sums are generated; default is {cmd:Threshold(0)}. 

{phang}{opt Frequency} creates a table containing the frequencies of the partial sums by each variable in {varlist}.

{phang}{opt Sum} creates a summary table of the partial sums for each variable in {varlist}; see {help xtsum}. When {opt nogen} is specified, 
a summary table of the original variable is provided.

{phang}{opt fdm} generates two variables of the partial sums based on the first difference method (see Allison (2019) and York and Light (2017)). 

{phang}{opt GRSum} generates a line graph of the partial sums by panel. No graph is drawn, but a graph for each variable is saved. 

{phang}{opt GRFre} generates a bar graph of the frequencies of the partial sums by panel. No graph is drawn, but a graph for each variable is saved. 

{phang}{opt grssave(string)} saves the line graph of the partial sums by panel with a specified name. 

{phang}{opt grfsave(string)} saves the bar graph of the partial sums by panel with a specified name. 

{phang}{opt csd} reports the Pesaran (2015) test for weak cross-sectional dependence and the exponent of cross-sectional dependence (Bailey, Kapetanios, and 
Pesaran 2016, 2019). This is a wrapper of Ditzen's (2021) {stata xtcse2} program. When {opt nogen} is specified, test results correspond to the original variable.

{phang}{opt CSDOpt(string asis)} passes options to {stata xtcse2}.

{phang}{opt cips(numlist integer min=2 max=2)} reports the Pesaran (2007) panel unit-root test in the presence of cross-sectional dependence. This is a wrapper 
of the {stata xtcips} program (Burdisso and Sangiácomo 2016). The first integer refers to the maximum number of lags included in the test, and the second integer 
is the autocorrelation order used in the Lagrange multiplier test (see {help xtcips}). When {opt nogen} is specified, test results correspond to the original variable.

{phang}{opt CIPSOpt(string asis)} passes options to {stata xtcips}.

{phang}{opt NOgen} does not create partial sums for the variable. This option cannot be combined with {opt threshold}. 



{title:Examples}

{p 4 4}The following examples are based on an {browse "https://github.com/rthombs/xtasysum/blob/example.dta":example dataset} consisting of annual country-level 
data for GDP per capita, the percentage of the population residing in urban areas, and total population from 1971 to 2015. 

{p 4}To generate the partial sums:

{p 8}{stata xtasysum lngdp} 

{p 4}The default threshold is 0, which can be changed with the {opt Threshold} option:

{p 8}{stata xtasysum lngdp, threshold(.01)} 

{p 4 4}To generate the frequencies and descriptive statistics of the partial sums by each variable:

{p 8}{stata xtasysum lngdp, frequency sum} 

{p 4 4}To test for cross-sectional dependence and non-stationarity:

{p 8}{stata xtasysum lngdp, csd cips(3 3)} 

{p 4}To generate a graph of the frequencies and partial sums:

{p 8}{stata xtasysum lngdp, grfre grsum} 

{p 4}To generate variables using the first difference method:

{p 8}{stata xtasysum lngdp, fdm} 

{p 4}If the partial sums are already defined and you want to test for cross-sectional dependence:

{p 8}{stata xtasysum lngdp_p lngdp_n, nogen csd} 



{marker references}{title:References}

{p 4 8} Allison, Paul, D. 2019. "Asymmetric Fixed-Effects Models for Panel Data." {it:Socius}: 1-12

{p 4 8} Bailey, Natalia, George Kapetanios, and M. Hashem Pesaran. 2016. "Exponent of Cross-Sectional Dependence: Estimation and Inference." 
{it:Journal of Applied Econometrics} 31: 929-960.

{p 4 8} Bailey, Natalia, George Kapetanios, and M. Hashem Pesaran. 2019. "Exponent of Cross-sectional Dependence for Residuals." {it:Sankhya B} 81: 46–102.

{p 4 8} Burdisso, Tamara and Máximo Sangiácomo. 2016. "Panel Time Series: Review of the Methodological Evolution." {it:The Stata Journal} 16(2): 424-442.

{p 4 8} Ditzen, Jan. 2021. "Estimating Long-Run Effects and the Exponent of Cross-Sectional Dependence: An Update to xtdcce2." {it:The Stata Journal} 21(3): 687-707.

{p 4 8} Pesaran, M. Hashem. 2015. "Testing Weak Cross-Sectional Dependence in Large Panels." {it:Econometric Reviews} 34(6-10): 1089–1117

{p 4 8} Shin, Yongcheol, Byungchul Yu, and Matthew Greenwood-Nimmo. 2014. "Modelling Asymmetric Cointegration and Dynamic Multipliers in a Nonlinear 
ARDL Framework." Pp. 281–314 in {it:Festschrift in Honor of Peter Schmidt}, edited by R. Sickles and W. C. Horrace. New York: Springer.

{p 4 8} Thombs, Ryan. P., Xiaorui Huang, and Jared B. Fitzgerald. 2022. "What Goes Up Might Not Come Down: Modeling Directional Asymmetry with Large-N, 
Large-T Data." {it:Sociological Methodology} 52(1): 1-29.

{p 4 8} York, Richard and Ryan Light. 2017. "Directional Asymmetry in Sociological Analyses." {it:Socius} 3.


{marker Acknowledgements}{title:Acknowledgements}

{phang}Special thanks to Jared Fitzgerald and Xiaorui Huang for helpful comments and suggestions. 


{marker about}{title:Author}

{p 4}Ryan Thombs (Boston College){p_end}
{p 4}Email: {browse "mailto:thombs@bc.edu":thombs@bc.edu}{p_end}
{p 4}Web: {browse "www.ryanthombs.com":ryanthombs.com}{p_end}



