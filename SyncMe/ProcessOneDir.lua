-- $Id$ --
ProcessOneDir = { }
_DEBUG        = false
local posix   = require("posix")

require("strict")
require("fileOps")
require("string_utils")
require("cvs")

local dbg     = require("Dbg"):dbg()
local access  = posix.access
local chdir   = posix.chdir
local concat  = table.concat
local getcwd  = posix.getcwd
local getenv  = os.getenv
local stdout  = io.stdout
local systemG = _G
local load    = (_VERSION == "Lua 5.1") and loadstring or load

local M = {}

s_processOneDir = {}

local function new(self, cmd)
   local o = {}

   setmetatable(o,self)
   self.__index  = self
   o.vc_cmd     = cmd
   o.tbl         = {}
   o.addCR       = false
   o.cmdT        = {}

   local homeDir = getenv("HOME") or ""

   if (homeDir:sub(-1,-1) == '/') then
      homeDir = homeDir:sub(1,-2)
   end

   local execDir = masterTbl().execDir

   local fn = pathJoin(execDir, ".syncMe.lua")
   local f  = io.open(fn,"r")
   if (f) then
      local s = f:read("*all")
      assert(load(s))()
      f:close()
      for k, v in pairs(systemG.cmdT) do
         o.cmdT[k] = v
      end
   end

   o.home = homeDir
   return o
end

function M.processOneDir(self, cmd)
   if (next(s_processOneDir) == nil) then
      s_processOneDir = new(self, cmd)
   end
   return s_processOneDir
end

function M.process(self,dir)
   dbg.start{"ProcessOneDir:process"}
   local display

   dir, display = M.finddir(self, dir)
   if (dir == nil) then return end

   local wd     = getcwd()
   local cmdT   = self.cmdT
   local vc_cmd = self.vc_cmd
   
   chdir(dir)

   local cmdEntry = nil

   for k in pairs(cmdT) do
      if (isDir(k) or isFile(k)) then
         cmdEntry = cmdT[k]
      end
   end

   if (cmdEntry ~= nil) then
      local branch = cmdEntry.VC_branch_name()
      local output = cmdEntry.VC_cmd(vc_cmd, branch)
      local filter = cmdEntry.VC_filter
      local a      = {}
      for s in output:split("\n") do
         filter(s,a)
      end
      
      if (#a > 0) then
         local tbl = self.tbl
         tbl[#tbl + 1] = { dir = display, msg = concat(a, "\n") , branch = branch}
      else
         self.addCR = true 
         stdout:write(dbg.indent(),"[",vc_cmd,"]: On branch: ", branch,",\t in directory: ",display,"\n")
      end
   end

   chdir(wd)
   dbg.fini()
end

function M.report(self)
   local tbl    = self.tbl
   local vc_cmd = self.vc_cmd
   local status = 0

   if (#tbl > 0 and self.addCR) then
      stdout:write("\n")
      status = -1
   end
   
   for _,v in ipairs(tbl) do
      local display = v.dir
      local msg     = v.msg
      local branch  = v.branch
      stdout:write("[",vc_cmd,"]: On branch: ", branch,",\t in directory: ",display,"\n")
      stdout:write(msg,"\n\n")
   end
   return status
end


function M.finddir(self, dir)
   if (isDir(dir)) then
      return dir, self:displayDir(dir)
   else
      dir = pathJoin(self.home, dir)
      if (isDir(dir)) then
         return dir, self:displayDir(dir)
      end
   end
   return nil, nil
end

function M.displayDir(self, dir)
   local homePat = "^" .. self.home
   local i,j     = dir:find(homePat)
   if (i) then
      dir = "~" .. dir:sub(j+1)
   end
   return dir
end

return M
