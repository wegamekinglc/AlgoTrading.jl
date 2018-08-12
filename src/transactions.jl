import UUIDs: UUID

struct Transaction
    id::UUID
    orderid::UUID
    amount::Float64
    fillprice::Float64
end

mutable struct OrdersStatus
    orderid::UUID
    fillamount::Float64
    isfinished::Bool
    iscanceled::Bool
end

function ==(x::Transaction, y::Transaction)
    x.id == y.id
end

function ==(x::OrdersStatus, y::OrdersStatus)
    x.orderid == y.orderid
end
