# NVIDIA Jetson TX2 #


## Setup ##

The following workflow was tested with Jetpack 3.1 on a 64-bit Ubuntu 16.04 LTS host and a Jetson TX2. Note that ==all files on the Jetson TX2 will be deleted== in this process.


#### Prerequisites ####

* 64-bit Ubuntu PC ("host") *in addition* to the Jetson TX2
* USB cable


#### Install ####

The following steps must be performed using JetPack **on the host** and will flash the Jetson TX2 with a fresh system:

1. download JetPack from https://developer.nvidia.com/embedded/jetpack
2. copy the JetPack executable into `$HOME/lib/jetpack-x.y/`
3. run JetPack executable, select full install and follow instructions

Afterwards, a fresh Ubuntu 16.04 with CUDA, cuDNN, TensorRT, etc. (Linux4Tegra) is installed on the Jetson TX2.


#### Post-Install ####

The following steps are performed **on the Jetson TX2**.

* (as `nvidia`) add new user with sudo and GPU privileges

        sudo adduser <user>
        sudo adduser <user> sudo
        sudo adduser <user> video

* (as `<user>`) secure `nvidia` and `ubuntu` user accounts

        rm /home/nvidia/.ssh/authorized_keys
        sudo passwd -l nvidia
        sudo passwd -l ubuntu       
  (also delete the `~/.ssh/id_rsa*` files on the host if they were created during the installation)

* (as `<user>`) add host SSH key for new user
        
        mkdir -p ~/.ssh
        echo "<content of ~/.ssh/*_rsa.pub of host>" >> ~/.ssh/authorized_keys

* (as `<user>`) change hostname from `tegra-ubuntu` to `<new>`

        sudo sed -i s/$(cat /etc/hostname)/<new>/ /etc/hosts
        sudo echo "<new>" > /etc/hostname

* (as `<user>`) enter max performance mode after each boot, no compromises

        sudo crontab -e
        @reboot sleep 65; /usr/sbin/nvpmodel -m 0; /home/nvidia/jetson_clocks.sh

* (as `<user>`) confirm that the system runs in max performance mode

        # reboot and wait 65 seconds, then:
        sudo /home/nvidia/tegrastats
        
  should show all six CPUs online at 2000MHz and the GPU running at 1300MHz

* (as `<user>`) update system and install standard tools

        sudo -i
        add-apt-repository universe
        apt-get update
        apt-get install aptitude htop mc tmux
        aptitude update
        aptitude safe-upgrade

* (as `<user>`) install skeleton

        mkdir "$HOME/git"
        cd "$HOME/git"
        git clone https://github.com/dhaase-de/dh-skel.git
        ./dh-skel/install.sh
        exec bash
        
* TODO
    * disable X-server autostart (and auto-login for user `nvidia`)
    * stop services such as CUPS, speech dispatcher, etc.
    * add HDD


## Performance ##

* set performance profile

        nvpmodel -p --verbose # lists all profiles
        nvpmodel -m 0 # set profile MAXN (unconstrained)
        /home/nvidia/jetson_clocks.sh  # set all clock frequencies (CPU and GPU) to theur max values defined by the nvpmodel setting

* set fan speed (range 0..255)

        echo $speed > /sys/kernel/debug/tegra_fan/target_pwm

* turn on/off individual CPUs:

        # cpu0 can't be turned off
        sudo echo 1 > /sys/devices/system/cpu/cpu1/online # Denver
        sudo echo 1 > /sys/devices/system/cpu/cpu2/online # Denver
        sudo echo 1 > /sys/devices/system/cpu/cpu3/online
        sudo echo 1 > /sys/devices/system/cpu/cpu4/online
        sudo echo 1 > /sys/devices/system/cpu/cpu5/online
