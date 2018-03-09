include("../entities/User.jl")

userEndpoint = "api/v0/users/{1}"
configEndpoint = "api/v0/users/{1}/config"

"""
    createUser(config::SynchronyConfig, user::UserRequest)::UserResponse
Create a user in Synchrony.
Return: Returns the created user.
"""
function createUser(config::SynchronyConfig, user::UserRequest)::UserResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(userEndpoint, user.id))"
    response = post(url; headers = Dict(), data=JSON.json(user))
    if(statuscode(response) != 200)
        error("Error creating user, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), UserResponse)
    end
end

"""
    getUser(auth::AuthResponse, userId::String)::UserResponse
Gets a user given the user ID.
Return: The user for the given user ID.
"""
function getUser(config::SynchronyConfig, userId::String)::UserResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(userEndpoint, userId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting user, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), UserResponse)
    end
end

"""
    updateUser(config::SynchronyConfig, user::UserRequest)::UserResponse
Update a user.
Return: The updated user from the service.
"""
function updateUser(config::SynchronyConfig, user::UserRequest)::UserResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(userEndpoint, user.id))"
    response = put(url; headers = Dict(), data=JSON.json(user))
    if(statuscode(response) != 200)
        error("Error updating user, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), UserResponse)
    end
end

"""
    deleteUser(config::SynchronyConfig, userId::String)::UserResponse
Delete a user given a user ID.
NOTE: All robots must be deleted first, the call will fail if robots are still associated to the user.
Return: The deleted user.
"""
function deleteUser(config::SynchronyConfig, userId::String)::UserResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(userEndpoint, userId))"
    response = delete(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error deleting user, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return _unmarshallWithLinks(readstring(response), UserResponse)
    end
end

"""
    getUserConfig(config::SynchronyConfig, userId::String)::UserConfig
Get a user config given a user ID.
The user config contains all the runtime parameters for any robot.
Return: The user config.
"""
function getUserConfig(config::SynchronyConfig, userId::String)::UserConfig
    url = "$(config.apiEndpoint):$(config.apiPort)/$(format(configEndpoint, userId))"
    response = get(url; headers = Dict())
    if(statuscode(response) != 200)
        error("Error getting user configuration, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return Unmarshal.unmarshal(UserConfig, JSON.parse(readstring(response)))
    end
end
