# Deployment

## Build the docker images

    export GIT_CLONE_TOKEN=<YOUR_GITHUB_PERSONAL_TOKEN>

### Livestream Transcriber
  Go to the `decoding-sdk/` folder and run
  
     ./build_all_images.sh
     
  You should able to run the docker-compose.yaml file
  
  Or pull the docker image:

     echo $GIT_CLONE_TOKEN | docker login ghcr.io -u ntuspeechlab --password-stdin
     docker pull ghcr.io/ntuspeechlab/decoding-sdk:1.0
  

### Get the sample models
  
  Go to this link and download the [sample models](https://www.dropbox.com/sh/t4er3duqizbbxfs/AADMhYjUltQhDv9Of8Eh88TFa?dl=0)
  
  
### Test the docker-compose

Note: To use python3, recommend using python3.9
  
      python client3.py -u ws://localhost:8010/client/ws/speech -m "english" /path/to/audiofile.wav
  
  
