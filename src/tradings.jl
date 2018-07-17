function buy(fxquote::FXQuote, amount::Float64, comm::T) where {T <: Commission}
    incash::Cash = Cash(foreign(fxquote), amount)
    outcash::Cash = -(fxquote * incash)
    comm = commission(fxquote, amount, comm)
    (incash, outcash, comm)
end

function sell(fxquote::FXQuote, amount::Float64, comm::T) where {T <: Commission}
    outcash::Cash = Cash(foreign(fxquote), -amount)
    incash::Cash = -(fxquote * outcash)
    comm = commission(fxquote, amount, comm)
    (incash, outcash, comm)
end
