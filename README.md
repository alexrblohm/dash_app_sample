# docker_setup
#TODO
Yo nerds, here is a very basic Docker-Python setup that should solve most Python Docker problems.

I use a Mac and find it a million times easier for this stuff. Don't ask for Windows stuff, I'm a statistician turned
data scientist so I'm not an expert on this stuff.

## Setup

1. You will need to download and run docker
   https://www.docker.com/products/docker-desktop

2. You will need make. Check the version to see if it's installed:

```
make -v
```

3. Clone this repo. If this is new for you, follow this. But setup ssh keys, it is much better...
    - https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository

## How do I use this Shiz?

1. Open this in some IDE. I highly recommend PyCharm, but it doesn't matter much. Collegues recommend Atom and VS Code.
2. In the terminal, run the make commands (see next section)
    - Note, Docker needs to be running. Look for the cute whaleboat!

3. Load any packages you need installed in the requirements.txt file.
    - I set it up to install the most recent versions of Jupyter and Pandas
    - Eventually, you'll want to lock down all the package versions

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

3. run: Run src/main.py script.

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
