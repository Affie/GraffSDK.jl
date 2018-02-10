module SynchronySDK

# Imports
using Requests, JSON, Unmarshal
using Formatting

# Utility functions
"""
    _unmarshallWithLinks(responseBody::String, t::Type)
Internal fix for Unmarshall not being able to deserialize dictionaries.
https://github.com/lwabeke/Unmarshal.jl/issues/9
"""
function _unmarshallWithLinks(responseBody::String, t::Type)
    j = JSON.parse(responseBody)
    links = j["links"]
    delete!(j, "links")
    unmarshalled = Unmarshal.unmarshal(t, j)
    unmarshalled.links = links
    return unmarshalled
end

# Includes
include("./entities/SynchronySDK.jl")

include("./entities/Auth.jl")
include("./services/AuthService.jl")

include("./entities/User.jl")
include("./services/UserService.jl")

include("./entities/Session.jl")
include("./entities/Robot.jl")
include("./entities/Cyphon.jl")

# Exports
export SynchronyConfig
export AuthRequest, AuthResponse, authenticate, refreshToken
export UserRequest, UserResponse, KafkaConfig, UserConfig, ErrorResponse, createUser, getUser, updateUser, deleteUser, getUserConfig
# For testing
export _unmarshallWithLinks

# Internal definitions
robotsEndpoint = "api/v0/users/{1}/robots/{2}"
sessionsEndpoint = "api/v0/robots/{1}/sessions/{2}"
nodeEndpoint = "api/v0/robots/{1}/sessions/{2}/nodes/{3}"
dataEndpoint = "api/v0/robots/{1}/sessions/{2}/nodes/{3}/bigData/{4}"

end
