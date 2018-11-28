using Base
using JSON, Unmarshal
using SynchronySDK
using UUIDs

# 1. Get a Synchrony configuration
# Assume that you're running in local directory
cd(joinpath(Pkg.dir("SynchronySDK"),"examples"))
configFile = open("synchronyConfig_Local.json")
configData = JSON.parse(readstring(configFile))
close(configFile)
synchronyConfig = Unmarshal.unmarshal(SynchronyConfig, configData)

# 2a. User creation and retrieval
# In Synchrony, users are the root of all robots,
# so after creating a user, you can create a bot
# and associate it with data sessions
# Note that we'll create this for you normally, but providing it here to demonstrate
# how a user is associated with an organization.
newUser = UserRequest(synchronyConfig.userId, "NewUser", "email@email.com", "N/A", "Student", "Student", string(uuid4()))
retUser = addUser(synchronyConfig, newUser)
@show retUser
# Now we can get it as well if we want
getUser = getUser(synchronyConfig, newUser.id)
if (JSON.json(retUser) != JSON.json(getUser))
    error("Hmm, users should match")
end

# 2b. Config retrieval
# During runtime, we would skip step 3a and just retrieve the configuration
# for our user. This contains all the parameters required to ingest or retrieve
# data from the system.
runtimeConfig = getUserConfig(synchronyConfig, newUser.id)
