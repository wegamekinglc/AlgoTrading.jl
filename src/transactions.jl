export Transaction

include("orders.jl")

struct Transaction
    orderid::Int
    amount::Real
    fillprice::Real
end


type 
