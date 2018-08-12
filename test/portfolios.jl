using Test

@testset "Balance update test1" begin
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

    update!(balance, [Cash(USD, 30.), Cash(CNY, 20.), Cash(JPY, 10.)])
    @test getbalance(balance, "USD").value == -40.
    @test getbalance(balance, "CNY").value == 40.
    @test getbalance(balance, "JPY").value == 70.
end

@testset "Balance update test2" begin
    balance = Balance(Dict{String, Cash}())

    balance = update(balance, Cash(USD, 0.))
    balance = update(balance, Cash(CNY, 0.))
    balance = update(balance, Cash(JPY, 0.))
    @test getbalance(balance, "USD").value == 0.
    @test getbalance(balance, "CNY").value == 0.
    @test getbalance(balance, "JPY").value == 0.

    balance = update(balance, Cash(USD, -100.))
    balance = update(balance, Cash(CNY, 60.))
    balance = update(balance, Cash(JPY, 30.))
    @test getbalance(balance, "USD").value == -100.
    @test getbalance(balance, "CNY").value == 60.
    @test getbalance(balance, "JPY").value == 30.

    balance = update(balance, Cash(USD, 30.))
    balance = update(balance, Cash(CNY, -40.))
    balance = update(balance, Cash(JPY, 30.))
    @test getbalance(balance, "USD").value == -70.
    @test getbalance(balance, "CNY").value == 20.
    @test getbalance(balance, "JPY").value == 60.

    balance = update(balance, [Cash(USD, 30.), Cash(CNY, 20.), Cash(JPY, 10.)])
    @test getbalance(balance, "USD").value == -40.
    @test getbalance(balance, "CNY").value == 40.
    @test getbalance(balance, "JPY").value == 70.
end
