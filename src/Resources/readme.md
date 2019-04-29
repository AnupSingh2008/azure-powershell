
---
## Generation Requirements
Use of the beta version of `autorest.powershell` generator requires the following:
- [NodeJS LTS](https://nodejs.org) (10.15.x LTS preferred)
  - **Note**: It *will not work* with Node < 10.x. Using 11.x builds may cause issues as they may introduce instability or breaking changes.
> If you want an easy way to install and update Node, [NVS - Node Version Switcher](../nodejs/installing-via-nvs.md) or [NVM - Node Version Manager](../nodejs/installing-via-nvm.md) is recommended.
- [AutoRest](https://aka.ms/autorest) v3 beta <br>`npm install -g autorest@beta`<br>&nbsp;
- PowerShell 6.0 or greater
  - If you don't have it installed, you can use the cross-platform npm package <br>`npm install -g pwsh`<br>&nbsp;
- .NET Core SDK 2.0 or greater
  - If you don't have it installed, you can use the cross-platform npm package <br>`npm install -g dotnet-sdk-2.2`<br>&nbsp;

## Run Generation
In this directory, run AutoRest:
> `autorest`

---
### AutoRest Configuration
> see https://aka.ms/autorest

``` yaml
require:
  - $(this-folder)/../readme.azure.md
  - $(repo)/specification/resources/resource-manager/readme.enable-multi-api.md
  - $(repo)/specification/resources/resource-manager/readme.md
  - $(repo)/specification/graphrbac/data-plane/readme.enable-multi-api.md
  - $(repo)/specification/graphrbac/data-plane/readme.md
  - $(repo)/specification/managementgroups/resource-manager/readme.enable-multi-api.md
  - $(repo)/specification/managementgroups/resource-manager/readme.md
  - $(repo)/specification/authorization/resource-manager/readme.enable-multi-api.md
  - $(repo)/specification/authorization/resource-manager/readme.md

subject-prefix: ''
module-version: 0.0.1
skip-model-cmdlets: true
title: Resources
profile:
  - hybrid-2019
  - latest-2019-04-01
directive:
  - where:
      subject: ApplicationDefinition(.*)
    set:
      subject: ManagedApplicationDefinition$1
  - where:
      verb: Get
      subject: Application
      variant: ^Get$|^Get1$|^GetSubscriptionIdViaHost$|^List$|^List1$|^ListSubscriptionIdViaHost$|^ListSubscriptionIdViaHost1$
    set:
      subject: ManagedApplication
  - where:
      verb: New
      subject: Application
      variant: ^Create$|^Create1$|^CreateExpanded$|^CreateExpanded1$|^CreateSubscriptionIdViaHost$|^CreateSubscriptionIdViaHostExpanded$
    set:
      subject: ManagedApplication
  - where:
      verb: Remove
      subject: Application
      variant: ^Delete$|^Delete1$|^DeleteSubscriptionIdViaHost$
    set:
      subject: ManagedApplication
  - where:
      verb: Set
      subject: Application
    set:
      subject: ManagedApplication
  - where:
      verb: Update
      subject: Application
      variant: ^Update
    set:
      subject: ManagedApplication
  - where:
      verb: Get
      subject: Application
      variant: ^Get2$|^List2$
    set:
      subject: ADApplication
  - where:
      verb: New
      subject: Application
      variant: ^Create2$|^CreateExpanded2$
    set:
      subject: ADApplication
  - where:
      verb: Remove
      subject: Application
      variant: ^Delete2$
    set:
      subject: ADApplication
  - where:
      verb: Update
      subject: Application
      variant: ^Patch
    set:
      subject: ADApplication
  - where:
      subject: ^Feature(.*)
    set:
      subject: ProviderFeature$1
  - where:
      subject: ^DeletedApplication(.*)
    set:
      subject: ADDeletedApplication$1
  - where:
      subject: ^Group(.*)
    set:
      subject: ADGroup$1
  - where:
      subject: ^Object
    set:
      subject: ADObject
  - where:
      subject: ^ServicePrincipal(.*)
    set:
      subject: ADServicePrincipal$1
  - where:
      subject: ^User(.*)
    set:
      subject: ADUser$1
  - where:
      parameter-name: ApplicationObjectId
    set:
      parameter-name: ObjectId
  - where:
      subject: Resource
      parameter-name: GroupName
    set:
      parameter-name: ResourceGroupName
  - where:
      subject: Resource
      parameter-name: Id
    set:
      parameter-name: ResourceId
  - where:
      subject: Resource
      parameter-name: Type
    set:
      parameter-name: ResourceType
  - where:
      subject: Appliance*
    remove: true
  - where:
      verb: Get
      subject: Subscription
    remove: true

```