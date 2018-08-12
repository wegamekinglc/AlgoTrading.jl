mutable struct Balance
    cashes::Dict{String, Cash}
    function Balance(balance::Dict{String, Cash})
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

function update!(balance::Balance, cashes::Array{Cash, 1})
    for cash in cashes
        update!(balance, cash)
    end
end

function update(balance::Balance, cash::Cash)
    new_balance = deepcopy(balance)
    update!(new_balance, cash)
    new_balance
end

function update(balance::Balance, cashes::Array{Cash, 1})
    new_balance = deepcopy(balance)
    update!(new_balance, cashes)
    new_balance
end

getbalance(balance::Balance, symbol::AbstractString) = balance.cashes[symbol]
updateOneSymbol!(dict::Dict{String, Cash}, symbol::String, cash::Cash) =
    haskey(dict, symbol) ? dict[symbol] += cash : dict[symbol] = cash
