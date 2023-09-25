IMAGE_NAME="env_analysis:ubuntu-22.04-base"

docker run --rm -it \
    --privileged \
    --shm-size 50G \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    -e PYTHONPATH=/home/developer/transformers:/home/developer/transformers/experiments/minigrid/dependencies/gym-minigrid:/home/developer/transformers/experiments/minigrid/dependencies/torch-ac \
    -v /$(pwd -W):/home/jovyan/env_alaysis\
    -p 8888:8888 \
    --name $(id -u -n)-env_analysis \
    ${IMAGE_NAME}
