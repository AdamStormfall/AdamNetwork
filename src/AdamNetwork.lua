--[[

General API:

AdamNetwork:BindEvent(EventName : string, function(...)
AdamNetwork:BindFunction(FunctionName : string, function(...)

AdamNetwork:GetEvent(EventName : string) -- returns: RemoteEvent
AdamNetwork:GetFunction(FunctionName : string) -- returns: RemoteFunction

AdamNetwork:FireEvent(EventName : string, ...)
AdamNetwork:InvokeFunction(FunctionName : string, ...)

-- Server API:

AdamNetwork.newEvent(EventName : string) -- returns: RemoteEvent
AdamNetwork.newFunction(FunctionName : string) -- returns: RemoteFunction

--

MIT License

Copyright (c) 2023 @AdamStormfall

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

local AdamNetwork = {}

AdamNetwork.__index = AdamNetwork

local RunService = game:GetService("RunService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Communication, FunctionsFolder, EventsFolder

if RunService:IsServer() then
	Communication = Instance.new("Folder",ReplicatedStorage)
	Communication.Name = "Communication"
	
	FunctionsFolder = Instance.new("Folder",Communication)
	FunctionsFolder.Name = "Functions"
	
	EventsFolder = Instance.new("Folder",Communication)
	EventsFolder.Name = "Events"
else
	Communication = ReplicatedStorage:WaitForChild("Communication")
	FunctionsFolder = Communication:WaitForChild("Functions")
	EventsFolder = Communication:WaitForChild("Events")
end

function AdamNetwork.newEvent(EventName : string)
	if RunService:IsServer() then
		local RemoteEvent = Instance.new("RemoteEvent")
		RemoteEvent.Name = EventName
		RemoteEvent.Parent = EventsFolder
		
		return RemoteEvent
	end
end

function AdamNetwork.newFunction(FunctionName : string)
	if RunService:IsServer() then
		local RemoteFunction = Instance.new("RemoteFunction")
		RemoteFunction.Name = FunctionName
		RemoteFunction.Parent = FunctionsFolder
		
		return RemoteFunction
	end
end

function AdamNetwork:GetEvent(EventName : string)
	if EventsFolder then
		return EventsFolder:FindFirstChild(EventName)
	end
end

function AdamNetwork:GetFunction(FunctionName : string)
	if FunctionsFolder then
		return FunctionsFolder:FindFirstChild(FunctionName)
	end
end

function AdamNetwork:FireEvent(EventName : string, ...)
	if EventsFolder:FindFirstChild(EventName) then
		local Event = EventsFolder[EventName]
		
		if RunService:IsServer() then
			Event:FireServer(...)
		else
			Event:FireClient(...)
		end
	end
end

function AdamNetwork:InvokeFunction(FunctionName : string, ...)
	if FunctionsFolder:FindFirstChild(FunctionName) then
		local RemoteFunction = FunctionsFolder[FunctionName]
		
		if RunService:IsServer() then
			RemoteFunction:InvokeServer(...)
		else
			RemoteFunction:InvokeClient(...)
		end
	end
end

function AdamNetwork:BindEvent(EventName : string, Function)
	if EventsFolder:FindFirstChild(EventName) then
		local Event = EventsFolder[EventName]
		
		if RunService:IsServer() then
			Event.OnServerEvent:Connect(Function)
		else
			Event.OnClientEvent:Connect(Function)
		end
	end
end

function AdamNetwork:BindFunction(FunctionName : string, Function)
	if FunctionsFolder:FindFirstChild(FunctionName) then
		local RemoteFunction = FunctionsFolder[FunctionName]

		if RunService:IsServer() then
			RemoteFunction.OnServerInvoke = Function
		else
			RemoteFunction.OnClientInvoke = Function
		end
	end
end

return AdamNetwork
