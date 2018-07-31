using HTTP
using DataFrames
using Base.Dates


function getspotbar(pair, mintype="1min", barsize=10)
    pair_formated = lowercase(replace(pair, "|", "_"))
    resp = HTTP.get("https://www.okex.com/api/v1/kline.do?symbol=$pair_formated&type=$mintype&size=$barsize");
    text = String(resp.body)

    mat = maketable(text, 6)
    df = DataFrame(mat, [:trade_time, :open, :high, :low, :close, :volume])
    df[:trade_time] =
        map((x) -> unix2datetime(x / 1000.), df[:trade_time])
    df[:pair] = uppercase(pair)
    df
end


function parserow!(i::Int, s::AbstractString, mat::Array{Float64, 2})
    items = split(strip(s, ['[', ']']), ",")
    n = length(items)
    for j in 1:n
        mat[i, j] = float(strip(items[j], '\"'))
    end
    nothing
end

function maketable(text::String, fields::Int)
    matches = matchall(r"\[[0-9,.\"\ ]+\]", text)
    n = length(matches)
    mat = Array{Float64, 2}(n, fields)
    for i in 1:n
        parserow!(i, matches[i], mat)
    end
    mat
end
