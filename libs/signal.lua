--[[
Copyright (c) 2012-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local Registry = {}
Registry.__index = function(self, key)
	return Registry[key] or (function()
		local t = {}
		rawset(self, key, t)
		return t
	end)()
end

function Registry:register(s, f)
	self[s][f] = f
	return f
end

function Registry:emit(s, ...)
	for f in pairs(self[s]) do
		f(...)
	end
end

function Registry:remove(s, ...)
	local f = {...}
	for i = 1,select('#', ...) do
		self[s][f[i]] = nil
	end
end

function Registry:clear(...)
	local s = {...}
	for i = 1,select('#', ...) do
		self[s[i]] = {}
	end
end

function Registry:emitPattern(p, ...)
	for s in pairs(self) do
		if s:match(p) then self:emit(s, ...) end
	end
end

function Registry:removePattern(p, ...)
	for s in pairs(self) do
		if s:match(p) then self:remove(s, ...) end
	end
end

function Registry:clearPattern(p)
	for s in pairs(self) do
		if s:match(p) then self[s] = {} end
	end
end

-- the module
local function new()
	local registry = setmetatable({}, Registry)

	return setmetatable({
		new           = new,
		register      = function(...) return registry:register(...) end,
		emit          = function(...) registry:emit(...) end,
		remove        = function(...) registry:remove(...) end,
		clear         = function(...) registry:clear(...) end,
		emitPattern   = function(...) registry:emitPattern(...) end,
		removePattern = function(...) registry:removePattern(...) end,
		clearPattern  = function(...) registry:clearPattern(...) end,
	}, {__call = new})
end

return new()