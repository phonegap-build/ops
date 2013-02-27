# Ops

This repo serves as a container for utilitys and apps related
to Operations tasks.

## Using Ops tools:

### Requirements

    ruby 1.8.7
    openssh

### Getting Started

Add the following to your .bashrc or .bash_profile_

    export $OPS_HOME="/path to your ops repo"
    source $OPS_HOME/autocomplete

Add the following symbolic link so you can use this from any directory

    # ln -s this somewhere else if you're using a shared computer
    # maybe create a local bin folder in ~/ and add it to your path

    ln -s $OPS_HOME /usr/local/bin/ops

run the following command

    bundle install

create a config.json file with the following contents:

    {
      "IdentityLocations" : [ "~/.ssh", ... ],
        "AWS" : {
          "AccessKeyId" : "Your Access Key",
          "SecretAccessKey" : "Your Secret Access Key"
        }
    }

### Connecting to a host:

    usage: ops [ host ]:ssh

### Other commands:

    ops -T - List all tasks available

    ops hosts:list - List all the hosts

    ops hosts:sync - Sync hosts.json with EC2 instance list

    ops hosts:add host=[ alias name ] hostname=[ ip address or hostname ] \
      identity=[ private key name ] user=[ user ]
