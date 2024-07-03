DATE_cmd    := date
VDATE       := $(shell $(DATE_cmd) +'%F %H:%M %:z')
VERSION_SRC := ./SyncMe/Version.lua
BUILD_V_src := lua ./proj_mgmt/buildVersion_src

all:
	@echo "does nothing"


tags: build_tags
	$(RM) file_list.*

build_tags:
	find . \( -regex '.*~$$\|.*/\.git\|.*/\.git/' -prune \)  \
	       -o -type f > file_list.1.txt
	sed -e 's|.*/.git.*||g'                                  \
	    -e 's|./file_list\..*||g'                            \
	    -e '/^\s*$$/d'                                       \
	       < file_list.1.txt > file_list.2.txt
	etags `cat file_list.2.txt`

gittag:
        ifneq ($(TAG),)
	  @git status -s > /tmp/git_st_$$$$                                               ; \
	  if [ -s /tmp/git_st_$$$$ ]; then                                                  \
	    echo "All files not checked in => try again"                                  ; \
	  else                                                                              \
	    $(RM)                                                           $(VERSION_SRC); \
	    $(BUILD_V_src) "$(GIT_BRANCH)" "$(TAG)" "$(TAG)" "$(VDATE)"  >  $(VERSION_SRC); \
	    git commit -m "moving to TAG_VERSION $(TAG)"                    $(VERSION_SRC); \
	    git tag -a $(TAG) -m 'Setting TAG_VERSION to $(TAG)'                          ; \
	    branchName=`git status | head -n 1 | sed 's/^[# ]*On branch //g'`             ; \
	    git push        origin $$branchName                                           ; \
	    git push --tags origin $$branchName                                           ; \
	  fi                                                                              ; \
	  rm -f /tmp/git_st_$$$$                                                          ;
        else
	  @echo "To git tag do: make gittag TAG=?"
        endif                                                                               

world_update:
	@git status -s > /tmp/git_st_$$$$                                                 ; \
	if [ -s /tmp/git_st_$$$$ ]; then                                                    \
	    echo "All files not checked in => try again"                                  ; \
	elif [ $(srcdir)/configure -ot $(srcdir)/configure.ac ]; then                       \
	    echo "configure is out of date => try again"                                  ; \
	else                                                                                \
	    branchName=`git status | head -n 1 | sed 's/^[# ]*On branch //g'`             ; \
	    git push        github $$branchName                                           ; \
	    git push --tags github $$branchName                                           ; \
	fi                                                                                ; \
	rm -f /tmp/git_st_$$$$                                                            ;
