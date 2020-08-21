# logic-app-state-machine-demo

To build the environment run the script in setup.ps1

You will end up with a resource group containing 3 logic apps, a storage account and a logic app connection to table storage.

When the script is completed you will have 2 urls.  One to start the workflow, the other to advance it through the states.

The logic apps are...
The Base Workflow is the state machine
The Advance workflow moves the state machine through its states.
The Subscribe workflow gets the url used by the Advance workflow.



