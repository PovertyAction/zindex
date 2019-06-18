*! version 1.0.2 Caton Brewster 6.10.2019

program zindex, rclass
	/* 
	This program creates a z-score index. It allows you to specify vars to 
	standardize against (referred to as "mean" variables , e.g. baseline 
	verison of the vars). It also allows you to specify a condition 
	(e.g. "treatment == 0" if you want to standardize against control 
	participants). Must specify the name of the index you want to generate.
	*/
    version 13

	#d ;
	syntax varlist(numeric) [if] [in],
		/* optional specification of mean variables and a condition */
		[mean(varlist numeric) CONDition(string)]
		/* must specify name of new variable */
		gen(name)
		;
		#d cr
		
qui {
	marksample touse, novarlist

	//check that the size of the main varlist and the mean varlist are the same size if mean() has been specified
	if !missing("`mean'") {
		local main_vars_count: word count `varlist' 
		local mean_vars_count: word count `mean'
		cap confirm `main_vars_count' == `mean_vars_count' 
		if _rc {
			if `main_vars_count' > `mean_vars_count' { 
				di as err "Too few variables specified in mean() - must match number of variables in index" 
				err 102
			}
			if `main_vars_count' < `mean_vars_count' { 
				di as err "Too many variables specified in mean() - must match number of variables in index" 
				err 103
			}
		}
	}
	
	//save condition and if/in statements in a local 
	if !missing("`condition'") {
		local specifications `"if `condition' & `touse'"'
	}
		
	else {
		local specifications "if `touse'"
	}

	//check that the specifications are valid 
	foreach var of varlist `varlist' {
		cap sum `var' `specifications'
		if _rc {
			di as err `"The conditions you specified are invalid for variable, `var'. Unable to summarize `var' with the specified conditions: "sum `var' `specifications'" is invalid."' 
			err 119 
		}
		if `r(N)' == 0 {		
			di as err `"No observations for: "sum `var' `specifications'""' 
			err 119 
		}
	}
		
	if !missing("`mean'") {
		foreach var of varlist `mean' {
			cap sum `var' `specifications'
			if _rc {
				di as err `"The conditions you specificed are invalid for variable, `var'. Unable to summarize `var' with the specified conditions: "sum `var' `specifications'" is invalid."' 
				err 119 
			}
			if `r(N)' == 0 {
				di as err `"No observations for: "sum `var' `specifications'""' 
				err 119 
			}
		}
	}
	
	//check that variables have variance >0
	foreach var of varlist `varlist' {
		if !missing("`mean'") {
			local mean_`i': word `i' of `mean'
			qui summ `mean_`i'' `specifications', det	
			if `r(sd)' == 0 {
				di as err `"Variable `var' has variance 0"' 
				err 119 
			}
			local ++i
		}
		
		else {
			qui summ `var' `specifications', det	
			if `r(sd)' == 0 {
				di as err `"Variable `var' has variance 0"' 
				err 119 
			}
		}
	}
	
	//gen empty index (flags name if it already exists)	
	gen `gen' = .
	
	//create temp vars for program 
	local numvars: word count `varlist'
	forval v = 1 / `numvars' {
		tempvar z_`v'
	}
	tempvar z_index_mean 	
	tempvar num_mi_vars_in_index


	//gen z-scores for each var
	local i 1
	foreach var of varlist `varlist' {
		if !missing("`mean'") {
			local mean_`i': word `i' of `mean'
			qui summ `mean_`i'' `specifications', det			
			local ++i
		}
		
		else {
			qui summ `var' `specifications', det				 
		}
		local varnum: list posof "`var'" in varlist
		gen `z_`varnum'' = (`var' - `r(mean)') / `r(sd)' if `touse'
		local zscores `zscores' `z_`varnum''
		
		count if mi(`z_`varnum'') & `touse'
		return scalar m_`varnum' = `r(N)' 					
		local num_mi_obs_`varnum' = `r(N)' 							
	}
				
			
	//take z-score of the z-scores 			
	egen `z_index_mean' = rowmean(`zscores') if `touse'	
	qui summ `z_index_mean' `specifications', det		
	
	//fill index variable
	replace `gen' = (`z_index_mean' - `r(mean)')/`r(sd)' if `touse'
			
	//save num obs
	count if `touse'
	local tot_num_obs = `r(N)'

	//save info for return errors
	egen `num_mi_vars_in_index' = rowmiss(`varlist') if `touse'
	ta `num_mi_vars_in_index' if `touse', matcell(freq) matrow(combinations)
	local levelsof_num_mi_vars = rowsof(combinations)
	
	local tot_num_index_vars: word count `varlist'
}

	foreach var of varlist `varlist' {
		local varnum: list posof "`var'" in varlist
		if `num_mi_obs_`varnum'' > 0 {
			di in r `"`num_mi_obs_`varnum''/`tot_num_obs' missing values for `var' (stored in r(m_`varnum'))"'
		}
	}
	
	di ""	
	forval i = 1/`levelsof_num_mi_vars' {
		local x_num_index_vars = combinations[`i', 1]
		local obs_mi_x_num_index_vars = freq[`i', 1]
		if `obs_mi_x_num_index_vars' > 0 & `x_num_index_vars' > 0 {
			di in r "`obs_mi_x_num_index_vars' obs missing `x_num_index_vars'/`tot_num_index_vars' variable(s) in new index, `gen'"
		}
	}
	
	matrix drop freq

	end
