type Balance
    cashes::Dict{String, Cash}
    function Balance(balance::Dict{String, Cash}=nothing)
        if balance == nothing
            new(Dict{String, Cash}())
        else
            new(balance)
        end
    end
    function Balance(assets::Array{Currency, 1})
        new(Dict(c.symbol => Cash(c, 0.) for c in assets))
    end
end

function update!(balance::Balance, cash::Cash)
    symbol = cash.currency.symbol
    dict::Dict{String, Cash} = balance.cashes
    updateOneSymbol!(dict, symbol, cash)
end

getbalance(balance::Balance, symbol::AbstractString) = balance.cashes[symbol]
updateOneSymbol!(dict::Dict{String, Cash}, symbol::String, cash::Cash) =
    haskey(dict, symbol) ? dict[symbol] += cash : dict[symbol] = cash
