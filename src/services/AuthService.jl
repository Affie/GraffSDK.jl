include("../entities/Auth.jl")

authEndpoint = "api/v0/auth"

"""
    authenticate(config::SynchronyConfig, authRequest::AuthRequest)::AuthResponse
Authenticates a user and produces a token for further user.
Return: The authentication token.
"""
function authenticate(config::SynchronyConfig, authRequest::AuthRequest)::AuthResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$authEndpoint/authorize"
    response = post(url; data=JSON.json(authRequest))
    if(statuscode(response) != 200)
        error("Error authorizing, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return Unmarshal.unmarshal(AuthResponse, JSON.parse(readstring(response)))
    end
end

"""
    refreshToken(config::SynchronyConfig, authResponse::AuthResponse)::AuthResponse
Refreshes a token from an older token. Use this when the token is about to expire.
Return: The updated token.
"""
function refreshToken(config::SynchronyConfig, authResponse::AuthResponse)::AuthResponse
    url = "$(config.apiEndpoint):$(config.apiPort)/$authEndpoint/authorize"
    response = post(url; data=JSON.json(authResponse))
    if(statuscode(response) != 200)
        error("Error authorizing, received $(statuscode(response)) with body '$(readstring(response))'.")
    else
        return Unmarshal.unmarshal(AuthResponse, JSON.parse(readstring(response)))
    end
end
