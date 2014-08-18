[![Code Climate](https://codeclimate.com/repos/53baacb3e30ba0381a000625/badges/b91b5586aaa1a3ca4107/gpa.png)](https://codeclimate.com/repos/53baacb3e30ba0381a000625/feed)
[![Code Climate](https://codeclimate.com/repos/53baacb3e30ba0381a000625/badges/b91b5586aaa1a3ca4107/coverage.png)](https://codeclimate.com/repos/53baacb3e30ba0381a000625/feed)
# Rebank Me!
## What's this?
Rebank me is an app designed to help people find the right type of banking product for them. It's designed to address the needs of low-income Americans and was built as part of the [Significance Labs] (http://significancelabs.org) programme sponsored by the [Blue Ridge Foundation] (http://brfny.org/) in New York City. Whilst the app is very much a work in progress, you can see a working demo [here] (http://www.rebankme.com).
## Using the code
The code here is provided as-is and without any warranty of any kind, as per the MIT license (see LICENSE.txt for more details). In order to actually do anything useful you will need to do some configuration...
## Configuration
In the 'ops' folder is a file called `sample_guest_bash_profile` that contains all the environment variables you will want to set. They are as follows:

| Property      | Description   |
| ------------- | ------------- |
| GOOGLE_MAPS_KEY | The google maps API key, which you can get [here] (https://developers.google.com/maps/documentation/javascript/tutorial#api_key) |
| GOOGLE_ANALYTICS_KEY      | Google Analytics key usually begins UA-XXX-XXXX  |
| MAILER_ADDRESS | base mailer address, e.g. smtp.gmail.com |
| MAILER_PORT | mailer port. gmail's is to 587 |
| MAILER_DOMAIN | base mailer domain |
| MAILER_USERNAME | the mailer username to send email from |
| MAILER_PASSWORD | password for above |
| MAILER_REBANK_RECIPIENT | When someone asks for assistance, this is the email address that receives the mail |
| SECRET_TOKEN | A secret hash generated to validate the server identity. You can create one using `rake secret` |
| ADMIN_USERS | A comma delimited list of Admin users. Default password is `changeme` so , yeah, you should do that... |

### To configure your dev system
Create a file called `guest_bash_profile` in the `ops` folder with the same format as `sample_gues_bash_profile` If you haven't build the development environment (see below) then it will get copied accross during first-time provisioning, otherwise see below

### Updating configuration
If your virtual machine has already been installed, when you change the values in `guest_bash_profile` you have to reprovision the file. to do that:
```shell
cd ops
vagrant provision --provision-with file
```
If you are already ssh'd into the virtual machine you will need to reload the environment variables using `source ~/.bash_profile`

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
foreman start
```

### Running the test suite

1. To run the tests once:
```shell
vagrant ssh
cd /app
rspec
```

### Setting up Growl & Guard
2. If you are actively developing, you probably want to have the tests run everytime you make a change. To do this, we use [Guard (https://github.com/guard/guard)] which watches files for changes and just runs the tests you need.
3. Notifications go from the guest machine to the host machine are managed using GNTP and Growl. Assuming you have a Mac with Growl on it, open up the Growl preference pane and select 'Network' Ensure 'listen for incoming notifications' is checked and supply a password. In the box to the right you will see the IP address that the host machine can be reached at. Use these values to update the first line of `Guardfile`:
```ruby
notification :gntp, :sticky => false, :host => 'your ip here', :password => 'your password here'
```
3. If you can't get growl setup, then add  `-n f` flags to the `guard` command; this disables system notification.
```shell
vagrant ssh
cd /app
bundle exec guard -n f
```

