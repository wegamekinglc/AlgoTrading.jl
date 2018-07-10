export MarketOrder, LimitOrder

import Base.==
import Base.Random.UUID

abstract type Order end

struct MarketOrder <: Order
    id::UUID
    symbol::String
    amount::Real
    direction::Int
end

struct LimitOrder <: Order
    id::UUID
    symbol::String
    amount::Real
    direction::Int
    limitprice::Real
end

function ==(x::MarketOrder, y::MarketOrder)
    x.id == y.id
end

function ==(x::LimitOrder, y::LimitOrder)
    x.id == y.id
end
