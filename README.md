# Rebank Me!
## Development Environment Setup
The dev environment should be able to be setup in a couple of simple steps using vagrant. What this does is set up a virtual machine on your machine that the app will run in. This way it closely mimics the production environment and we can easily synchronize environments accross different users' machines.

### To get up and running:
1. Install [Vagrant] (http://www.vagrantup.com/downloads.html)
2. Open a terminal window and cd to the 'ops' folder of this repo
3. Type the following (you only need to do this on first run): `vagrant plugin install vagrant-vbguest`
4. Now type `vagrant up` and witness as a new machine gets downloaded and configured. The guest box is where your code will run when you're working with it.

### Once you're up and running
When you are working like this, you now have a machine running all on its lonesome and isolated from any other stuff on your laptop. It is like running a whole new machine in a box though so it will consume disk space and RAM. You can shut it down / pause it just like a real machine. Here are some useful commands:
1. `vagrant up` (re)starts the machine so you can work with the app
2. `vagrant suspend` This is like stopping the machine in time. Resuming work is super fast, and the box wont consume RAM or CPU, but will take up a big chunk of disk space (about 2GB) plus whatever was in RAM
3. `vagrant halt` This is like shutting the machine down. Takes longer to start than `suspend` but RAM isn't written to disk so it takes less space
4. `vagrant destroy` This is like throwing the box out the window. You can always start afresh with `vagrant up` but it will have to go through that initial install which might take a few minutes...