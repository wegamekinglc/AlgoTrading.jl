export MarketOrder, LimitOrder

import Base.==

abstract type Order end


struct MarketOrder <: Order
    id::Int
    amount::Real
    direction::Int
end


struct LimitOrder <: Order
    id::Int
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
