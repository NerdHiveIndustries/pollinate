# Pollinate

Pollinate is the base Rails application used at [NerdHive Industries](http://nerdhiveindustries.com/community).

Installation
------------

First install the pollinate gem:

    gem install pollinate

Then run:

    pollinate projectname

This will create a Rails 3.1 app in `projectname`. This script creates a new
new git repository. It is not meant to be used against an existing repo.

Gemfile
-------

To see the latest and greatest gems, look at Pollinate'
[template/Gemfile_additions](https://github.com/thoughtbot/pollinate/blob/master/templates/Gemfile_additions),
which will be appended to the default generated projectname/Gemfile.

It includes application gems like:

* [Paperclip](https://github.com/thoughtbot/paperclip) for file uploads
* [Formtastic](https://github.com/justinfrench/formtastic) for better forms
* [Airbrake](https://github.com/airbrake/airbrake) for exception notification
* [Flutie](https://github.com/thoughtbot/flutie) for default CSS styles
* [Bourbon](https://github.com/thoughtbot/bourbon) for classy sass mixins
* [Clearance](https://github.com/thoughtbot/clearance) for authentication

And testing gems like:

* [Cucumber, Capybara, and Capybara Webkit](http://robots.nerdhiveindustries.com/post/4583605733/capybara-webkit) for integration testing, including Javascript behavior
* [RSpec](https://github.com/rspec/rspec) for awesome, readable isolation testing
* [Factory Girl](https://github.com/thoughtbot/factory_girl) for easier creation of test data
* [Shoulda Matchers](http://github.com/thoughtbot/shoulda-matchers) for frequently needed Rails and RSpec matchers
* [Timecop](https://github.com/jtrupiano/timecop) for dealing with time
* [Bourne](https://github.com/thoughtbot/bourne) and Mocha for stubbing and spying
* [email_spec](https://github.com/bmabey/email-spec) for testing emails.

Other goodies
-------------

Pollinate also comes with:

* [jQuery](https://github.com/jquery/jquery) for Javascript pleasantry
* Rails' flashes set up and in application layout.
* A few nice time formats.

Heroku
------

You can optionally create Heroku staging and production apps:

    pollinate app --heroku true

This has the same effect as running:

    heroku create app-staging --remote staging --stack cedar
    heroku create app-production --remote production --stack cedar

Clearance
---------

You can optionally not include Clearance:

    pollinate app --clearance false

Dependencies
------------

Some gems included in Pollinate have native extensions. You should have GCC installed on your
machine before generating an app with Pollinate.

If you're running OS X, we recommend the [GCC OSX installer](https://github.com/kennethreitz/osx-gcc-installer).

We use [Capybara Webkit](https://github.com/thoughtbot/capybara-webkit) for full-stack Javascript integration testing.
It requires you have QT installed on your machine before running Pollinate.

Instructions for installing QT on most systems are [available here](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-QT).

PostgreSQL needs to be installed and running for the `db:create` rake task.

Issues
------

If you have problems, please create a [Github issue](https://github.com/nerdhiveindustries/pollinate/issues).

Contributing
------------

Please see CONTRIBUTING.md for details.

Credits
-------

![nerdhiveindustries](http://nerdhiveindustries.com/images/tm/logo.png)

Pollinate is maintained and funded by [NerdHive Industries LLC](http://nerdhiveindustries.com/community)

The names and logos for NerdHive Industries are trademarks of NerdHive Industries LLC.

License
-------

Pollinate is Copyright © 2012 nerdhiveindustries. It is free software, and may be redistributed under the terms specified in the LICENSE file.
