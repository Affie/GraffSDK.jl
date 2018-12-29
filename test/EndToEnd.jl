using Test
using GraffSDK
using UUIDs
using Caesar

@testset "End-To-End Tests" begin

@testset "Configuration" begin
    # 1. Import the initialization code.
    cd(joinpath(dirname(pathof(GraffSDK)), "..", "examples"))
    # 1a. Create a Configuration
    global config = loadGraffConfig("graffConfigVirginia.json");
    # global config = loadGraffConfig("synchronyConfigLocal.json");
    @test getGraffConfig() == config
    global config = getGraffConfig()
    config.userId = "QA"
    config.robotId = "QARobot_"*replace(string(uuid4()), "-" => "")
    config.sessionId = "QASession_"*replace(string(uuid4()), "-" => "")
end

@testset "User and User Config" begin
    global config = getGraffConfig()
    @test getUser(config.userId) != nothing
end

@testset "Robot Creation and Configuration" begin
    @test length(getRobots().robots) > 0
    @test isRobotExisting() == false
    newRobot = RobotRequest(config.robotId, "QARobot", "QA Robot", "Active");
    robot = addRobot(newRobot);
    @test getRobot().id == robot.id
    @test isRobotExisting() == true

    robotConfig = getRobotConfig()
    @test robotConfig != nothing
    robotConfig["TestParam"] = "This is a test configuration parameter"
    #updateRobotConfig(robotConfig)
    #@test haskey(getRobotConfig(), "TestParam")
end

@testset "Session Creation" begin
    global config = getGraffConfig()
    @test isSessionExisting() == false
    newSessionRequest = SessionDetailsRequest(config.sessionId, "QA Test dataset.", "Pose2")
    session = addSession(newSessionRequest)
    @test session != nothing
    @test getSession() != nothing
    @test length(ls().nodes) == 1
    # Update session
end

@testset "Classical Variable and Factor Creation" begin
    deltaMeasurement = [1.0, 1.0, 0.05]
    pOdo = [0.01 0 0; 0 0.005 0; 0 0 0.02]
    pp = Pose2Pose2(MvNormal(deltaMeasurement, pOdo.^2))
    addVariable(:x1, Pose2, String[])
    addFactor([:x0;:x1], pp)
    # Landmark
    addVariable(:l1, Point2, ["LANDMARK"])
    p2br = Pose2Point2BearingRange(Normal(0.1,0.1), Normal(0.1, 0.1))
    addFactor([:x0; :l1], p2br)
    # Waiting for completion
    waitsLeft = 10
    while getSessionBacklog() > 0 && waitsLeft > 0
        @info "...Session backlog currently has $(getSessionBacklog()) entries, waiting until complete..."
        sleep(3)
        waitsLeft-=1;
    end
    if getSessionBacklog() > 0
        error("Nope, graph was not completely consumed in time - failing!")
    end
    if getSessionDeadQueueLength() > 0
        error("Nope, some messages ended up in dead queue... check it:")
        @info getSessionDeadQueueMessages()
    end
    nodes = ls()
    @test length(nodes.nodes) == 3

    # Put ready
    @test putReady(true)
end

@testset "Listing and Getting Variables" begin
    nodes = ls()
    @test length(nodes.nodes) == 3
    @test map(n -> n.label, nodes.nodes) == ["l1", "x0", "x1"]
    @test getNode("l1").label == "l1"
    @test getNode("x0").label == "x0"
    @test getNode("x1").label == "x1"
end

@testset "Odometry and BearingRange Creation" begin
end

@testset "Data Setting/Getting" begin
    @test length(getDataEntries(getNode("x0"))) == 0
    data = "TEST DATA.............................................................."
    dataUpdate = "UPDATED"
    setData(getNode("x0"), "testId", data)
    @test length(getDataEntries(getNode("x0"))) == 1
    setData(getNode("x0"), "testId2", data)
    @test length(getDataEntries(getNode("x0"))) == 2
    setData(getNode("x0"), "testId", data)
    @test length(getDataEntries(getNode("x0"))) == 2
    @test getData(getNode("x0"), "testId").data == dataUpdate
    @test getRawData(getNode("x0"), "testId") == dataUpdate
    deleteData(getNode("x0"), "testId2")
    @test length(getDataEntries(getNode("x0"))) == 1
end

@testset "Import/Export" begin
    file = "testFile.jld2"
    if isfile(file)
        rm(file)
    end
    exportSessionJld(file)
    @test isfile(file)

    # TODO: Import
end

@testset "Negative Test Cases" begin
end

# New stuff!

@testset "ZMQ Variable and Factor Creation" begin
end

@testset "Graff Editing" begin
end

end
