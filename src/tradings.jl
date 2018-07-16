function buy(fxquote::FXQuote, amount::Float64, comm::T) where {T <: Commission}
    incash::Cash = Cash(foreign(fxquote), amount)
    outcash::Cash = fxquote * amount
    comm = commission(fxquote, amount, comm)
    (incash, outcash, comm)
end

function sell(fxquote::FXQuote, amount::Float64, comm::T) where {T <: Commission}
    incash::Cash = fxquote * amount
    outcash::Cash = Cash(foreign(fxquote), -amount)
    comm = commission(fxquote, amount, comm)
    (incash, outcash, comm)
end
