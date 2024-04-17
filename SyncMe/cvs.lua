_DEBUG      = false
local posix = require("posix")

require("strict")
require("string_utils")
require("fileOps")


local function repoName()
   local cwd  = posix.getcwd()
   local f    = io.open(pathJoin(cwd, "CVS/Root"))
   local repo = f:read("*line")
   f:close()

   local i,j  = repo:find(":")
   if (i) then
      repo = repo:sub(j+1):trim()
   end

   local f    = io.open(pathJoin(cwd, "CVS/Repository"))
   local dir  = f:read("*line")
   f:close()

   repo = pathJoin(repo, dir)

   return repo
   
end

function cvs_status()

   local repo = repoName()

   local output = capture("cvs status 2>&1")

   local fileA     = {}
   local fileEntry = {}

   for s in output:split("\n") do
      local nextLine = false

      local i, j = s:find("^?")
      if (i) then
         local name = s:sub(j+1):trim()
         fileA[#fileA+1] = { name = name,  status = "?         ", sname = name }
         nextLine = true
      end

      if (not nextLine) then
         i, j = s:find("^File:%s+")
         if (i) then
            local k, l = s:find("Status:%s+")
            fileEntry.sname  = s:sub(j+1,k-1):trim()
            fileEntry.status = s:sub(l):trim()
            nextLine = true
         end
      end

      if (not nextLine) then
         i, j = s:find("Repository revision:")
         if (i) then
            local k  = s:find("/")
            local fn = s:sub(k):trim()
            fn       = fn:sub(1,-3)
            i, j     = fn:find(repo)
            if (not j) then
               print ("line: ",s)
               print ("fn: ",fn)
               os.exit(1)
            end
            fn              = fn:sub(j+1)
            fileEntry.name  = fn
            fileA[#fileA+1] = fileEntry
            fileEntry       = {}

            nextLine        = true
         end
      end
   end

   local a = {}

   for _,v in ipairs(fileA) do
      if (v.status ~= "Up-to-date") then
         a[#a + 1] = v.status .. "       " .. v.name
      end
   end

   return table.concat(a,"\n")
end
