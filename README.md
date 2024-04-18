# SyncMeTool 
The SyncMeTool package contains the program syncMe.  This is a
combination of a shell script and a lua program.

The purpose of ``syncMe`` is to loop over git repos and sync them with
the remote repos.

To install:

   1. Check out this repo
   
   2. Add the repo's bin directory to your path.  For example if you
      check out this repo into ~/w/SyncMeTool then add
      ~/w/SyncMeTool/bin to your path
      
      
To use:

The first step is to create an env. var called SyncDirPath that
contains a list of directories relative to $HOME that contain git
repositories. Supposing you have git repos in ~/c ~/g and several
repos in the ~/w directory then add the following to your startup
files (e.g.: ~/.bashrc or ~/.zshrc)

    export SyncDirPath=c:g:w
   
This will cause syncMe to look at the repos in ~/c, ~/g and say
~/w/lmod/main, ~/w/lmod/testing, ~/w/xalt/main.  In other words 
each directory listed will be recursively searched until it finds a
file or directory name .git.


Then to check the status of your git repos you execute::

    % syncMe st

to get status.

To update or pull from your repos you can do::

    % syncMe up

Or

    % syncMe pull
   
## Important output reported last

The syncMe command tries to remove as much unnecessary output from
git.  It also saves what it decides it important until the end.  This
means that changes to a repo will appear at the end.  So with
SyncDirPath=c:g:.up and there is a change in ~/g, the output would
be::

    % syncMe up
   
    [up]: On branch: main,   in directory: c
    [up]: On branch: main,   in directory: .up

    [up]: On branch: main,   in directory: g
       f709426..18ef6e4  main       -> origin/main
    Updating f709426..18ef6e4
    Fast-forward
     try.bash | 1 +
     1 file changed, 1 insertion(+)


Note that change from "~/g" is given last even though it is the second
directory in $SyncDirPath.

## Debugging

Sometimes syncMe has trouble connecting to the remote server and the
important output will be hidden away in an internal buffer.  If things
do not proceed as expected then you can add the "-v" option to see the
internal communications::

    % syncMe -v up







