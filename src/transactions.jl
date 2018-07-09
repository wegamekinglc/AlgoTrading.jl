export Transaction

include("orders.jl")

struct Transaction
    id::Int
    orderid::Int
    amount::Real
    fillprice::Real
end

mutable struct OrdersStatus
    orderid::Int
    fillamount::Real
    isfinished::Bool
    iscanceled::Bool
end

function ==(x::Transaction, y::Transaction)
    x.id == y.id
end

function ==(x::OrdersStatus, y::OrdersStatus)
    x.orderid == y.orderid
end
