*! Version1.0 Ryan Thombs 4/23/22


program define xtasysum, rclass sortpreserve
        version 17
 
        syntax varlist(min=1 numeric ts) [if] [in] [, Threshold(real 0) Frequency Sum fd al GRSum GRFre csd NOgen] 
		
		*Ensure xtset
		qui cap xtset
		if "`r(panelvar)'" == "" | "`r(timevar)'" == "" {
		display as error "The data must be xtset."
		exit 198
		}
		
		
		loc id = r(panelvar)
		loc time = r(timevar)
		
		
		marksample touse
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
			by `id' : gen `v'_p = sum(`pos`v'') if `touse'			
			qui label variable `v'_p "Positive sum for `v' (greater than `th')"			
			by `id' : gen `v'_n = sum(`neg`v'') if `touse'			
			qui label variable `v'_n "Negative sum for `v' (less than `th')"			
			loc varlist2 "`varlist2' `v'_p `v'_n"			
			}		
		}
		else {			
			loc varlist2 "`varlist2' `varlist'"
		}
		
		
		
		if "`nogen'" != "" & `th' != 0  {
			di as error "The options nogen and threshold can't both be specified."
			exit 198
		}
			
		
		
			
		if "`frequency'" == "frequency" {
			tempname fmat 
			loc nvar : word count `varlist'
			matrix `fmat' = J(`nvar', 7,.)					
			loc i 0 
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
				local pos_per: display %12.2f `pos_per'
				
				local neg_per = (`neg'/`colt')*100
				local neg_per: display %12.2f `neg_per'
				
				local zero_per = (`zero'/`colt')*100
				local zero_per: display %12.2f `zero_per'
			
				matrix `fmat'[`i',1] = `pos'
				matrix `fmat'[`i',2] = `pos_per'
				matrix `fmat'[`i',3] = `neg'
				matrix `fmat'[`i',4] = `neg_per'
				matrix `fmat'[`i',5] = `zero'
				matrix `fmat'[`i',6] = `zero_per'
				matrix `fmat'[`i',7] = `colt'
				loc fown "`fown' `v'"
				}
			
			matrix colnames `fmat' = (+) +_Per. (-) -_Per. (0) 0_Per. Obs
			matrix rownames `fmat' = `fown'
			matlist `fmat', border(rows) title({bf:Frequencies of Partial Sums}) rowtitle(Variables)
			display as text "Per. = Percent of Total"
			return matrix fre = `fmat'	
		}
			
			

		if "`nogen'" != "" & "`frequency'" != ""  {
			di in red "Warning:" 
			di as text "nogen and frequency are specified together-are you sure you want that?"
		}
		
		
				
		***Calculate first difference 
		if "`fd'" == "fd" {
			foreach v of varlist `varlist'{	
				qui gen double `v'_d = d.`v' if `touse'
				qui label variable `v'_d "First differences for `v'"
			}
			}
			
			
		***Generate variables based on Allison (2019) defintion 
		if "`al'" == "al"{
			foreach v of varlist `varlist'{	
				tempvar diff`v'
				qui gen double `diff`v'' = d.`v' if `touse'
				qui gen double `v'_pal = `diff`v''*(`diff`v''>`th') if `touse'
				qui label variable `v'_pal "Positive change for `v' (greater than `th') using Allison's (2019) definition"
				qui gen double `v'_nal = `diff`v''*(`diff`v''<`th') if `touse'
				qui label variable `v'_nal "Negative change for `v' (less than `th') using Allison's (2019) definition"
			}
			}
			
			
		***Summarize variables 
		if "`sum'" == "sum" {
			loc nvar : word count `varlist2'
			tempname rmat 
			matrix `rmat' = J(`nvar', 7,.)					
			loc i 0 
			foreach v of varlist `varlist2' {
				local ++i
				qui xtsum `v' if `touse' 
				matrix `rmat'[`i',1] = r(mean)
				matrix `rmat'[`i',2] = r(sd)
				matrix `rmat'[`i',3] = r(sd_b)
				matrix `rmat'[`i',4] = r(sd_w)
				matrix `rmat'[`i',5] = r(N)
				matrix `rmat'[`i',6] = r(n)
				matrix `rmat'[`i',7] = r(Tbar)
				loc rown "`rown' `v'"
			}

			matrix colnames `rmat' = Mean SD B_SD W_SD Obs N T
			matrix rownames `rmat' = `rown'
			matlist `rmat', border(rows) title({bf:Summary Statistics for Partial Sums}) rowtitle(Variables) showcoleq(combined)
			display as text "B_SD = between standard deviation and W_SD = within standard deviation."
			return matrix sum = `rmat'
			}
			
			
			
			if "`csd'" == "csd" {
			loc nvar : word count `varlist2'
			tempname cmat 			
			matrix `cmat' = J(`nvar', 4,.)
			loc i 0 
			foreach v of varlist `varlist2' {
				local ++i
				qui xtcse2 `v' if `touse'
				matrix `cmat'[`i',1] = r(CD)
				matrix `cmat'[`i',2] = r(CDp)
				matrix `cmat'[`i',3] = r(alpha)
				matrix `cmat'[`i',4] = r(alphaSE)
				loc cown "`cown' `v'"
			}
			matrix colnames `cmat' = CD:CD CD:p-value Exponent:alpha Exponent:alpha_SE
			matrix rownames `cmat' = `cown'
			matlist `cmat', border(rows) title({bf:Cross-Sectional Dependence Test for Partial Sums}) rowtitle(Variables) format(%12.3f)
			di "CD and its p-value correspond to Pesaran's (2015) test for weak cross-sectional dependence."
			di "(H0: errors are cross-sectional dependent)."
			di "alpha corresponds to Bailey, Kapetanios, and Pesaran's (2016) estimation of the exponent of cross-sectional dependence."
			di "0.5 <= alpha < 1 implies strong cross-sectional dependence."
			return matrix csd = `cmat'	
			}
			
			
		***Graph partial sums 
		if "`grsum'" == "grsum" {
			foreach v of varlist `varlist'{	
			tempvar diff2`v' pos2`v' neg2`v' p`v' n`v'
			qui gen double `diff2`v'' = d.`v' if `touse'
			qui gen double `pos2`v'' = `diff2`v''*(`diff2`v''>`th') if `touse'
			qui gen double `neg2`v'' = `diff2`v''*(`diff2`v''<`th') if `touse'			
			qui by `id' : gen `p`v'' = sum(`pos2`v'') if `touse'				
			qui by `id' : gen `n`v'' = sum(`neg2`v'') if `touse'			
				xtline `p`v'' `n`v'' if `touse', saving(`v'_sums, replace) nodraw byopts(title("Partial Sums for `v'", size(medium))) byopts(note("")) legend(rows(1) size(*0.7)) `options'
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
				graph bar if `touse', over(`a`v'') by(`id', note("") title("Frequencies for `v'", size(medium))) asyvars saving(`v'_fre, replace) legend(rows(1) size(*0.7)) ytitle("Percent") nodraw 
			}

			}
			

		
end







