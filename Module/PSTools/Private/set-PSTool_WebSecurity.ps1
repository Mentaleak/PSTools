function set-PSTool_WebSecurity () {
 <# 
 #>    

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
