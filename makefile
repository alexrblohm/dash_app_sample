.PHONY : build clean-u clean-all run shell jup stop

CONTAINER_TAG=example_name

help: ## 	    Commands to run
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

build: ##     Build the Docker Container
	echo
	echo "Build the Docker Container and tag it: $(CONTAINER_TAG)"
	docker build --tag $(CONTAINER_TAG) .

clean-u: ##   Clean unused docker containers
	echo
	echo "Deleting all unused Docker containers."
	docker system prune --all --force --volumes

clean-all: ## Clean *all* docker containers
	echo
	echo "Deleting *ALL* Docker containers!"
	docker container stop $(docker container ls --all --quiet) && docker system prune --all --force --volumes

run: ##       Run the main.py file
	docker run --publish 8050:8050 --volume "$(CURDIR)":/container_root $(CONTAINER_TAG) python3 src/app.py

shell: ##     Launch the container shell (for dev)
	echo
	echo "Opening shell in $(CONTAINER_TAG)"
	echo "To leave the shell run: 'exit'"
	docker run --interactive --tty --volume "$(pwd)":/container_root\
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
