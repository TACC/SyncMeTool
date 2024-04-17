require("fileOps")

local VCdirT = { 
   [".svn"] = 1,
   [".git"] = 1,
   ["CVS"]  = 1,
   [".hg"]  = 1,
   [".bzr"] = 1,
}

local homeDir = os.getenv("HOME") or ""

local function locateDir(dir)
   if (isDir(dir)) then
      return dir
   else
      dir = pathJoin(homeDir, dir)
      if (isDir(dir)) then
         return dir
      end
   end
   return nil
end
   

function findVCDir(path, dirT)
   local found = false
   local f
   local dirA = {}
   path = locateDir(path)
   if (path == nil) then
      return
   end
   for file in lfs.dir(path) do
      if file ~= "." and file ~= ".." then
	 f          = path..'/'..file
	 local attr = lfs.attributes (f)
	 if ( VCdirT[file] ~= nil  and attr and (attr.mode == "directory" or attr.mode == "file")) then
	    dirT[path] = 1
	    found   = true
	    break
	 elseif (attr and attr.mode == "directory") then
	    dirA[#dirA+1] = f
	 end
      end
   end

   if (not found) then
      for _, dir in ipairs(dirA) do
	 findVCDir(dir,dirT)
      end
   end
end
