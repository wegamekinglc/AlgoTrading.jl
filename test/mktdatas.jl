using Base.Test
using Base.DateTime

include("../src/mktdatas.jl")

@testset "Bar data structure test" begin
    bar = Bar(DateTime(2018, 7, 9, 14, 0, 0), 18., 20., 12.5, 15.0, 400.)
    @test bar.timestamp == DateTime(2018, 7, 9, 14, 0, 0)
    @test bar.open ≡ 18.
    @test bar.high ≡ 20.
    @test bar.low ≡ 12.5
    @test bar.close ≡ 15.0
    @test bar.volume ≡ 400.
end
