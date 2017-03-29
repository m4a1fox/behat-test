# PK License iFrame #

### How to configure ###

1. Download the source from this repository
2. Edit the index.php file, and add the following information
    *Replace YourAPIKey with your Paykickstart API key, located in your Platform Settings* 
    *Change the campaign id to your actual campaign id that you want to display license keys for*

### How to use ###
You can now create an iframe in whichever file you're using the license manager on with the source pointing to the index.php file, and include an email parameter which is your customer's actual email address. For example

`<iframe width="100%" height="400px” src=”index.php?email=<insert-yourcustomers-email-address-here>” />`