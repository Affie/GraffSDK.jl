"""
The structure used for user requests.
"""
mutable struct UserRequest
  id::String
  name::String
  email::String
  address::String
  organization::String
  licenseType::String
  billingId::String
end

"""
The response structure for user calls.
"""
mutable struct UserResponse
  userId::String
  email::String
  address::String
  organization::String
  licenseType::String
  billingId::String
  id::String
  name::String
  createdTimestamp::String
  lastUpdatedTimestamp::String
  links::Dict{String, Any}
end
