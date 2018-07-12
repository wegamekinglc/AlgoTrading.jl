using Base.Test

include("../src/assets.jl")

@testset "Asset profile test" begin
    profile = AssetProfile(Stock, "XSHE", 0.0001)
    @test profile.assettype == Stock
    @test profile.exchange == "XSHE"
    @test profile.commission == 0.0001
end

@testset "Asset test" begin
    profile = AssetProfile(Stock, "XSHE", 0.0001)
    asset = Asset("600000", profile, 0.0015)
    @test asset.profile == profile
    @test asset.symbol == "600000"
    @test asset.slippage == 0.0015
end
