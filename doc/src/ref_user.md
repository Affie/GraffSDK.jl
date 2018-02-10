# User Service
User calls are used to create, update, retrieve, or delete users from Synchrony. It is also used to retrieve runtime configuration information per user (e.g. streaming connection information).

## User Structures
```@docs
UserRequest
UserResponse
UserConfig
KafkaConfig
ErrorResponse
```

## User Functions
```@docs
createUser
getUser
updateUser
deleteUser
getUserConfig
```
