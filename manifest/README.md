# Manifest

This including details of what will be deployed to cloud.

To create manifest, you can type following command:

    cd onestop-speech-cloud-deployment/
    helm template task-controller charts/taskcontroller/ --output-dir manifest/
