Poxen
=====

Poxen is a small set of helper scripts for using [Puppet](http://puppetlabs.com/) and [Boxen](http://boxen.github.com/) Puppet modules to configure Mac by single person.
No big deal, Poxen is just running ``puppet apply`` on your Mac and configuring your environment automatically.

What Poxen does and doesn't?
----------------------------

Poxen *does*

  * Prepare dependencies to run Puppet with Boxen modules in a simple way.
  * Provides pseudo Boxen facters and config to make Boxen Puppet modules work.

Poxen *doesn't*

  * Support team, projects, company or any other structures in manifests and modules.
  * Use tailored error message, authentications or GitHub dependents.

What I need to know?
--------------------

You may need to know what Puppet is and how it works also what Boxen is. Poxen is like a subset of Boxen but you don't need to know Boxen specific flavors, instead, more directly play with Puppet.

Getting started
---------------

After purchasing your new Mac at Apple Store, you'll need to run next things by hand.

1. Run through all Apple welcome settings, includes create your initial account.
1. Enable full-disk encryption if needed, which may take about an hour.
1. Open ``/Applications/Utilities/Terminal.app`` and run ``xcode-select --install``, then ``sudo xcodebuild --license`` to agree Xcode license agreement.

> **NOTE** If you're not using Mavericks, OS X 10.9, there are no ``xcode-select`` by default.
> Install latest version of Xcode from AppStore instead, then run this command.

Now you're all set, let's create your poxen instance. In your preferable place run next command to clone Poxen project.

    $ git clone https://github.com/niw/poxen.git

> **NOTE** Moving ``poxen`` directory from the original palce may break the stubbed commands in ``poxen/bin`` (See shbang line.)
> If you have an issue with it, ``git clean -dfX`` to remove all ignores then run ``script/poxen`` again.

Next step is writing a manifest to configure your Mac. It's actually same as what we need to do with the original Puppet.
For example, try to install IntelliJ IDEA. Add next liens to ``manifests/site.pp``.

    package {
      "IntelliJ IDEA 13":
        source => "http://download.jetbrains.com/idea/ideaIU-13.dmg",
        provider => appdmg;
    }

That's it! Ready to apply the manifest on your new Mac.

    $ script/poxen

This command will fetch all dependencies and initialize project so the first run takes some time.
Then you'll ask a login password for `sudo` to give a priviledge to Puppet. Enter it then continue.

After the command finishes without errors, you'll see `/Applications/InteliJ IDEA 13.app`!

This is very basic usage of Poxen. You can write manifests to automate manythings.

* Configure system preferences, like change keyboard repate speed.
* Install applications from `zip`, `dmg`, `pkg` etc.
* Remove [relatively insecure Java applet plugin](http://java-0day.com/).

Ultimately, if you write all needs after purchaging new Mac in your manifests, you can automate all initial setup and no longer need to spend a day or week to start your life with new Mac.

Boxen Modules
-------------

Boxen project provides [many Pupept modules](https://github.com/boxen). Poxen has a mostly compatible `Facts` and internal `config` interfaces so that most of Boxen module must work without any modifications.

To use Boxen modules, simply add a line into ``Puppetfile`` to fetch the module form GitHub, then modify manifests to use it.

For example, install Google Chrome using [puppet-chrome](https://github.com/boxen/puppet-chrome) module. Add next lines to ``Puppetfile``.

    boxen "chrome", "1.1.2"

And add next lines to ``manifests/site.pp``

    # Use Google Chrome Beta channel.
    include chrome::beta

Run ``script/poexn`` to download the module and apply the manifest. You'll see ``/Application/Google Chrome.app``.
