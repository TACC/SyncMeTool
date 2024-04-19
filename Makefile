DATE_cmd    := date
VDATE       := $(shell $(DATE_cmd) +'%F %H:%M %:z')
VERSION_SRC := ./SyncMe/Version.lua


gittag:
        ifneq ($(TAG),)
	  @git status -s > /tmp/git_st_$$$$;                                                \
	  if [ -s /tmp/git_st_$$$$ ]; then                                                  \
	    echo "All files not checked in => try again";                                   \
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
