#!/usr/bin/env bash
# init


cd /app
echo 'prepping rails app'
bundle install
rake db:migrate
rake db:seed
rake test:prepare
echo '
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$                                                                                           $$
$$                   /$$$$$$$            /$$                           /$$                   $$
$$                  | $$__  $$          | $$                          | $$                   $$
$$                  | $$  \ $$  /$$$$$$ | $$$$$$$   /$$$$$$  /$$$$$$$ | $$   /$$             $$
$$                  | $$$$$$$/ /$$__  $$| $$__  $$ |____  $$| $$__  $$| $$  /$$/             $$
$$                  | $$__  $$| $$$$$$$$| $$  \ $$  /$$$$$$$| $$  \ $$| $$$$$$/              $$
$$                  | $$  \ $$| $$_____/| $$  | $$ /$$__  $$| $$  | $$| $$_  $$              $$
$$                  | $$  | $$|  $$$$$$$| $$$$$$$/|  $$$$$$$| $$  | $$| $$ \  $$             $$
$$                  |__/  |__/ \_______/|_______/  \_______/|__/  |__/|__/  \__/             $$
$$                                                                                           $$
$$                                                                                           $$
$$                                                                                           $$
$$                                     /$$    /$$ /$$      /$$                               $$
$$                                    | $$   | $$| $$$    /$$$                               $$
$$                                    | $$   | $$| $$$$  /$$$$                               $$
$$                                    |  $$ / $$/| $$ $$/$$ $$                               $$
$$                                     \  $$ $$/ | $$  $$$| $$                               $$
$$                                      \  $$$/  | $$\  $ | $$                               $$
$$                                       \  $/   | $$ \/  | $$                               $$
$$                                        \_/    |__/     |__/                               $$
$$                                                                                           $$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$                                                                                           $$
$$                                                                                           $$
$$     This virtual machine is setup to run the rebankme app in its own environment.         $$
$$                                                                                           $$
$$      In order to work correctly, you will have to setup some configuration variables.     $$
$$      The quickest, simplest way to do this is to make a file in the ops folder called     $$
$$                                                                                           $$
$$                            guest_bash_profile                                             $$
$$                                                                                           $$
$$      As a template, you can use the "sample_guest_bash_profile" file, replacing dummy     $$
$$      values with your own. Once that is done, you need to re provision the file by        $$
$$      running:                                                                             $$
$$                                                                                           $$
$$                  vagrant provision --provision-with file"                                 $$
$$                                                                                           $$
$$                                                                                           $$
$$                                                                                           $$
$$      If you are doing active development, you should tell vagrant to keep your files      $$
$$      in sync on the virtual machine. to do this, open a new terminal window and type      $$
$$                                                                                           $$
$$                            "vagrant rsync-auto"                                           $$
$$                                                                                           $$
$$      You are now ready to start the app. In order to do this, you need to jump into       $$
$$      the virtual machine and start the web app and worker processes. Dont worry; its      $$
$$      not as scary as it sounds:                                                           $$
$$                                                                                           $$
$$                            vagrant ssh                                                    $$
$$                            cd /app                                                        $$
$$                            foreman start                                                  $$
$$                                                                                           $$
$$      When you have done that, the app will be accessible through a browser at             $$
$$                                                                                           $$
$$                            http://localhost:3001                                          $$
$$                                                                                           $$
$$      See! that was easy wasnt it?!!                                                       $$
$$                                                                                           $$
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
'

