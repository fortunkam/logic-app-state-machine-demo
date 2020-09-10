# logic-app-state-machine-demo

To build the environment run the script in setup.ps1

You will end up with a resource group containing 3 logic apps, a storage account and a logic app connection to table storage.

When the script is completed you will have a url for one of the logic apps.  This can be dropped into the test.http script (uses the RestClient extension in VSCode to run).

The logic apps are...
The Base Workflow is the state machine
The Advance workflow moves the state machine through its states.
The Subscribe workflow gets the url used by the Advance workflow.



