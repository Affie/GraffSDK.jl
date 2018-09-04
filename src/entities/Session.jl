# import Base: show

"""
A summary response for a single session.
"""
mutable struct SessionResponse
    id::String
    links::Dict{String, String}
end

"""
A list of session response summaries.
"""
mutable struct SessionsResponse
    sessions::Vector{SessionResponse}
    links::Dict{String, String}
end

"""
The structure used for detailed session requests.
"""
mutable struct SessionDetailsRequest
    id::String
    description::String
    initialPoseType::String
    shouldInitialize::Bool
    SessionDetailsRequest(id::String, description::String, initialPoseType::String="", shouldInitialize::Bool=true) = new(id, description, initialPoseType, shouldInitialize)
end

"""
The structure used for detailed session responses.
"""
mutable struct SessionDetailsResponse
    id::String
    description::String
    robotId::String
    userId::String
    initialPoseType::String
    nodeCount::Int
    createdTimestamp::String
    lastSolvedTimestamp::String # Can remove nullable as soon as we stabilize.
    isSolverEnabled::Int # If 1 then the ad-hoc solver will pick up on it, otherwise will ignore this session.
    links::Dict{String, String}
end

# function show(io::IO, obj::SessionDetailsResponse)
#     print("\r\nSession: \r\n - ID: $(obj.id)\r\n  - Description: $(obj.description)\r\n  - Node count: $(obj.nodeCount)")
# end

"""
The structure used to briefly describe a node in a response.
"""
mutable struct NodeResponse
    id::Int
    label::String
    links::Dict{String, String}
end

# function show(io::IO, obj::NodeResponse)
#     print("\r\nNode: \r\n - ID: $(obj.id)\r\n  - Name: $(obj.name)")
# end

"""
The structure used to briefly describe a set of nodes in a response.
"""
mutable struct NodesResponse
    nodes::Vector{NodeResponse}
    links::Dict{String, String}
end

# function show(io::IO, obj::NodesResponse)
#     print("\r\n$(obj.nodes)")
# end

"""
The structure describing a complete node in a response.
"""
mutable struct NodeDetailsResponse
    id::Int
    label::String
    sessionIndex::Int
    properties::Dict{String, Any}
    packed::Dict{String, Any}
    labels::Vector{String}
    links::Dict{String, String}
end

"""
The structure describing a high-level add-odometry request.
"""
struct AddOdometryRequest
    timestamp::String
    deltaMeasurement::Vector{Float64}
    pOdo::Array{Float64, 2}
    N::Nullable{Int64}
    AddOdometryRequest(deltaMeasurement::Vector{Float64}, pOdo::Array{Float64, 2}) = new(string(Dates.Time(now(Dates.UTC))), deltaMeasurement, pOdo, nothing)
end

"""
Result of an AddOdometryRequest - provides the variable and factor details for the created node.
"""
struct AddOdometryResponse
    variable::NodeResponse
    factor::NodeResponse
end

"""
The parameters structure for CreateVariable request.
"""
struct VariableRequest
    label::String
    variableType::String
    N::Nullable{Int64}
    labels::Vector{String}
    VariableRequest(label::String, variableType::String, N::Nullable{Int64}, labels::Vector{String}) = new(label, variableType, N, labels)
    VariableRequest(label::String, variableType::String, labels::Vector{String}) = new(label, variableType, nothing, labels)
    VariableRequest(label::String, variableType::String) = new(label, variableType, nothing, String[])
end

"""
Result of a CreateVariableRequest.
"""
struct VariableResponse
end

"""
Parameters for a general distribution request - the distribution type and the accompanying parameters.
"""
struct DistributionRequest
    distType::String
    params::Vector{Float64}
end

"""
A 2D bearing+range request body.
"""
struct BearingRangeRequest
    pose2Id::String
    point2Id::String
    bearing::DistributionRequest
    range::DistributionRequest
end

"""
Parameter for a CreateFactor request - the factor type and packed factor details.
"""
struct FactorBody
    factorType::String
    packedFactorType::String
    encoding::String
    body::String
end

"""
The body of a CreateFactor request - the variables to be linked, the body of the factor, and whether it should be autoinitialized and is ready for solving.
"""
struct FactorRequest
    variables::Vector{String}
    body::FactorBody
    autoinit::Nullable{Bool}
    ready::Nullable{Bool}
end
