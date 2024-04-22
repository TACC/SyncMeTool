# SyncMeTool 
The SyncMeTool package contains the program ``syncMe``.  The purpose
is to loop over git repos and sync them with the remote repos. This
allows you to easily check the status of all repos and pull from the
remote repos with one command for each rather than manually cd'ing to
each repo and checking the status or pulling from ``origin``.
This command is a combination of a shell script and a lua program.


## To install

   1. Install lua and luaposix on your computer if they are not already
      there.  On linux system they can be installed with your package
      manager.  On a Mac, it a little more complicated. Please install
      lua and luarocks via brew:

         % brew install lua
         % brew install luarocks
         % luarocks install luaposix
       
   2. Clone this repo.
   
   3. Add the repo's bin directory to your path.  For example if you
      check out this repo into ~/w/SyncMeTool then add
      ~/w/SyncMeTool/bin to your path.
      
## To use

The first step is to create an env. var called ``SyncDirPath`` that
contains a list of directories relative to $HOME that contain git
repositories. Supposing you have git repos in ~/c ~/g and several
repos in the ~/w directory then add the following to your startup
files (e.g.: ~/.bashrc or ~/.zshrc)

    export SyncDirPath=c:g:w
   
This will cause ``syncMe`` to look at the repos in ~/c, ~/g and say
~/w/lmod/main, ~/w/lmod/testing, ~/w/xalt/main.  In other words 
each directory listed will be recursively searched until it finds a
file or directory name ``git``.  The file name support for ``.git`` is
to support git worktrees.


Then to check the status of your git repos you execute:

    % syncMe status

to get status by running ``git status`` in each git repository as
specified by ``$SyncDirPath``

To update or pull from your repos you can do:

    % syncMe update

Or

    % syncMe pull
   
This runs ``git pull`` in each git repository.


Note that ``status`` can be abbreviated to ``st``  and ``pull`` or ``update`` can be
shorten to ``up``.


## Typical usage

At the start of the day, you can run:

    % syncMe status
    % syncMe pull

to make sure that all local repos are up-to-date. The above can be
abbreviated to: 

    % syncMe all
    
which will run ``syncMe status`` and if that completes with no commits
required then ``syncMe pull`` is run.



When leaving for the day, you should run:

    % syncMe status
    
to make sure that all local repos are up-to-date and that there are no
uncommited files.  You'll have to commit any changes or push to
``origin`` manually. 

## Important output reported last

The syncMe command tries to remove as much unnecessary output from
git.  It also saves what it decides it important until the end.  This
means that changes to a repo will appear at the end.  So with
SyncDirPath=c:g:.up and there is a change in ~/g, the output would
be:

    % syncMe pull
   
    [pull]: On branch: main,   in directory: c
    [pull]: On branch: main,   in directory: .up

    [pull]: On branch: main,   in directory: g
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
do not proceed as expected then you can add the "-D" option to see the
internal communications:

    % syncMe -D up







