# zindex
<pre>
<b><u>Title</u></b>
<p>
    <b>zindex</b> -- Generates an index using z-scores
<p>
<a name="syntax"></a><b><u>Syntax</u></b>
<p>
        <b>zindex</b> <i>varlist</i> [<i>if</i>] [<i>in</i>]<b>,</b> <b>gen(</b><i>varname</i><b>)</b> [<i>options</i>]
<p>
<p>
    <i>options</i>               Description
    -------------------------------------------------------------------------
    Main
<p>
    * <b>gen(</b><i>varname</i><b>)</b>        Name of index variable to be created
<p>
    Optional
<p>
    * <b>mean(</b><i>varlist</i><b>)</b>       Variables that will be used to standardize against
                            (e.g. baseline versions of main varlist)
<p>
    * <b>condition(</b><i>string</i><b>)</b>   A condition to specify a sub-group to standardize
                            against (e.g. control group)
<p>
<p>
<b><u>Description</u></b>
<p>
    <b>zindex</b> creates a z-score index. The resulting index is the z-score of the
    mean of each index components' z-scores.  Steps of index creation:
<p>
    1.     Generate z-scores for each variable included in the index
<p>
    2.     Generate means of these z-scores
<p>
    3.     Create index by generating the z-score for the means of these z-scores
<p>
        The <b>mean()</b> option allows you to specify a list of variables to
            standardize against. The means and SDs of this varlist will be
            used in the initial z-scores (in step 1 above) instead of the
            means and SDs of the main varlist specified for the index. The
            size of this varlist must be the same size as the main varlist
            specified for index. A common input is a list of the baseline
            versions of the index variables to standardize against the
            baseline values.
<p>
        The <b>condition()</b> option allows you to specify a subgroup to
            standardize against.  The condition is applied when taking the
            mean and SD of each variable going into the index (in step 1
            above) and when taking the mean and SD of the means of the
            z-scores (in step 3 above).  A common condition is "treatment ==
            0" to standardize against the control group.
<p>
        [<i>if</i>] [<i>in</i>] restricts the sample used for ALL STEPS to the observations
            that meet the if/in condition. If {opt:condition()} is specified,
            only the observations that fulfill both {opt:condition()} and the
            if/in condition is used to calculate the mean and standard
            deviation for standardization.
<p>

<a name="examples"></a><b><u>Examples</u></b>
<p>
         sysuse citytemp.dta 
<p>
    <b> Create an index of heat, not standardized against a different round or
    subgroup </b>
<p>
         zindex tempjan tempjuly heatdd, gen(hot_weather)
<p>
    <b>Standardize against the Northeast</b>
<p>
         zindex tempjan tempjuly heatdd, gen(hot_weather_NE) condition(region == 1)
<b>        </b>
    <b>Calculate the index only for the Northeast. Note that hot_weather_NE and</b>
    <b>hot_weather_NE_only are the same for all cities in the Northeast, but</b>
    <b>hot_weather_NE_only does not have any values for cities outside of the</b>
    <b>Northeast.</b>
<p>
        zindex tempjan tempjuly heatdd if region == 1, gen(hot_weather_NE_only)
<p>
    <b>Standardize against January temperatures and days of cold</b>
<p>
         zindex tempjuly heatdd, gen(hot_weather_NE) mean(tempjan cooldd)
<p>
<a name="results"></a><b><u>Stored results</u></b>
<p>
    <b>zindex stores the following in r():</b>
<p>
    <b>Scalars   </b>
      <b>r(m_VAR)       number of missing observations in VAR (one return value</b>
                       <b>per variable in the index)</b>
<b>   </b>
<p>
<p>
<a name="authors"></a><b><u>Authors</u></b>
<p>
    <b>Caton Brewster</b>
    <b>Isabel Onate</b>
    <b>Codecheck: Kelsey Larson</b>
<p>
    <b>For questions or suggestions, submit a </b>GitHub issue<b> or e-mail researchsupport@poverty-action.org.</b>
<p>
</pre>

zindex was developed by the [Global Poverty Research Lab at Northwestern University](https://poverty-research.buffett.northwestern.edu/), with support from [Innovations for Poverty Action](https://www.poverty-action.org/). 

