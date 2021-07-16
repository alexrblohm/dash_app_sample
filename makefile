.PHONY : build clean-u clean-all run shell jup stop

CONTAINER_TAG=example_name
FOODCAST=$(shell aws s3 ls s3://ia-packages/foodcast --recursive | sort | tail -n 1 | awk '{print $$4}')

help: ## 	    Commands to run
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

build: ##     Build the Docker Container
	echo
	echo "Download foodcast from S3."
	aws s3 cp s3://ia-packages/$(FOODCAST) ./packages/$(FOODCAST)
	echo "Build the Docker Container and tag it: $(CONTAINER_TAG)"
	docker build --tag $(CONTAINER_TAG) . --build-arg FC_VERSION=$(FOODCAST)

clean-u: ##   Clean unused docker containers
	echo
	echo "Deleting all unused Docker containers."
	docker system prune --all --force --volumes

clean-all: ## Clean *all* docker containers
	echo
	echo "Deleting *ALL* Docker containers!"
	docker container stop $(docker container ls --all --quiet) && docker system prune --all --force --volumes

d_base_image: ##   	Download Forecasting Base Image
	echo
	echo "Downloading base forecasting image"
	aws ecr get-login-password | docker login --username AWS --password-stdin 644944822023.dkr.ecr.us-west-1.amazonaws.com/ia-forecasting-base
	docker pull 644944822023.dkr.ecr.us-west-1.amazonaws.com/ia-forecasting-base:latest
	docker tag 644944822023.dkr.ecr.us-west-1.amazonaws.com/ia-forecasting-base:latest forecasting_base

run: ##       Run the main.py file
	docker run --publish 8050:8050 --volume "$(CURDIR)":/app --env AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
    --env AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) $(CONTAINER_TAG) \
 	python3 src/app.py

shell: ##     Launch the container shell (for dev)
	echo
	echo "Opening shell in $(CONTAINER_TAG)"
	echo "To leave the shell run: 'exit'"
	docker run --interactive --tty --volume "$(pwd)":/app\
    $(CONTAINER_TAG) /bin/sh

jup: ##       Launch Jupyter Notebooks
	echo
	echo "Starting the Jupyter server."
	echo "Control c to stop"
	docker run --publish 8888:8888 --volume "$(CURDIR)":/container_root \
    --detach $(CONTAINER_TAG) jupyter
	echo "Go to http://localhost:8888/."

stop: ##      Stop all containers
	echo
	echo "Stopping all containers"
	-docker stop -t0 $(shell docker ps -a -q) 2> /dev/null
