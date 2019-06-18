{smcl}
{* *! version 1.0.0 Caton Brewster 03Mar2017}{...}
{title:Title}

{phang}
{cmd:zindex} {hline 2}
Generates a index using z-scores

{marker syntax}{...}
{title:Syntax}

{p 8 10 2}
{cmd:zindex} {it:{help varlist}} {ifin}{cmd:,}
{opth gen(varname)} [{it:options}]


{* Using -help odbc- as a template.}{...}
{* 20 is the position of the last character in the first column + 3.}{...}
{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{* Using -help heckman- as a template.}{...}

{p2coldent:* {opth gen(varname)}}Name of index variable to be created {p_end}

{syntab:Optional}

{p2coldent:* {opth mean(varlist)}}Variables that will be used
to standardize against (e.g. baseline versions of main varlist){p_end}

{p2coldent:* {opth condition(string)}}A condition to specify
a sub-group to standardize against (e.g. control group){p_end}


{title:Description}

{pstd}
{cmd:zindex} creates a z-score index. The resulting index is the z-score of the 
mean of each index components' z-scores.  Steps of index creation: 

{col 5}1. {col 12}Generate z-scores for each variable included in the index

{col 5}2. {col 12}Generate means of these z-scores

{col 5}3. {col 12}Create index by generating the z-score for the means of these z-scores

{phang2}
The {cmd:mean()} option allows you to specify a list of variables to standardize 
against. The means and SDs of this varlist will be used in the initial z-scores
(in step 1 above) instead of the means and SDs of the main varlist specified for the
index. The size of this varlist must be the same size as the main varlist 
specified for index. A common input is a list of the baseline versions of the 
index variables to standardize against the baseline values. 

{phang2}
The {cmd:condition()} option allows you to specify a subgroup to standardize against. 
The condition is applied when taking the mean and SD of each variable going 
into the index (in step 1 above) and when taking the mean and SD of the means of 
the z-scores (in step 3 above).  A common condition is "treatment == 0" to 
standardize against the control group.

{phang2}
{ifin} restricts the sample used for ALL STEPS to the observations that meet the 
if/in condition. If {opt:condition()} is specified, only the observations that fulfill
both {opt:condition()} and the if/in condition is used to calculate the mean
and standard deviation for standardization.

{pstd}
The GitHub repository for {cmd:zindex} is
{browse "https://github.com/PovertyAction/DT-Programs/blob/master/zindex.ado":here}.
Previous versions may be found there: see the tags.



{marker examples}{...}
{title:Examples}

	{cmd: sysuse citytemp.dta}

{pstd}
Create an index of heat, not standardized against a different round or subgroup{p_end}{cmd}{...}

	{cmd: zindex tempjan tempjuly heatdd, gen(hot_weather)}

{pstd}
Standardize against the Northeast {p_end}{cmd}{...}

	{cmd: zindex tempjan tempjuly heatdd, gen(hot_weather_NE) condition(region == 1)}
	
{pstd}
Calculate the index only for the Northeast. Note that hot_weather_NE and hot_weather_NE_only
are the same for all cities in the Northeast, but hot_weather_NE_only does not 
have any values for cities outside of the Northeast.{p_end}{cmd}{...}

	{cmd: zindex tempjan tempjuly heatdd if region == 1, gen(hot_weather_NE_only)

{pstd}
Standardize against January temperatures and days of cold {p_end}{cmd}{...}

	{cmd: zindex tempjuly heatdd, gen(hot_weather_NE) mean(tempjan cooldd)}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:readreplace} stores the following in {cmd:r()}:

{* Using -help spearman- as a template.}{...}
{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(m_VAR)}}number of missing observations in VAR (one return value per 
variable in the index){p_end}   


{marker authors}{...}
{title:Authors}

{pstd}Caton Brewster{p_end}
{pstd}Codecheck: Kelsey Larson{p_end}

{pstd}For questions or suggestions, submit a
{browse "https://github.com/PovertyAction/DT-Programs/issues":GitHub issue}
with "zindex" in the title or e-mail researchsupport@poverty-action.org.{p_end}

