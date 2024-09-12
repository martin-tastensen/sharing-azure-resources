# Update-default-modules

## Introduction
Experienced some issues with running the main script due to outdated AZ and MS graph modules. However, where I can use terraform to update the modules that terraform provides to the automation account, the default AZ modules provides a challenge.

Since these are default, and not deployed by terraform, I would have to import them to terraform which would most likely break eventually due to wrong version numbers. So the solution was to create a script in powershell to do it. 

The AZ versions are set static in the script, and will be updated in the repository when a new version is tested. 

I did consider getting the newest version from [powershell gallery](https://www.powershellgallery.com/) but decided against this since this way allows me to test the version.

### How to use
It's simple. The script is added as it's own runbook in the automation account. Permissions to update the modules are provided when running terraform. So all you have to do is run the runbook. 

Open the "update-az-modules" runbook, and select run. 

![Run update-module](https://www.mmt-consult.dk/wp-content/uploads/2024/09/run-update-default-module.png)

If a lot of modules are not correct, then it will take some time, but you can follow the status in the output section of the runbook job.

![Update default automation account modules](https://www.mmt-consult.dk/wp-content/uploads/2024/09/update-default-module.png)

To verify if it is complete, you can either run it again, which will check, or you can manually check all powershell 7.2 modules in the modules section of the automation account

![Verification module status](https://www.mmt-consult.dk/wp-content/uploads/2024/09/verify-module-status.png)

