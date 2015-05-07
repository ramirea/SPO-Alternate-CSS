##################################################################################################################################
#
# CSOM Connection - Start
#
#

# get site path and login credentials
$url = Read-Host "Enter site url"
$enteredCreds = Get-Credential
 
# reference CSOM lib
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

# note that you might need some other references (depending on what your script does) for example:
# Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Taxonomy.dll" 
 
# connect/authenticate to SPO and get ClientContext object 
$clientContext = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($enteredCreds.UserName, $enteredCreds.Password) 
$clientContext.Credentials = $credentials 
 
if (!$clientContext.ServerObjectIsNull.Value) 
{
    Write-Host "Connected to SharePoint Online site: '$Url'" -ForegroundColor Green 
} 

#
#
# CSOM Connection - End
#
##################################################################################################################################

# get site context
$site = $clientContext.Site

$clientContext.Load($site)
$clientContext.ExecuteQuery()

# get to root web and get list of all child webs
$rootWeb = $site.RootWeb
$webs = $rootWeb.Webs
$clientContext.Load($rootWeb)
$clientContext.Load($webs)

$clientContext.ExecuteQuery()

# path to css file - change this depending on what file you use
#$cssUrl = $rootWeb.ServerRelativeUrl + "/SiteAssets/css/sample.green.css"
#$cssUrl = "/SiteAssets/css/cos.tenant.css"
$cssUrl = ""

# set AlternateCssUrl value at root web
$clientContext.Web.AlternateCssUrl = $cssUrl
$clientContext.Web.Update()

function getWebs($web) {
    
    # recursive function - parses through webs to set the AlternateCssUrl value for each
    ####################################################################################

    $clientContext.Load($web)
    $web.AlternateCssUrl = $cssUrl
    $web.Update()

    $outputMessage = "DONE: " + $web.Url
    Write-Output $outputMessage

    # does this web have nested webs? if so, parse through them
    $nestedWebs = $web.Webs
    $clientContext.Load($nestedWebs)
    $clientContext.ExecuteQuery()

    # start recursing to parse through nested webs
    foreach ($web in $nestedWebs) {
        getWebs($web)
    }

}

# start updating the AlternateCssUrl value for each web
foreach ($web in $webs) {
    getWebs($web)
}

# are we done yet?
Write-Host "script completed" -ForegroundColor Green