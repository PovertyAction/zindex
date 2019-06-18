cscript zindex

sysuse citytemp.dta

*test 1: basic index
	zindex tempjan tempjuly heatdd, gen(hot_weather)
	count if missing(hot_weather)
	assert `r(N)' == 2
	sum hot_weather
	assert abs(`r(sd)' - 1) < .000001
	assert abs(`r(mean)' - 0) < .000001

*test 2: "condition" and "if" produce same results for subsample
	zindex tempjan tempjuly heatdd, gen(hot_weather_NE) condition(region == 1)
	zindex tempjan tempjuly heatdd if region == 1, gen(hot_weather_NE_only)
	
	assert hot_weather_NE == hot_weather_NE_only if region == 1
	assert missing(hot_weather_NE_only) if region != 1
	
*test 3: Test mean option functionality
	zindex tempjuly heatdd, gen(hot_weather_mean) mean(tempjan cooldd)

*test 4: Program doesn't run if one of the variables is empty or doesn't exist
	drop hot_weather*
	rcof "zindex tempjuly imaginary, gen(hot_weather_1)" == 111
	rcof "zindex tempjan tempjuly, gen(hot_weather_2) mean(imaginary tempjan)" == 111
	rcof `"zindex tempjuly tempjan, gen(hot_weather_5) condition(imaginary == 5)"' == 119
	gen emptyvar = .
	rcof "zindex tempjan tempjuly emptyvar, gen(hot_weather_3)" == 119
	rcof "zindex tempjan tempjuly, gen(hot_weather_4) mean(heatdd emptyvar)" == 119
	rcof "zindex tempjuly tempjan, gen(hot_weather_16) condition(region = 1)" == 119
	
*test 5: wrong number of variables in mean
	rcof "zindex tempjan, gen(hot_weather_1) mean(tempjan tempjuly)" == 103
	rcof "zindex tempjan tempjuly, gen(hot_weather_10) mean(tempjan)" == 102
	
*test 6: doesn't run if the condition is too restrictive
	rcof "zindex tempjuly tempjan, gen(hot_weather_16) condition(region == 5)" == 119
	
	
