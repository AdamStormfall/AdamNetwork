# AdamNetwork
A wrapper for Roblox "Network" classes.

* General API:

AdamNetwork:BindEvent(EventName : string, function(...)
AdamNetwork:BindFunction(FunctionName : string, function(...)

AdamNetwork:GetEvent(EventName : string) | returns: RemoteEvent
AdamNetwork:GetFunction(FunctionName : string) | returns: RemoteFunction

AdamNetwork:FireEvent(EventName : string, ...)
AdamNetwork:InvokeFunction(FunctionName : string, ...)

* Server API:

AdamNetwork.newEvent(EventName : string) | returns: RemoteEvent
AdamNetwork.newFunction(FunctionName : string) | returns: RemoteFunction
