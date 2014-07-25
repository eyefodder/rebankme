[![Code Climate](https://codeclimate.com/repos/53baacb3e30ba0381a000625/badges/b91b5586aaa1a3ca4107/gpa.png)](https://codeclimate.com/repos/53baacb3e30ba0381a000625/feed)
[![Code Climate](https://codeclimate.com/repos/53baacb3e30ba0381a000625/badges/b91b5586aaa1a3ca4107/coverage.png)](https://codeclimate.com/repos/53baacb3e30ba0381a000625/feed)
# Rebank Me!
## Development Environment Setup
The dev environment should be able to be setup in a couple of simple steps using vagrant. What this does is set up a virtual machine on your machine that the app will run in. This way it closely mimics the production environment and we can easily synchronize environments accross different users' machines.

### To get up and running:
1. Install [Vagrant] (http://www.vagrantup.com/downloads.html)
2. Install [VirtualBox] (https://www.virtualbox.org/wiki/Downloads)
3. Open a terminal window and cd to the 'ops' folder of this repo
4. Type the following (you only need to do this on first run): `vagrant plugin install vagrant-vbguest`
5. Now type `vagrant up` and witness as a new machine gets downloaded and configured. The guest box is where your code will run when you're working with it.

### Warnings / Errors you will see that are nothing to worry about
1. `std is not a tty`
2. `Guest addition do not match on this machine`
3. `In most cases it is ok that the windows systems driver installation fail`
4. `passing vesrion to postgresql server is deprecated...`

### Once you're up and running
When you are working like this, you now have a machine running all on its lonesome and isolated from any other stuff on your laptop. It is like running a whole new machine in a box though so it will consume disk space and RAM. You can shut it down / pause it just like a real machine. Here are some useful commands:

1. `vagrant up` (re)starts the machine so you can work with the app

2. `vagrant suspend` This is like stopping the machine in time. Resuming work is super fast, and the box wont consume RAM or CPU, but will take up a big chunk of disk space (about 2GB) plus whatever was in RAM
3. `vagrant halt` This is like shutting the machine down. Takes longer to start than `suspend` but RAM isn't written to disk so it takes less space
4. `vagrant destroy` This is like throwing the box out the window. You can always start afresh with `vagrant up` but it will have to go through that initial install which might take a few minutes...

### Accessing the app 

1. The rails app should be up and running in development mode (that means if you change a file you will see the change in the app straight away). Go to http://localhost:3001 to see the app
2. If for some reason you need to kill the rails app you can do it like this:
```shell
vagrant ssh
cd /app
sh ./stop_server.sh
```
