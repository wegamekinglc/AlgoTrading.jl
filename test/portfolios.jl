using Base.Test

@testset "Balance test" begin
    balance = Balance(Dict{String, Cash}())

    update!(balance, Cash(USD, 0.))
    update!(balance, Cash(CNY, 0.))
    update!(balance, Cash(JPY, 0.))
    @test getbalance(balance, "USD").value == 0.
    @test getbalance(balance, "CNY").value == 0.
    @test getbalance(balance, "JPY").value == 0.

    update!(balance, Cash(USD, -100.))
    update!(balance, Cash(CNY, 60.))
    update!(balance, Cash(JPY, 30.))
    @test getbalance(balance, "USD").value == -100.
    @test getbalance(balance, "CNY").value == 60.
    @test getbalance(balance, "JPY").value == 30.

    update!(balance, Cash(USD, 30.))
    update!(balance, Cash(CNY, -40.))
    update!(balance, Cash(JPY, 30.))
    @test getbalance(balance, "USD").value == -70.
    @test getbalance(balance, "CNY").value == 20.
    @test getbalance(balance, "JPY").value == 60.
end
