export Transaction

import Base.Random.UUID

include("orders.jl")

struct Transaction
    id::UUID
    orderid::UUID
    amount::Real
    fillprice::Real
end

mutable struct OrdersStatus
    orderid::UUID
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
