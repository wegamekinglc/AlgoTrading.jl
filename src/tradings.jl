function trade(fxquote::FXQuote, amount::Float64, comm::T) where {T <: Commission}
    domesticcash::Cash = Cash(domestic(fxquote), -amount * fxquote.value)
    foreigncash::Cash = Cash(foreign(fxquote), amount)
    commissions::Cash = commission(fxquote, amount, comm)
    (foreigncash, domesticcash, commissions)
end
