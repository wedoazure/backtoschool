![alt text][logo]

# Back to School repository
This repo contains [Azure Back to School](https://azurebacktoschool.github.io/) related content, from ARM templates to Bicep to YAML. I will try to keep things organised! Most folders will be part of a blog post, or some sort of test.

## Quagga config
Configure Quagga virtual machine
Use Azure Bastion to connect with the admin details in the params file.

Once logged in, enter sudo su to switch to super user to avoid errors running the script. Copy the script above "quaggadeploy.sh" and paste it into the Bastion SSH session. The script will configure the virtual machine with Quagga along with other network settings. The script has been updated to fit this repo, feel free to update it to suit your network environment before running it on the virtual machine. It will take a few minutes for the script to complete the setup.

This is derived from the [Route Server tutorial.](https://docs.microsoft.com/en-us/azure/route-server/tutorial-configure-route-server-with-quagga?WT.mc_id=AZ-MVP-5003469)

I advise not to run this on anything but a test environment, code is presented as is.

## Requests
See a template that I have, that you need a modification of? Fork away! Similarly, if you see something that could, or should, be tweaked, submit a PR or Issue!

## Questions
If you have any, or would just like to follow me, you can find me on Twitter [@wedoAzure](https://twitter.com/wedoazure) and don't forget to use the hashtag [#AZNet](https://twitter.com/hashtag/AZNet)



[logo]: https://github.com/wedoazure/AZNet/raw/main/misc/wdLogo.png "WeDoAzure Logo"