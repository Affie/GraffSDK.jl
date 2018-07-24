# Enable mocking
using Mocking
Mocking.enable()

# Standard imports
using Base.Test
using FactCheck
using HTTP

using SynchronySDK

mockConfig = SynchronyConfig("http://mock", "9000", "", "", "")

include("User.jl")
include("Session.jl")