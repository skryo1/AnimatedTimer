local Timer = {}
Timer.__index = Timer

local substring = string.sub

local Debris = game:GetService("Debris")

local knit = require(game.ReplicatedStorage.Knit)
local spr = require(knit.Util.spr)

local last = nil

local function secondToMinuteFormat(secondsInput) -- 365
	

	local minutes, seconds = tostring((secondsInput - secondsInput % 60) / 60), tostring((secondsInput - (secondsInput - secondsInput % 60)))
	
	local minute01 = #minutes >= 2 and substring(minutes, 1, 1) or "0"
	local minute02 = #minutes >= 2 and substring(minutes, 2, 2) or substring(minutes, 1, 1)
	
	local second01 = #seconds >= 2 and substring(seconds, 1, 1) or "0"
	local second02 = #seconds >= 2 and substring(seconds, 2, 2) or substring(seconds, 1, 1)
	
	return {
		minute01,
		minute02,
		second01,
		second02
	}
	
end


local function updateDigit(digitParent, newTime)
	
	
	local oldDigits = {}
	local children = digitParent:GetChildren()
	for _, k in ipairs(children) do
		if k:IsA("TextLabel") then
			table.insert(oldDigits, k)
		end
	end
	
	local old
	
	for _, oldDigit in ipairs(oldDigits) do
		old = oldDigit
		spr.target(oldDigit, 0.6, 4, {
			Position = UDim2.fromScale(0.5, 1.5)
		})
		task.delay(0.25, function()
			oldDigit:Destroy()
		end)
	end
	
	local newDigitInstance = old:Clone()

	
	newDigitInstance.Parent = digitParent
	newDigitInstance.Position = UDim2.fromScale(0.5, -1.5)
	newDigitInstance.Text = tostring(newTime)
	
	spr.target(newDigitInstance, 0.6, 4, {
		Position = UDim2.fromScale(0.5, 0.5)
	})

	
	
end


function Timer.new(instance)
	
	local self = setmetatable({}, Timer)
	self.timer = instance
	self.clock = instance.Clock
	

	return self
	
end


function Timer:Update(secondsTime)
	
	local times = {
		[1] = self.clock["Minute_1"],
		[2] = self.clock["Minute_2"],
		[3] = self.clock["Second_1"],
		[4] = self.clock["Second_2"]
	}
	
	last = {
		times[1]:FindFirstChild("Digit").Text,
		times[2]:FindFirstChild("Digit").Text,
		times[3]:FindFirstChild("Digit").Text,
		times[4]:FindFirstChild("Digit").Text
	}
	

	local formattedTime = secondToMinuteFormat(secondsTime)
	if last ~= nil then
		for currIndex, time in ipairs (last) do
			if time ~= formattedTime[currIndex] then
				updateDigit(times[currIndex], formattedTime[currIndex])

			end
		end
	end
	last = formattedTime
end



return Timer

