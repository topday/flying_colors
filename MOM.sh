#!/bin/bash
source .env 

project=$(echo $COMPOSE_PROJECT_NAME | sed 's/\.//g') 

#===============================================================================================
# list of essentials packages required to run this interface
sudo apt install dialog

#===============================================================================================
# List of function required to start or run this project 
#===============================================================================================

function startProject {
  echo "Start project"

  sudo docker-compose up
}

function buildProject {
  echo "Build docker container"

  FILE=.env
  if [ -f "$FILE" ]; then
      echo "$FILE exists."
    else 
      echo "$FILE does not exist. Creating default .env version."
      cp env.example .env
  fi

  cp Dockerfile_benchmark ../
  cp Dockerfile_project ../

  time sudo docker-compose build --progress=plain --no-cache

  rm ../Dockerfile_benchmark
  rm ../Dockerfile_project
}

function installDocker {
  echo "Setting docker enviroment"
  sudo apt-get remove docker docker-engine docker.io containerd runc
  curl https://get.docker.com | sh \
      && sudo systemctl --now enable docker

  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

  sudo chmod +x /usr/local/bin/docker-compose

  docker-compose --version

  sudo groupadd docker

  sudo usermod -aG docker $USER
  
  source ~/.bashrc 
}

HEIGHT=20
WIDTH=50
CHOICE_HEIGHT=25
BACKTITLE="DEV level, docker based, project manager"
TITLE="Mission Operation Manager (MOM)"
MENU="Quick glimps in project architecture:"

OPTIONS=(1 "Start project"
         2 "Build project"
         3 "Install Docker"
         4 "List running containers"
         5 "Monior running containers"

         10 "Shell: benchmark container"
				 11 "Shell: project (e2e) container + AB"

         20 "LOG: benchmark container"
				 21 "LOG: project (e2e) container"

         40 "TEST: sample WRK benchmark"
         41 "TEST: sample e2e"
         42 "TEST: sample Apache benchmark"

         50 "Docker: clear cache"
         51 "Host: restart"
       )

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)
clear

case $CHOICE in
        1)
            startProject
            ;;
        2)
            buildProject
            ;;
        3)
            installDocker
            ;;
        4)
            echo "List docker running containers"
            sudo docker stats
            ;;
        5)
            watch -n1 "docker stats --no-stream | grep ${project}"
            ;;

        10)
            sudo docker exec -it ${project}_benchmark_1 /bin/bash
            ;;
        11)
            sudo docker exec -it ${project}_project_1 /bin/bash
            ;;

        20)
            sudo docker logs ${project}_benchmark_1 -f
            ;;
        21)
            sudo docker logs ${project}_project_1 -f
            ;;

        40)
            sudo docker exec -it ${project}_benchmark_1 wrk -c10 -d60 -t2 --latency http://bee.lc:10380/
            ;;
        41)
            sudo docker exec -it ${project}_project_1 npm run dev:test
            ;;
        42)
            sudo docker exec -it ${project}_project_1 ab -n 1000 -c 10 http://bee.lc:10380/
            ;;


        50)
            sudo docker system prune -a -f
            ;;
        51)
            eudo shutdown -r now 
            ;;
esac
