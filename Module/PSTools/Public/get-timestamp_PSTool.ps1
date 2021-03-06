<# 
 .SYNOPSIS 
 returns a timestamp in format yyyy-MM-DD_HH-mm-ss EG: 2018-11-29_10-41-17 

.DESCRIPTION 
 returns a timestamp in format yyyy-MM-DD_HH-mm-ss EG: 2018-11-29_10-41-17 

.EXAMPLE 
 get-PSTool_timestamp returns a timestamp in format yyyy-MM-DD_HH-mm-ss EG: 2018-11-29_10-41-17 

.NOTES 
 Author: Mentaleak 

#> 
function get-timestamp_PSTool () {
 
	$date = (Get-Date)

	return "$($date.year.toString("0000"))-$($date.Month.toString("00"))-$($date.Day.toString("00"))_$($date.Hour.toString("00"))-$($date.Minute.toString("00"))-$($date.Second.toString("00"))"
}
