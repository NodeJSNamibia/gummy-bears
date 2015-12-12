# Collaboration Workflow

## Overview
The following describes the **workflow** governing our collaborative process. At any point in time there should at least two branches. First the *master* branch, which contains the code in production. It is the main codebase. Whenever a new version is push to the master branch, an automatic deployment task (thnking of Grunt) installs the new code on the respective production machines. As such we strive for **hot deployments**. Merging between the *develop* branch and the *master* branch should  happen through a **pull request**. A specific team member will be granted the privilege to merge to the master branch. He/she will have to accept the **pull request** and merge the current *develop* branch into the *master* branch.

The stage before the *master* branch, is the *develop* branch. It centralizes all the fully implemented features. Whenever a newly implemented feature is merged with the *develop* branch, **continuous integration** tests are run automatically. If the tests run successfully, the current *develop* branch can be merged with the *master* branch, and then deployed. If the continuous integration tests fail, an *issue* branch should be created based on the current *develop* branch and then revert the *develop* branch to the state before the merge. The *issue* branch is similar to a *feature* branch, which we will discuss next. Once the *issue* branch is completed it should be merged back into the *develop* branch.

For every single feature being implemented, there should be a separate *feature* branch. Just like an *issue* branch, a *feature* branch will focus on a specific functionality, implement it and test it. It is recommended that the keywords **feature** and **issue** be added to the names of the corresponding branch. Once the feature or the issue is complete it is merged into the *develop* branch through a **pull request**. Another team member will be granted special privilege to access the *develop* branch.

## Commit Message
Describe how to write commit messages

## Pull Request
Need to elaborate on the notification to the develop and manager branch managers when they should pull from another branch.

## Access Control List
Discuss the rules for the master and develop branches. For each feature branch, discuss the naming and the process for creating and managing the branch.

## Virtual machines
We will need about four VMs. One VM will contain our code base. This is where the gitolite server will be installed. The second VM will host the database server. Finally we will have two VMs for the production. Only one VM will be active at any point in time. But in order to minimize the time it takes to recover from the server failure, we will have another VM always ready to be fired up.

## Production System
coming soon...
