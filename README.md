Poxen
=====

Poxen is a small set of helper scripts for using [Boxen](http://boxen.github.com/) Puppet modules by single person.
No big deal, Poxen is just running ``puppet apply`` on your Mac and provisioning your environment automatically.

What Poxen does and doesn't?
----------------------------

Poxen *does*

  * Prepare dependencies to run Puppet with Boxen modules in simple way.
  * Provides pseudo Boxen facters and config to make Boxen Puppet module work.

Poxen *doesn't*

  * Support team, projects, company or any other structures in manifests and modules.
  * Use tailored error message, authentications or GitHub dependents.

What I need to know?
--------------------

You may need to know what [Puppet](http://puppetlabs.com/) is and how it works also what Boxen is. Poxen is like a subset of Boxen but you don't need to know Boxen specific flavors, instead, more directly play with Puppet.

Getting started
---------------

After purchase your new Mac at Apple Store, you'll need to run next things by hand.

1. Run through all Apple welcome settings, includes create your initial account.
1. Enable full-disk encryption if needed, which may take about an hour.
1. Open ``/Applications/Utilities/Terminal.app`` and run ``xcode-select --install``,
then ``sudo xcodebuild --license`` to agree Xcode license agreement.

    If you're not using Mavericks, OS X 10.9, there are no ``xcode-select`` by default.
    Install latest version of Xcode from AppStore instead, then run this command.

Now you're all set, let's create your poxen instance. In your preferable place[^1]
run next command to clone Poxen project.

[^1]: Moving ``poxen`` directory from the original to the other place may break the stubbed commands in ``poxen/bin`` (See shbang line.) If you have an issue with it, ``git clean -dfX`` to remove all ignores then run ``script/poxen`` again.

    $ git clone https://github.com/niw/poxen.git

Next step is writing a manifest to configure your Mac. It's actually same as what we need to do with the original Puppet.
For instance, try to install IntelliJ IDEA, open ``manifests/site.pp`` and add next lines.

    package {
      "IntelliJ IDEA 13":
        source => "http://download.jetbrains.com/idea/ideaIU-13.dmg",
        provider => appdmg;
    }

That's it!
Ready to apply manifests on your new Mac.

    $ script/poxen

This command will fetch many dependencies and initialize project so the first run takes some time.
Then you'll ask a login password for `sudo` to give a priviledge to Puppet. Enter it then continue.

After the command finishes without errors, you'll see `/Applications/InteliJ IDEA 13.app`!

This is very basic usage of Poxen. We can write a manifest to automate

* Configure system preferences, like change keyboard repate speed.
* Install applications from `zip`, `dmg`, `pkg` etc.
* Remove [relatively insecure Java applet plugin](http://java-0day.com/).

Boxen Modules
-------------

Boxen project provides [many Pupept modules](https://github.com/boxen). Poxen has a mostly compatible `Facts` and internal `config` interface so most of Boxen module must work without modifications.

To use Boxen modules, simply add a line into ``Puppetfile`` to fetch the module form GitHub, then modify manifests.

For example, install Google Chrome using [puppet-chrome](https://github.com/boxen/puppet-chrome) module, add next line to ``Puppetfile``.

    boxen "chrome", "1.1.2"

And add next line to ``manifests/site.pp``

    # Use Google Chrome Beta channel.
    include chrome::beta

Run ``script/poexn`` to download module and aply the manifest, you'll see ``/Application/Google Chrome.app``.