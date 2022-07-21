*! Version1.2 Ryan Thombs 7/20/22


program define xtasysum, rclass sortpreserve
        version 14
 
        syntax varlist(min=1 numeric ts) [if] [in] [, Threshold(real 0) Frequency Sum fdm GRSum GRFre grssave(string) grfsave(string) csd CSDOpt(string asis) cips(numlist integer min=2 max=2) CIPSOpt(string asis) NOgen] 
		
		*Ensure xtset
		qui cap xtset
		if "`r(panelvar)'" == "" | "`r(timevar)'" == "" {
		display as error "The data must be xtset."
		exit 198
		}
		
		
		loc id = r(panelvar)
		loc time = r(timevar)
		
		
		marksample touse, novarlist
		qui count if `touse'
		if `r(N)' == 0 {
			error 2000
		}
	
		
		***Determine threshold value
		if "`threshold'" != ""	{
			loc th = `threshold'
		}
		else	{
			loc th = 0
		}
		
		
		
		***Don't generate variable is nogen specified
		if "`nogen'" == "" {
		foreach v of varlist `varlist'{	
			tempvar diff`v' pos`v' neg`v'
			qui gen double `diff`v'' = d.`v' if `touse'
			qui gen double `pos`v'' = `diff`v''*(`diff`v''>`th') if `touse'
			qui gen double `neg`v'' = `diff`v''*(`diff`v''<`th') if `touse'		
			by `id': gen `v'_p = sum(`pos`v'') if `touse'
			qui replace `v'_p = . if `v'==.
			qui label variable `v'_p "Positive sum for `v' (greater than `th')"
			by `id': gen `v'_n = sum(`neg`v'') if `touse'	
			qui replace `v'_n = . if `v'==.
			qui label variable `v'_n "Negative sum for `v' (less than `th')"			
			loc varlist2 "`varlist2' `v'_p `v'_n"			
			}		
		}
		else {			
			loc varlist2 "`varlist2' `varlist'"
		}
		
		
		***Don't combine nogen and threshold 
		if "`nogen'" != "" & `th' != 0  {
			di as error "The options nogen and threshold can't both be specified."
			exit 198
		}
		
		
		***Don't combine nogen and fdm
		if "`nogen'" != "" & "`fdm'" != ""  {
			di as error "The options nogen and fdm can't both be specified."
			exit 198
		}
			
		
		
		***Gen frequency table	
		if "`frequency'" == "frequency" {
			tempname fmat 
			loc nvar : word count `varlist'
			matrix `fmat' = J(`nvar', 7,.)					
			loc i 0 
			di as text " "
			di as text "{bf:Frequency of Partial Sums for Threshold = `th'}"
			di as text " "
			di as text "{hline 13}{c TT}{hline 70}" 
			di as text _col(14) "{c |}" _col(20) "Greater Than `th'" _col(40) "Less Than `th'" _col(60) "Equal to `th'"
			di as text " Variables   {c |}" _col(20) "Freq." _col(30) "%"  _col(40) "Freq."  _col(50) "%"  _col(60) "Freq."  _col(70) "%"   _col(80) "Obs." 
			di as text "{hline 13}{c +}{hline 70}" 
			foreach v of varlist `varlist' {
				local ++i
				tempvar d`v' ab`v'
				 qui gen `d`v''= d.`v'
				 qui gen `ab`v'' = 1 if `d`v''> `th' & `d`v''!=.
				 qui replace `ab`v'' = 2 if `d`v''< `th'
				 qui replace `ab`v'' = 3 if `d`v''== `th' 
				 qui tab `ab`v'' if `touse', matcell(freq)
				 
				local pos = freq[1,1]
				local pos: display %12.0f `pos'
				
				local neg = freq[2,1]
				local neg: display %12.0f `neg'
				
				local zero = freq[3,1]
				local zero: display %12.0f `zero'
				
				mata : st_matrix("coltot", colsum(st_matrix("freq")))
				mata : st_matrix("rowtot", rowsum(st_matrix("freq")))
				matrix coltotal = J(1, rowsof(freq), 1) * freq
				matrix rowtotal = freq * J(colsof(freq), 1, 1)
				local colt = coltotal[1,1]
				
				local pos_per = (`pos'/`colt')*100
				local pos_per: display %8.2f `pos_per'
				
				local neg_per = (`neg'/`colt')*100
				local neg_per: display %8.2f `neg_per'
				
				local zero_per = (`zero'/`colt')*100
				local zero_per: display %8.2f `zero_per'
			
				matrix `fmat'[`i',1] = `pos'
				matrix `fmat'[`i',2] = `pos_per'
				matrix `fmat'[`i',3] = `neg'
				matrix `fmat'[`i',4] = `neg_per'
				matrix `fmat'[`i',5] = `zero'
				matrix `fmat'[`i',6] = `zero_per'
				matrix `fmat'[`i',7] = `colt'
				loc fown "`fown' `v'"

				
			display as text %12s abbrev("`v'",12) " {c |}" _c
			di as result _column(20) `pos'  _column(30) `pos_per'  _column(40) `neg'  _column(50) `neg_per' _column(60) `zero'  _col(70) `zero_per' _col(80) `colt'
				}
			di as text "{hline 13}{c BT}{hline 70}" 
			
			matrix colnames `fmat' = "(> `th')" "> Per." "(< `th')" "< Per." "(= `th')" "= Per." Obs
			matrix rownames `fmat' = `fown'
			return matrix fre = `fmat'	
		}
		
		
			
		***Generate variables based on Allison (2019) definition of the first difference method
		if "`fdm'" == "fdm"{
			foreach v of varlist `varlist'{	
				tempvar diff`v'
				qui gen double `diff`v'' = d.`v' if `touse'
				qui gen double `v'_pfd = `diff`v''*(`diff`v''>`th') if `touse'
				qui label variable `v'_pfd "Positive change for `v' (greater than `th') using first difference method"
				qui gen double `v'_nfd = `diff`v''*(`diff`v''<`th') if `touse'
				qui label variable `v'_nfd "Negative change for `v' (less than `th') using first difference method"
			}
			}
			
			
		***Summarize variables 
		if "`sum'" == "sum" {
			loc nvar : word count `varlist2'
			tempname rmat 
			matrix `rmat' = J(`nvar', 7,.)					
			loc i 0 
			di as text " "
			di as text "{bf:Summary Statistics for Partial Sums}"
			di as text " "
			di as text "{hline 13}{c TT}{hline 70}" 
			di as text _col(14) "{c |}" _col(28) "Overall" _col(41) "Within"  _col(54) "Between"  
			di as text " Variables   {c |}" _col(18) "Mean" _col(28) "Std. Dev."  _col(41) "Std. Dev."  _col(54) "Std. Dev."  _col(66) "N/T"  _col(78) "Obs." 
			di as text "{hline 13}{c +}{hline 70}" 
			foreach v of varlist `varlist2' {
				local ++i
				qui xtsum `v' if `touse' 
				matrix `rmat'[`i',1] = r(mean)
				local mean = `rmat'[`i',1]
				matrix `rmat'[`i',2] = r(sd)
				local sd = `rmat'[`i',2]
				matrix `rmat'[`i',3] = r(sd_b)
				local sdb = `rmat'[`i',3]
				matrix `rmat'[`i',4] = r(sd_w)
				local sdw = `rmat'[`i',4]
				matrix `rmat'[`i',5] = r(N)
				local N = `rmat'[`i',5]
				matrix `rmat'[`i',6] = r(n)
				local n = `rmat'[`i',6]
				matrix `rmat'[`i',7] = r(Tbar)
				local t = `rmat'[`i',7]
				local t: display %12.1f `t'
				loc rown "`rown' `v'"
				display as text %12s abbrev("`v'",12) " {c |}" _c
				di as result _column(15) %9.4f `mean'  _column(28) %-9.4f `sd' _column(41) %-9.4f `sdw'  _column(54) %-9.4f `sdb' _column(66) `n' "/" `t'  _col(78) `N' 
			}
			di as text "{hline 13}{c BT}{hline 70}" 

			matrix colnames `rmat' = Mean SD B_SD W_SD Obs N T
			matrix rownames `rmat' = `rown'
			return matrix sum = `rmat'
			}
			
			
			
			
		***Test for cross-sectional dependence 
		if "`csd'" == "csd" {
			tokenize `csdopt'
			local csdoptp `csdopt'
			
			loc nvar : word count `varlist2'
			tempname cmat 			
			matrix `cmat' = J(`nvar', 4,.)
			loc i 0 
			di as text " "
			di as text "{bf:Cross-Sectional Dependence Test for Partial Sums}"
			di as text " "
			di as text "{hline 13}{c TT}{hline 75}" 
			di as text _col(14) "{c |}" _col(20) "CD-Test" _col(55) "Exponent"  
			di as text _col(14) "{c |}" " "
			di as text " Variables   {c |}" _col(17) "CD" _col(28) "p-value"  _col(42) "alpha"  _col(51) "Std. Err."  _col(63) "[95% Conf. Interval]" 
			di as text "{hline 13}{c +}{hline 75}" 
			local cv = invnorm(1 - ((100-95)/100)/2)
			foreach v of varlist `varlist2' {
				local ++i
				qui xtcse2 `v' if `touse', `csdoptp'
				matrix `cmat'[`i',1] = r(CD)
				matrix `cmat'[`i',2] = r(CDp)
				matrix `cmat'[`i',3] = r(alpha)
				matrix `cmat'[`i',4] = r(alphaSE)
				loc cown "`cown' `v'"
				di as text %12s abbrev("`v'",12) " {c |}" _c
				di as result _column(17) %-9.3f `cmat'[`i',1]  _column(28) %-9.3f `cmat'[`i',2] _column(42) %-9.3f `cmat'[`i',3]  _column(51) %-9.3f `cmat'[`i',4] _column(63) %-9.3f `cmat'[`i',3]-`cv'*`cmat'[`i',4] _column(74) %-9.3f `cmat'[`i',3]+`cv'*`cmat'[`i',4]
			}
			di as text "{hline 13}{c BT}{hline 75}" 
			di "CD and its p-value correspond to Pesaran's (2015) test for weak cross-sectional dependence."
			di "(H0: errors are cross-sectional dependent)."
			di "alpha corresponds to Bailey, Kapetanios, and Pesaran's (2016) estimation of the exponent of" 
			di "cross-sectional dependence."
			di "0.5 <= alpha < 1 implies strong cross-sectional dependence. See {help xtcse2}."
			matrix colnames `cmat' = CD p_value alpha al_SE
			matrix rownames `cmat' = `cown'
			return matrix csd = `cmat'	
			}
			
		
		***csd must be specified with csdopt. 
		if "`csd'" == "" & "`csdopt'" != ""  {
			di as error "csd must be specified."
			exit 198
		}	
			
			
		***Test for Non-Stationarity
		if "`cips'" != "" {
			loc nvar : word count `varlist2'
			tempname smat 
			matrix `smat' = J(`nvar', 4,.)
			tokenize `cips'
			local mlag `1'
			local blag `2'
			tokenize `cipsopt'
			local cipsoptp `cipsopt'
			loc i 0 
			di as text " "
			di as text "{bf:Non-Stationarity Test for Partial Sums}"
			di as text " "
			di as text "{hline 13}{c TT}{hline 70}" 
			di as text _col(14) "{c |}" _col(32) "Critical Values" _col(62) "Stationary?"  
			di as text _col(14) "{c |}" " "
			di as text " Variables   {c |}" _col(19) "CIPS" _col(29) "10%"  _col(38) "5%"  _col(47) "1%"  _col(59) "10%?"  _col(67) "5%?"  _col(75) "1%?" 
			di as text "{hline 13}{c +}{hline 70}" 
			foreach v of varlist `varlist2' {
				local ++i
				qui xtcips `v', maxlags(`mlag') bglags(`blag') `cipsoptp'
				matrix `smat'[`i',1] = r(cips)
				matrix `smat'[`i',2] = r(cv)[1,1]
				matrix `smat'[`i',3] = r(cv)[1,2]
				matrix `smat'[`i',4] = r(cv)[1,3]
				loc sown "`sown' `v'"
				loc dec10 = cond(abs(`smat'[`i',1]) >= abs(`smat'[`i',2]), .y, .)
				loc dec5 = cond(abs(`smat'[`i',1]) >= abs(`smat'[`i',3]), .y, .)
				loc dec1 = cond(abs(`smat'[`i',1]) >= abs(`smat'[`i',4]), .y, .)
				display as text %12s abbrev("`v'",12) " {c |}" _c
				di as result _column(11) %9.3f `smat'[`i',1]  _column(19) %9.2f `smat'[`i',2] _column(31) %9.2f `smat'[`i',3]  _column(42) %9.2f `smat'[`i',4] _column(60) `dec10' _column(68) `dec5' _column(76) `dec1'
			}
			
			di as text "{hline 13}{c BT}{hline 70}" 
			di as text "H0: Homogenous non-stationary; .y = stationary; . = non-stationary." 
			di as text "Critical values incorrect if missing data. See {help xtcips}."
			matrix colnames `smat' = cips .10 .05 .01
			matrix rownames `smat' = `sown'
			return matrix cips = `smat'	
			}
			
		
		***cips must be specified with cipsopt.
		if "`cips'" == "" & "`cipsopt'" != ""  {
			di as error "cips must be specified."
			exit 198
		}

			
			
			
		***Graph partial sums 
		if "`grsum'" == "grsum" {
			foreach v of varlist `varlist'{	
			tempvar diff2`v' pos2`v' neg2`v' p`v' n`v'
			qui gen double `diff2`v'' = d.`v' if `touse'
			qui gen double `pos2`v'' = `diff2`v''*(`diff2`v''>`th') if `touse'
			qui gen double `neg2`v'' = `diff2`v''*(`diff2`v''<`th') if `touse'			
			qui by `id' : gen `p`v'' = sum(`pos2`v'') if `touse'	
			qui label variable `p`v'' "Greather than `th' Sum"
			qui by `id' : gen `n`v'' = sum(`neg2`v'') if `touse'	
			qui label variable `n`v'' "Less than `th' Sum"
				if "`grssave'" != ""	{
				tokenize `grssave'
				local first `1'
				xtline `p`v'' `n`v'' if `touse', saving(`first') nodraw byopts(title("Partial Sums for `v'", size(medium))) byopts(note("")) legend(rows(1) size(*0.7))
		}
		else {
				xtline `p`v'' `n`v'' if `touse', saving(`v'_sums) nodraw byopts(title("Partial Sums for `v'", size(medium))) byopts(note("")) legend(rows(1) size(*0.7))
		}
			}
			}
			
			
			
			
		***Graph frequencies 	
		if "`grfre'" == "grfre" {
			foreach v of varlist `varlist'{
				tempvar dd`v' a`v' 
				qui gen `dd`v''= d.`v'
				qui gen `a`v'' = "Greater than `th'" if `dd`v''> `th' & `dd`v''!=.
				qui replace `a`v'' = "Less than `th'" if `dd`v''< `th'
				qui replace `a`v'' = "Equal to `th'" if `dd`v''== `th' 	
					if "`grfsave'" != ""	{
					tokenize `grfsave'
					local second `1'
					graph bar if `touse', over(`a`v'') by(`id', note("") title("Frequencies for `v'", size(medium))) asyvars saving(`second') legend(rows(1) size(*0.7)) ytitle("Percent") nodraw 
			}
			else {
				graph bar if `touse', over(`a`v'') by(`id', note("") title("Frequencies for `v'", size(medium))) asyvars saving(`v'_fre) legend(rows(1) size(*0.7)) ytitle("Percent") nodraw 	
			}
			}
			}
			

		
end






