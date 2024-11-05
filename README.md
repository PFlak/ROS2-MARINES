# ROS2-MARINES
## Architecture

The project architecture is based on Docker, which facilitates rapid deployment and allows for operation in nearly any configuration. To ensure proper control of the robot, the controlling computer must maintain a connection with the Nvidia Jetson. This setup maximizes flexibility and responsiveness in various operational environments, making it suitable for diverse applications in robotics and automation.

### Example connection
![example connection](./images/prod_connection.png)

### External Devices

#### USB

Devices connected to each host are accessible from docker container run on host

#### Ethernet

Devices are availability depends on network settings. In general devices in the same network should work both on ubuntu device and Nvidia Jetson

### File structure
```bash
.
├── compose.dev.yml
├── compose.prod.yml
├── controller
│   ├── bashrc # Bash file executed after starting container 
│   ├── Dockerfile.controller
│   ├── entrypoint.sh
│   └── ws
│       | # ROS Workspace for controller packages
|       |
|      ...
|
└── jet
    ├── bashrc
    ├── Dockerfile.jet
    ├── Dockerfile.jet_dev
    ├── entrypoint.sh
    ├── jet_utils           
    │   ├── ros2_build.sh
    │   ├── ros2_install.sh
    │   └── ros2_test.sh
    └── ws
        | # ROS Workspace for jet packages
        |
       ...
```

`controller/ws` and `jet/ws` are mounted in production containers on
```bash
/ros_ws
```
And while using devcontainers
```bash
/home/$USER/ros_ws/src/controller
# AND
/home/$USER/ros_ws/src/jet
```


## Setting up environment

### Requirements

- Linux 20.04 or 22.04
- X11
- Docker
- Visual Studio Code
- VS Code Extensions
  - WSL
  - Dev Containers
  - Remote - SSH
  - Remote - Tunnels
  - or Remote Development extension pack

### Devcontainers
Proper way to develop in this repository is to use [docker devcontainers](https://code.visualstudio.com/docs/devcontainers/containers).

If VS Code Extensions are installed, after cloning the repo we can start working on ROS packages after executing command in VS Code (`ctrl+shift+p`)
```
>Dev Containers: Reopen in Container
```

Working in devcontainers doesn't require connection to Nvidia Jetson

### SSH
Before we can use Nvidia Jetson Orin Nano as the driver of a robot, we should establish ssh [key-based authentication](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)
#### create docker context:
```bash
docker context create \
<context_name> \
--docker "host=ssh://user@remotemachine"
```

### Production deployment

After establishing key-based authentication on ssh and creating docker context in `/path/to/ROS2-MARINES/` you should run:
```bash
docker context use default
docker compose -f compose.prod.yml up -d controller
docker context use <context_name>
docker compose -f compose.prod.yml up -d jet
```

to access terminal of each container we use:
#### For controller

```bash
docker context use default

# You can check exact name by running:
#
# docker container ls
#
# id is usually 1
docker exec -it agh-marines-ros2-controller-<id> bash
```

#### For jet

```bash
docker context use <context_name>

# You can check exact name by running:
#
# docker container ls
#
# id is usually 1
docker exec -it agh-marines-ros2-jet-<id> bash
```

To shut down containers and networks:
```bash
docker context use default
docker compose -f compose.prod.yml down controller
docker context use <context_name>
docker compose -f compose.prod.yml down jet
```
 
## ROS Nodes
><span style="color:darkorchid; font-style:italic">ToDo...</span>



