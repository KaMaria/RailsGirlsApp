## Rorganize.it [![Build Status](https://travis-ci.org/rubycorns/rorganize.it.svg?branch=master)](https://travis-ci.org/rubycorns/rorganize.it)

You visited a Rails Girls Workshop and now want to join a project group to really learn the way of the code? Or maybe you recently coached at a workshop and now want to do it on a regular basis! If that's the case, this little app is just the one for you!

An overview of who meets when, where, with whom to work on what.

### Contributing
Please take a look at our [Guidelines to Contributing in CONTRIBUTING.MD](CONTRIBUTING.md)

### Code of Conduct

You can learn about our [Code of Conduct online ](https://rorganize.it/conduct) or [in the repo](https://github.com/rubycorns/rorganize.it/blob/master/CODE_OF_CONDUCT.md)

### Just some general information:

Ruby version 2.5.x

Rails version 5.1.x

Make sure you have ImageMagick installed.

In Terminal run (OS&nbsp;X):

    brew install imagemagick

On Ubuntu/Debian, you can run (or with the package manager of your choice):

    sudo apt-get install imagemagick

You also need to install postgres tools on Ubuntu/Debian:

    sudo apt-get install libpq-dev

### Get the code
Get the code from this repo

    git clone git@github.com:rubycorns/rorganize.it.git


### Run locally

Get all the secrets:

    cp config/secrets.yml.sample config/secrets.yml

Install all the gems

    bundle install

Spice up the database

    bundle exec rake db:migrate
*Note: if running the migrations alters the schema.db file with changes such as unneccessary linebreaks and spaces, and you have not created any of your own migrations to specifically modify it, it's best not to commit the schema file. You can delete the modified file from your local copy by running `git checkout db/schema.rb`*

Get some data

    bundle exec rake db:seed

Run the server

    bundle exec rails s

et voilá

Run all the tests

    bundle exec rspec

#### Catch emails locally

`config/environments/development.rb` contains a few lines on how to setup [MailCatcher](https://mailcatcher.me/) so you can check the emails you sent locally.

### Git: branches
*Note*: you will need permission from rubycorns in order to push your branches to this repository.
Until you have been granted permission, please [fork](https://help.github.com/articles/fork-a-repo/) this repository,
and create a branch from your fork.

Create new branch (you should be in the directory of the project)

    git branch Name_of_your_branch

Switch to the newly created branch (the same if you need to change to the branch that already exist)

    git checkout Name_of_your_branch

Or for lazy people like Tobi (does both steps at the same time):

    git checkout -b Name_of_your_branch

Push the new branch to the repository (with some commits or just "bare" branch)

    git push --set-upstream origin Name_of_your_branch

Delete local branch

    git branch -D Name_of_your_branch


### Git: commit your changes
Make changes, then

    git add -A

Tell the others what you did

    git commit -m "description of changes"

Off to GitHub

    git push

### Make a pull request
1. Select your branch on GitHub.
2. Click 'Pull Request'.
3. Write a little summary of what you did and alert people if you need help.
before merging.
4. When you merge and close your branch, please make sure to include a [ridiculous gif](https://github.com/rubycorns/RailsGirlsApp/pull/281#issuecomment-64454385).

### Deploy

We are hosted by [Uberspace](https://uberspace.de/). The app runs at
https://rorganize.it

To deploy, run:

    git push production master

this will push the current version of the master branch from your
local repository to production, run bundler and precompile the assets
if necessary, and restart the server.

To set this up, first make that you have ssh access to the production
server. If this command works, then you have ssh access. If not, ask
someone of the Rubycorns to give you access.

    ssh ror@rorganize.it echo itworks

Then in your local repository, add a git remote for production:

    git remote add production ror@rorganize.it:rorganize.it

That should be it.

#### Troubleshooting deploy

The scripts that are run after a push are in the
[deploy](https://github.com/rubycorns/rorganize.it/tree/master/deploy)
directory. See also https://github.com/mislav/git-deploy for more
info.

In case this doesn't work though, ssh into server and try to restart
the daemontools service:

    svc -t ~/service/ror

If the app is not working, there might be an error on startup (e.g. a
missing gem), and daemontools tries to start it again and again. Check
with e.g. `ps fuxwww` if the pid of the thin server constantly
changes. If that is the case, try to stop the service with

    svc -d ~/service/ror

then start it manually to see the errors on the console, with

    ~/service/ror/run

or follow the contents of that file to see what it is actually doing.
Once fixed, run

    svc -u ~/service/ror

to start the service in regular mode again. See
https://wiki.uberspace.de/system:daemontools for more info (in
german).

Other useful things and places to look at:

- use `$ pgrep -fl thin` to check if only one thin process is running.
If there are two kill the one with the constant pid `$ kill pid` so the new
thin can start
- check the service log for weirdness
`$ tail -n 100 -f /home/ror/etc/run-ror/log/main/current`
