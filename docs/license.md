# Licenses
Licenses can be automatically uploaded to the stack.


## API Portal
During the API Portal installation, a Kubernetes job uploads the license file into the API Portal instance. The job uses the API Portal UMC API to upload the license file. The license file should be stored within the files folder of the API Portal chart (`charts/sag-apiportal/files`) with filename `license.xml`.


## API Gateway
The API Gateway uses a trail license with a validity of 90days. You can also use your own license by setting the Helm value `apigateway.license.useYourOwnLicense` to `true` and by putting a license file in the files folder of the API Gateway chart (`charts/sag-apigateway/files`).