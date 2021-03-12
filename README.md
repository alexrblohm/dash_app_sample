# dash_app_sample
This is a generic Docker-Python setup with a very simple Dash app.


## Setup

1. You will need to download and run docker
   https://www.docker.com/products/docker-desktop

2. You will need make. Check the version to see if it's installed:

```
make -v
```

## How do I use this Shiz?
1. In the terminal, run the make commands (see next section)
    - Note, Docker needs to be running. Look for the cute whaleboat!
2. Build then run

## Commands

1. help: list all things the makefile can do with a brief description.

```
make
make help
```

2. build: build the container. You will need to rebuild each time you change the .py code (unless you mount a volume
   like in shell or jupyter).

```
make build
```

3. run: Run the app.

```
make run
```

4. jup: Launch the Jupyter server to run Jupyter notebooks. Prob want to keep these all in notebooks folder.

```
make jup
```

5. stop: Stop all running containers (including Jupyter).

```
make stop
```

6. shell: launch the container to run with linux commands.

```
make shell
```

7. clean-u and clean-all: delete docker containers.  You should do this every so often to make sure you don't save these images and take up memory on your computer.
   - clean-u delete images and containers not running
   - clean-all deletes everything, running or not.
```
make clean-u
make clean-all
```

## Author
Alex Blohm

alexRblohm@gmail.com

Please email me with any issues or questions!  I hope this helps <3
