# Citizen Science Kosovo

[ ![Codeship Status for
randomm/citizenscienceks](https://codeship.io/projects/8fe84230-1b5d-0132-f287-7ed5768cf494/status)](https://codeship.io/projects/34917)

This Padrino project provides a data platform and world wide web service for the Citizen Science Kosovo project.

## Prerequisites

- PostgreSQL 9.x (install as you see fit, macbrew, aptitude etc)
- RVM (or rbenv), unless you wish to use system Ruby. Instructions below assume rvm is present.

### Install Ruby 2.1.1

Install Ruby 2.1.1 via RVM, e.g.

```
rvm install 2.1.1
```

Create a gemset for citizenscienceks  project, e.g.

```
rvm gemset create citizenscienceks
```

### Install pow (OS X only, not necessary to get project running locally, more "a nice to have")

Follow instructions at http://pow.cx/

### Install required gems

Make sure you are in the project root and that you are using the
appropriate gemset (should you wish to use gemsets). Using rvm you can
check by typing:

```
rvm gemset list
```

Then install all dependencies via bundler:

```
bundle install
```

Setup the database

```
rake db:create
rake db:migrate
rake db:seed
```

If you are a core member, you may have access to the live database, in
which case you should NOT create the local database, but instead pull
the data form heroku. Scroll down for contact details to get more info
about this option.

### Start server and go!

#### Using pow

If you are running pow, then create a symbolic link of the project
folder to ~/.pow/ :

```
ln -s /path/to/project ~/.pow/citizenscienceks
```

Point your browser to http://www.citizenscienceks.dev and rejoice!

#### Not using pow

In project root type:

```
padrino s
```

and point your browser to http://localhost:3000 and rejoice!


More information coming soon.

Questions?  Jani Turunen, jani.turunen@kosovoinnovations.org, turunen.jani@gmail.com
