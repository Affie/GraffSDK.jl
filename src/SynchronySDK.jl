module SynchronySDK

# Imports
using HTTP, JSON, Unmarshal
using Formatting
using Graphs
using DocStringExtensions
using ProgressMeter

import Base.show

# Utility functions
"""
$(SIGNATURES)
Internal fix for Unmarshal not being able to deserialize dictionaries.
https://github.com/lwabeke/Unmarshal.jl/issues/9
This still seems to be an issue even with 0.1.1 of Unmarshal.
"""
function _unmarshallWithLinks(responseBody::String, t::Type)
    j = JSON.parse(responseBody)
    links = j["links"]
    j["links"] = Dict{String,String}()
    unmarshalled = Unmarshal.unmarshal(t, j)
    unmarshalled.links = links
    return unmarshalled
end

"""
$(SIGNATURES)
Load a config file from a file name.
"""
function loadConfigFile(filename::String)::SynchronyConfig
    if !isfile(filename)
        error("Cannot locate the configuration file '$filename'. Please check that it exists.")
    end
    configFile = open("synchronyConfig.json")
    configData = JSON.parse(readstring(configFile))
    close(configFile)
    synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)
    return synchronyConfig
end

# Includes
include("./entities/SynchronySDK.jl")

include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Robot.jl")
include("./services/RobotService.jl")

include("./entities/Session.jl")
include("./entities/Data.jl")
include("./services/DataHelpers.jl")
include("./services/SessionService.jl")
include("./services/StatusService.jl")
include("./services/VisualizationService.jl")

include("./entities/Cyphon.jl")

# Exported functions
function nodeDetail2ExVertex(nodeDetails::SynchronySDK.NodeDetailsResponse)::Graphs.ExVertex
    vert = Graphs.ExVertex(nodeDetails.sessionIndex, nodeDetails.name)
    vert.attributes = Graphs.AttributeDict()
    vert.attributes = nodeDetails.properties

    # populate the data container
    vert.attributes["data"] = nodeDetails.packed
    return vert
end

"""
$SIGNATURES
Produces the authorization and sends the REST request.
"""
function _sendRestRequest(synchronyConfig::SynchronyConfig, verbFunction, url::String; data::String="", headers::Dict{String, String}=Dict{String, String}(), debug::Bool=false)::HTTP.Response
    verbFunction(url, headers, data;
        aws_authorization=true,
        aws_service="execute-api",
        aws_region=synchronyConfig.region,
        aws_access_key_id=synchronyConfig.accessKey,
        aws_secret_access_key=synchronyConfig.secretKey)
end

# Exports
export SynchronyConfig, ErrorResponse
export getStatus, printStatus
export UserRequest, UserResponse, KafkaConfig, UserConfig, addUser, getUser, updateUser, deleteUser, getUserConfig
export RobotRequest, RobotResponse, RobotsResponse, getRobots, getRobot, addRobot, updateRobot, deleteRobot, getRobotConfig, updateRobotConfig
export SessionDetailsRequest, SessionDetailsResponse, addSession, getSessions, isSessionExisting, getSession, deleteSession, putReady
export BigDataElementRequest, BigDataEntryResponse, BigDataElementResponse
export getDataEntries, getDataElement, getRawDataElement, addDataElement, updateDataElement, addOrUpdateDataElement, deleteDataElement
export encodeJsonData, encodeBinaryData, readFileIntoDataRequest, isSafeToJsonSerialize
export NodeResponse, NodesResponse, BigDataElementResponse, NodeDetailsResponse, getNodes, getNode
export AddOdometryRequest, AddOdometryResponse, NodeResponseInfo, addOdometryMeasurement
export VariableRequest, VariableResponse, BearingRangeRequest, BearingRangeResponse, DistributionRequest, addVariable, addBearingRangeFactor
export visualizeSession
# For testing
export _unmarshallWithLinks, loadConfigFile
export nodeDetail2ExVertex
end
