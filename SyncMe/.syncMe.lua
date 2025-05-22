translateT =    { pull = "up", up     = "up", update = "up",
                  st   = "st", status = "st" }
gitTranslateT = { pull = "pull --tags",   up     = "pull --tags",    update = "pull --tags",
                  st   = "status", status = "status" }

cmdT = {
   [".svn"] = { 
      VC_branch_name = function ()
                         return ""
                       end,
      VC_cmd = function (cmdStr, branch)
                 cmdStr = translateT[cmdStr]
                 if (cmdStr) then
                    return capture("svn " .. cmdStr .. " 2>&1")
                 end
                 return ""
              end,
      VC_filter = function (line, a)
                     if (line:len() < 1) then
                        return
                     end
                     local filterA = {
                        "At revision",
                        "External at revision",
                        "Fetching external item",
                        "Warning: untrusted X11 forwarding",
                        "Warning: No xauth data; using fake authentication data for X11 forwarding",
                        "Performing status on external item",
                        "X   ",
                     }
                     for _, v in ipairs(filterA) do
                        if (line:find(v)) then
                           return
                        end
                     end
                     
                     -- if we make it here then we are keeping this line
                     a[#a + 1] = line
                  end,

   },
   [".git"] = { 
      VC_branch_name = function ()
                          local branch_str = capture("git status | head -n 1"):sub(1,-2)
                          if (branch_str == "Not currently on any branch." ) then
                             return "master"
                          end
                          local i,j,branch
                          i, j, branch = branch_str:find(".*On branch  *(.*)")
                          if (branch) then
                             return branch
                          end
                          i, j, branch = branch_str:find(" *HEAD detached at (.*)")
                          if (branch) then
                             return branch
                          end
                          return ""
                       end,

      VC_cmd = function (cmdStr, branch)
                 local extra = ""
                 cmdStr      = gitTranslateT[cmdStr]
                 if (cmdStr == "pull" or cmdStr == "up" or cmdStr == "update" and branch ~= "master" ) then
                    extra = " origin ".. branch .. " "
                 --elseif (cmdStr == "status") then
                 --   extra = " -uno"
                 end
                 if (cmdStr) then
                    local cmd = "git " .. cmdStr .. extra .. " 2>&1"
                    return capture(cmd)
                 end
                 return ""
              end,
      VC_filter = function (line, a)
                     if (line:len() < 1) then
                        return
                     end
                     local filterA = {
                        "# On branch",
                        "#%s*$",
                        "^ %* branch ",
                        "On branch",
                        "Your branch is up%-to%-date with",
                        "Your branch is up to date with",
                        "^From ",
                        "nothing to commit",
                        "Already up%-to%-date",
                        "Already up to date",
                        "Everything up%-to%-date",
                        "Everything up to date",
                        "Fetching external item",
                        "X11 forwarding request failed",
                        "Warning: untrusted X11 forwarding",
                        "Warning: No xauth data; using fake authentication data for X11 forwarding",
                        "Performing status on external item",
                        "X11 forwarding request failed on channel 0",
                        "X   ",
                        "^SSH: Server",
                        "It took",
                        "may speed it up, but you have to be careful not to forget to add",
                        "new files yourself",
                        "See"
                     }
                     for _, v in ipairs(filterA) do
                        if (line:find(v)) then
                           return
                        end
                     end
                     
                     -- if we make it here then we are keeping this line
                     a[#a + 1] = line
                  end,

   },
   ["CVS"] = {
      VC_branch_name = function ()
                         return ""
                       end,
      VC_cmd = function (cmdStr, branch)
                  cmdStr = translateT[cmdStr]
                  if (cmdStr == "st") then
                     return cvs_status()
                  else
                     return capture("cvs " .. cmdStr .. " 2>&1")
                  end
               end,
      VC_filter = function (line, a)
                     if (line:len() < 1) then
                        return
                     end
                     local filterA = {"cvs update:",
                     }
                     for _, v in ipairs(filterA) do
                        if (line:find(v)) then
                           return
                        end
                     end
                     
                     -- if we make it here then we are keeping this line
                     a[#a + 1] = line
                  end,

   }
                 
}
