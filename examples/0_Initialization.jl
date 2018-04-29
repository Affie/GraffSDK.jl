using Base
using JSON, Unmarshal
using SynchronySDK
using SynchronySDK.DataHelpers

# 0. Constants
robotId = "Hackathon"
sessionId = "HexagonalDrive"

# 1. Get a Synchrony configuration
println(" - Retrieving Synchrony Configuration...")
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

println(" --- Configuring Synchrony example for:")
println("  --- User: $(synchronyConfig.userId)")
println("  --- Robot: $(robotId)")
println("  --- Session: $(sessionId)")
