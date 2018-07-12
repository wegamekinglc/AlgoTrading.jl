import Base.==

@enum AssetType Stock=1 Future=2 FX=3 Option=4

struct AssetProfile
    assettype::AssetType
    exchange::String
    commission::Real
end

function ==(x::AssetProfile, y::AssetProfile)
    x.assettype == y.assettype && x.exchange == y.exchange
end

struct Asset
    symbol::String
    profile:: AssetProfile
    slippage::Real
end

function ==(x::Asset, y::Asset)
    x.symbol == y.symbol
end
