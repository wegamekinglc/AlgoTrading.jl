import Base.==
import UUIDs: UUID

abstract type Order end

struct MarketOrder <: Order
    id::UUID
    symbol::String
    amount::Float64
    direction::Int
end

struct LimitOrder <: Order
    id::UUID
    symbol::String
    amount::Float64
    direction::Int
    limitprice::Float64
end

function ==(x::MarketOrder, y::MarketOrder)
    x.id == y.id
end

function ==(x::LimitOrder, y::LimitOrder)
    x.id == y.id
end
