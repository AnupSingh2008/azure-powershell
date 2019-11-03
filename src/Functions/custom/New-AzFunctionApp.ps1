
function New-AzFunctionApp {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Functions.Models.Api20180201.ISite])]
    [Microsoft.Azure.PowerShell.Cmdlets.Functions.Description('Creates a function app.')]
    [CmdletBinding(SupportsShouldProcess=$true, DefaultParametersetname="ByAppServicePlan")]
    param(        
        [Parameter(ParameterSetName="Consumption", HelpMessage='The Azure subscription ID.')]
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        ${SubscriptionId},
        
        [Parameter(Mandatory=$true, ParameterSetName="Consumption", HelpMessage='The name of the resource group.')]
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [ValidateNotNullOrEmpty()]
        [System.String]
        ${ResourceGroupName},
        
        [Parameter(Mandatory=$true, ParameterSetName="Consumption", HelpMessage='The name of the function app.')]
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [ValidateNotNullOrEmpty()]
        [System.String]
        ${Name},
        
        [Parameter(Mandatory=$true, ParameterSetName="Consumption", HelpMessage='The name of the storage account.')]
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [ValidateNotNullOrEmpty()]
        [System.String]
        ${StorageAccountName},        

        [Parameter(ParameterSetName="Consumption", HelpMessage='Name of the existing App Insights project to be added to the function app.')]
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [ValidateNotNullOrEmpty()]
        [System.String]
        [Alias("AppInsightsName")]
        ${ApplicationInsightsName},

        [Parameter(ParameterSetName="Consumption", HelpMessage='Instrumentation key of App Insights to be added.')]
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [ValidateNotNullOrEmpty()]
        [System.String]
        [Alias("AppInsightsKey")]
        ${ApplicationInsightsKey},

        [Parameter(Mandatory=$true, ParameterSetName="Consumption", HelpMessage='The location for the consumption plan.')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        ${Location},

        [Parameter(Mandatory=$true, ParameterSetName="ByAppServicePlan", HelpMessage='The name of the service plan.')]
        [ValidateNotNullOrEmpty()]
        [System.String]
        ${PlanName},

        [Parameter(Mandatory=$true, ParameterSetName="ByAppServicePlan", HelpMessage='The OS to host the function app.')]
        [Parameter(ParameterSetName="Consumption")]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.Functions.Support.WorkerType])]
        [ValidateNotNullOrEmpty()]
        [System.String]
        # OS type (Linux or Windows)
        ${OSType},
        
        [Parameter(Mandatory=$true, ParameterSetName="ByAppServicePlan", HelpMessage='The function runtime.')]
        [Parameter(ParameterSetName="Consumption")]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.Functions.Support.RuntimeType])]
        [ValidateNotNullOrEmpty()]
        [System.String]
        # Runtime type (DotNet, Node, Java, PowerShell or Python
        ${Runtime},

        [Parameter(ParameterSetName="ByAppServicePlan", HelpMessage='Disable creating application insights resource during the function app creation. No logs will be available.')]
        [Parameter(ParameterSetName="Consumption")]
        [System.Management.Automation.SwitchParameter]
        [Alias("DisableAppInsights")]
        ${DisableApplicationInsights},
        
        [Parameter(ParameterSetName="ByAppServicePlan")]
        [Parameter(ParameterSetName="Consumption", HelpMessage='Returns true when the command succeeds.')]
        [System.Management.Automation.SwitchParameter]
        ${PassThru},

        <#
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${NoWait},
        
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        ${AsJob},
        #>
        
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Azure')]
        [System.Management.Automation.PSObject]
        ${DefaultProfile},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Functions.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
)
    process {

        if ($PSBoundParameters.ContainsKey("AsJob"))
        {
            $null = $PSBoundParameters.Remove("AsJob")

            $modulePath = Join-Path $PSScriptRoot "../Az.Functions.psd1"

            Start-Job -ScriptBlock {
                param($arg, $modulePath)
                Import-Module $modulePath
                Az.Functions\New-AzFunctionApp @arg
            } -ArgumentList $PSBoundParameters, $modulePath
        }

        else 
        {
            # Remove bound parameters from the dictionary that cannot be process by the intenal cmdlets.
            $paramsToRemove = @(
                "StorageAccountName",
                "ApplicationInsightsName",
                "ApplicationInsightsKey",
                "Location",
                "PlanName",
                "OSType",
                "Runtime",
                "DisableApplicationInsights"
            )
            foreach ($paramName in $paramsToRemove)
            {
                if ($PSBoundParameters.ContainsKey($paramName))
                {
                    $null = $PSBoundParameters.Remove($paramName)
                }
            }

            ValidateFunctionName -Name $Name

            $appSettings = New-Object -TypeName System.Collections.Generic.List[System.Object]
            $siteCofig = New-Object -TypeName Microsoft.Azure.PowerShell.Cmdlets.Functions.Models.Api20180201.SiteConfig
            $functionAppDef = New-Object -TypeName Microsoft.Azure.PowerShell.Cmdlets.Functions.Models.Api20180201.Site
            
            $servicePlan = $null

            $OSIsLinux = $OSType -eq "Linux"
            $consumptionPlan = $PsCmdlet.ParameterSetName -eq "Consumption"
            
            if ($consumptionPlan)
            {
                ValidateConsumptionPlanLocation -Location $Location
                $functionAppDef.Location = $Location
            }
            else 
            {
                # App with SKU based plan
                $servicePlan = GetServicePlan $PlanName
                if (-not $servicePlan)
                {
                    $errorMessage = "Service plan '$PlanName' does not exist."
                    $exception = [System.InvalidOperationException]::New($errorMessage)
                    ThrowTerminatingError -ErrorId "ServicePlanDoesNotExist" `
                                        -ErrorMessage $errorMessage `
                                        -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                        -Exception $exception
                }

                if ($null -ne $servicePlan.Location)
                {
                    $Location = $servicePlan.Location
                }

                if ($null -ne $servicePlan.Reserved)
                {
                    $OSIsLinux = $servicePlan.Reserved
                }

                $functionAppDef.ServerFarmId = $servicePlan.Id
                $functionAppDef.Location = $Location
            }

            # Validate runtime
            ValidateRuntime -Runtime $Runtime -OSIsLinux:$OSIsLinux

            $runtimeName = GetRuntimeName -Runtime $Runtime
            $runtimeVersion = GetRuntimeVersion -Runtime $Runtime

            $runtimeWorker = $runtimeName.ToLower()
            $appSettings.Add((NewAppSetting -Name 'FUNCTIONS_WORKER_RUNTIME' -Value "$runtimeWorker"))

            if ($OSIsLinux)
            {
                # Linux function app            
                $functionAppDef.Kind = 'functionapp,linux'
                $functionAppDef.Reserved = $true

                if (-not $consumptionPlan)
                {
                    $appSettings.Add((NewAppSetting -Name 'WEBSITES_ENABLE_APP_SERVICE_STORAGE' -Value 'true'))
                }

                $siteCofig.LinuxFxVersion = GetLinuxFxVersion -RuntimeName $runtimeName -RuntimeVersion $runtimeVersion -IsConsumption:$consumptionPlan
            }
            else 
            {
                # Windows function app
                $functionAppDef.Kind = 'functionapp'
            }

            # Validate storage account and get connection string
            $connectionStrings = GetConnectionString -StorageAccountName $StorageAccountName

            # Set the default Host version.
            $appSettings.Add((NewAppSetting -Name 'FUNCTIONS_EXTENSION_VERSION' -Value $DefaultHostRuntimeVersion))
            $appSettings.Add((NewAppSetting -Name 'AzureWebJobsStorage' -Value $connectionStrings))
            $appSettings.Add((NewAppSetting -Name 'AzureWebJobsDashboard' -Value $connectionStrings))

            # Set default Node version
            $defaultNodeVersion = GetFunctionAppDefaultNodeVersion -Runtime $runtimeName -RuntimeVersion $runtimeVersion
            $appSettings.Add((NewAppSetting -Name 'WEBSITE_NODE_DEFAULT_VERSION' -Value $defaultNodeVersion))

            # If plan is not consumption or elastic premium, set always on
            $planIsElasticPremium = $servicePlan.SkuTier -eq 'ElasticPremium'
            if ((-not $consumptionPlan) -and $planIsElasticPremium)
            {
                $siteCofig.AlwaysOn = $true
            }

            # If plan is elastic premium or windows consumption, we need these app settings
            $IsWindowsConsumption = $consumptionPlan -and (-not $OSIsLinux)

            if ($planIsElasticPremium -or $IsWindowsConsumption)
            {
                $appSettings.Add((NewAppSetting -Name 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING' -Value $connectionStrings))
                $appSettings.Add((NewAppSetting -Name 'WEBSITE_CONTENTSHARE' -Value $Name.ToLower()))
            }

            if (-not $DisableAppInsights)
            {
                if ($ApplicationInsightsKey)
                {
                    $appSettings.Add((NewAppSetting -Name 'APPINSIGHTS_INSTRUMENTATIONKEY' -Value $ApplicationInsightsKey))
                }
                elseif ($ApplicationInsightsName)
                {
                    $appInsightsProject = GetApplicationInsightsProject -Name $ApplicationInsightsName
                    if (-not $appInsightsProject)
                    {
                        $errorMessage = "Failed to get application insights key for project name '$ApplicationInsightsName'. Please make sure the project exist."
                        $exception = [System.InvalidOperationException]::New($errorMessage)
                        ThrowTerminatingError -ErrorId "ApplicationInsightsProjectNotFound" `
                                            -ErrorMessage $errorMessage `
                                            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                            -Exception $exception
                    }

                    $appSettings.Add((NewAppSetting -Name 'APPINSIGHTS_INSTRUMENTATIONKEY' -Value $appInsightsProject.InstrumentationKey))
                }
                else
                {
                    # Create a new ApplicationInsights
                    try 
                    {
                        $newAppInsightsProject = Az.Functions.internal\New-AzAppInsights -ResourceGroupName $resourceGroupName `
                                                                                        -ResourceName $Name  `
                                                                                        -Location $functionAppDef.Location `
                                                                                        -Kind web `
                                                                                        -RequestSource "AzurePowerShell" `
                                                                                        -ErrorAction Stop
                        if ($newAppInsightsProject)
                        {
                            $appSettings.Add((NewAppSetting -Name 'APPINSIGHTS_INSTRUMENTATIONKEY' -Value $newAppInsightsProject.InstrumentationKey))
                        }                    
                    }
                    catch
                    {
                        $warningMessage = 'Unable to create the Application Insights for the Function App. Please use the Azure Portal to manually create and configure the Application Insights, if needed.'
                        Write-Warning $warningMessage
                    }
                }
            }       

            # Set app settings and site configuration
            $siteCofig.AppSetting = $appSettings
            $functionAppDef.Config = $siteCofig
            $null = $PSBoundParameters.Add("SiteEnvelope", $functionAppDef)

            # Run the command with -NoWait
            if ($PSBoundParameters.ContainsKey("NoWait"))
            {
                $null = $PSBoundParameters.Remove("NoWait")
                Az.Functions.internal\New-AzFunctionApp @PSBoundParameters
            }
            else
            {
                # Create function app without AsJob and NoWait params
                $null = $PSBoundParameters.Add("ErrorAction", "Stop")

                try
                {
                    $createdFunctionApp = Az.Functions.internal\New-AzFunctionApp @PSBoundParameters

                    if ($createdFunctionApp)
                    {
                        $createdFunctionApp.OSType = $OSType
                        $createdFunctionApp.HostVersion = "$DefaultHostRuntimeVersion"

                        if ($runtimeName)
                        {
                            $createdFunctionApp.RuntimeName = $RuntimeToFormattedName[$runtimeName]
                        }

                        if ($PlanName)
                        {
                            $createdFunctionApp.AppServicePlan = $PlanName
                        }

                        if ($consumptionPlan)
                        {
                            $warningMessage = "Your Linux function app '$Name', that uses a consumption plan has been successfully created but is not active until content is published using Azure Portal or the Functions Core Tools."
                            Write-Warning $warningMessage
                        }

                        $createdFunctionApp
                    }
                }
                catch
                {
                    $errorMessage = GetErrorMessage -Response $_
                    if ($errorMessage)
                    {
                    $exception = [System.InvalidOperationException]::New($errorMessage)            
                        ThrowTerminatingError -ErrorId "FailedToCreateFunctionApp" `
                                            -ErrorMessage $errorMessage `
                                            -ErrorCategory ([System.Management.Automation.ErrorCategory]::InvalidOperation) `
                                            -Exception $exception
                    }

                    throw $_
                }
            } 
        }        
    }
}
