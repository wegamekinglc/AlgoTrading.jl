import Base.+

struct Currency
    symbol::String
end

struct Cash
    curreny::Currency
    value::Real
end

struct FXPair
    """
    e.g. USD|JPY
    domestic: JPY
    foreign: USD
    """
    symbol::String
    foreign::Currency
    domestic::Currency
    FXPair(foreign::Currency, domestic::Currency) = new(foreign.symbol + "|" + domestic.symbol, foreign, domestic)
end

struct FXQuote
    pair::FXPair
    value::Real
end

function +(lhs::Cash, rhs::Cash)
    if lhs.curreny == rhs::currency
        Cash(lhs.currency, lhs.value + rhs.value)
    else
        error("Currency is not compatiable")
    end
end

function -(lhs::Cash, rhs::Cash)
    if lhs.curreny == rhs::currency
        Cash(lhs.currency, lhs.value + rhs.value)
    else
        error("Currency is not compatiable")
    end
end
