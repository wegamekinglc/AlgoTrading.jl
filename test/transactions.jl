using Base.Test
using Base.Random.uuid1

include("../src/orders.jl")
include("../src/transactions.jl")

@testset "Transaction structure test" begin
    tid = uuid1()
    oid = uuid1()
    order = MarketOrder(oid, "AAPL", 100., 1)
    trans = Transaction(tid, oid, 50., 22.)

    @test trans.orderid == order.id
    @test trans.id == tid
    @test trans.amount == 50.
    @test trans.fillprice == 22.
end

@testset "Order status structure test" begin
    oid = uuid1()
    ostatus = OrdersStatus(oid, 50., false, false)

    @test ostatus.orderid == oid
    @test ostatus.fillamount == 50.
    @test ostatus.isfinished == false
    @test ostatus.iscanceled == false
end

@testset "Transaction equality test" begin
    tid1 = uuid1()
    tid2 = uuid1()
    oid = uuid1()

    order = MarketOrder(oid, "AAPL", 100., 1)
    trans1 = Transaction(tid1, oid, 50., 22.)
    trans2 = Transaction(tid2, oid, 50., 22.)
    trans3 = Transaction(tid1, oid, 50., 22.)
    @test trans1 != trans2
    @test trans1 == trans3
end

@testset "Order status equality test" begin
    oid1 = uuid1()
    oid2 = uuid1()
    ostatus1 = OrdersStatus(oid1, 50., false, false)
    ostatus2 = OrdersStatus(oid2, 50., false, false)
    ostatus3 = OrdersStatus(oid1, 50., false, false)
    @test ostatus1 != ostatus2
    @test ostatus1 == ostatus3
end
