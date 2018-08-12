import Base.==
using Test
using UUIDs: uuid1

@testset "Market order test" begin
    uid = uuid1()
    order = MarketOrder(uid, "AAPL", 100., 1)
    @test order.id == uid
    @test order.symbol == "AAPL"
    @test order.amount == 100.
    @test order.direction == 1
end

@testset "Limit order test" begin
    uid = uuid1()
    order = LimitOrder(uid, "IBM", 100., -1, 25.)
    @test order.id == uid
    @test order.symbol == "IBM"
    @test order.amount == 100.
    @test order.direction == -1
    @test order.limitprice == 25.0
end

@testset "Order equality test" begin
    uid1 = uuid1()
    uid2 = uuid1()

    order1 = MarketOrder(uid1, "AAPL", 100., 1)
    order2 = MarketOrder(uid2, "AAPL", 100., 1)
    order3 = MarketOrder(uid1, "AAPL", 100., 1)
    @test order1 != order2
    @test order1 == order3
end
