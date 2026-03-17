local M = {}
M.__index = M

function M:init()
   self.options = {}
   return self
end

function M:append(opts)
   for k, v in pairs(opts) do
      self.options[k] = v
   end
   return self
end

return M
