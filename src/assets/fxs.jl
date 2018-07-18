import Base.==

struct FXPair <: AbstractAsset
    """
    e.g. USD|JPY
    domestic: JPY
    foreign: USD
    """
    foreign::Currency
    domestic::Currency
    FXPair(foreign::Currency, domestic::Currency) = new(foreign, domestic)
    function FXPair(symbol::AbstractString)
        strarray = split(symbol, "|")
        foreign = Currency(strarray[1])
        domestic = Currency(strarray[2])
        new(foreign, domestic)
    end
end

==(lhs::FXPair, rhs::FXPair) = lhs.foreign == rhs.foreign && lhs.domestic == rhs.domestic

symbol(fxp::FXPair) = string(symbol(foreign), symbol(domestic))
domestic(fxp::FXPair) = fxp.domestic
foreign(fxp::FXPair) = fxp.foreign
valcurrency(fxp::FXPair) = fxp.domestic
invpair(fxp::FXPair) = FXPair(fxp.domestic, fxp.foreign)

struct FXForward <: AbstractAsset
    pair::FXPair
    maturity::Base.DateTime
end

symbol(fxf::FXForward) = symbol(fxf.pair)
invforward(fxf::FXForward) = FXForward(invpair(fxf.pair), fxf.maturity)
domestic(fxf::FXForward) = fxf.pair.domestic
foreign(fxf::FXForward) = fxf.pair.foreign
valcurrency(fxf::FXForward) = foreign(fxf)
maturity(fxf::FXForward) = fxf.maturity

const USDJPY = FXPair(USD, JPY)
const JPYUSD = FXPair(JPY, USD)
const USDCNY = FXPair(USD, CNY)
const CNYUSD = FXPair(CNY, USD)
const JPYCNY = FXPair(JPY, CNY)
const CNYJPY = FXPair(CNY, JPY)

const BTCUSD = FXPair(BTC, USD)
const ETHUSD = FXPair(ETH, USD)
const EOSUSD = FXPair(EOS, USD)
const BTCUSDT = FXPair(BTC, USDT)
const ETHUSDT = FXPair(ETH, USDT)
const EOSUSDT = FXPair(EOS, USDT)
const EOSBTC = FXPair(EOS, BTC)
const EOSETH = FXPair(EOS, ETH)
