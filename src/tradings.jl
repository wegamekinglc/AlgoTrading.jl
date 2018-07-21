function trade(fxquote::FXQuote, amount::Float64, comm::T) where {T <: Commission}
    domesticcash::Cash = Cash(domestic(fxquote), -amount * fxquote.value)
    foreigncash::Cash = Cash(foreign(fxquote), amount)
    commissions::Cash = commission(fxquote, amount, comm)
    (foreigncash, domesticcash, commissions)
end

function tradeto(fxquote::FXQuote, amount::Float64, comm::T, balance::Balance) where {T <: Commission}
    forcurr::Currency = foreign(fxquote)
    forcash::Cash = getbalance(balance, symbol(forcurr))

    to_trade = Cash(forcurr, amount) - forcash
    trade(fxquote, to_trade.value, comm)
end
