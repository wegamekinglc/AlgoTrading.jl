using Test
using Dates

include("../../src/datas/okex.jl")

@testset "Contract generating test" begin
    current = DateTime("2018-07-07T15:00:00")
    thisweek = Okex.thisweekcontract(current)
    @test thisweek == DateTime("2018-07-13T16:00:00")

    nextweek = Okex.nextweekcontract(current)
    @test nextweek == DateTime("2018-07-20T16:00:00")

    thisquarter = Okex.thisquartercontract(current)
    @test thisquarter  == DateTime("2018-09-28T16:00:00")

end
