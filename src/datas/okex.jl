using HTTP
using DataFrames
using Base.Dates


function getfuturebar(pair, contract, since; mintype="1min")
    pair_formated = lowercase(replace(pair, "|", "_"))
    since_time::Int64 = 0
    if isa(since, DateTime)
        since_time = (datetime2unix(since) - 8 * 3600) * 1000
    else
        since_time = (datetime2unix(DateTime(since)) - 8 * 3600) * 1000
    end
    resp = HTTP.get("https://www.okex.com/api/v1/future_kline.do?symbol=$pair_formated&contract_type=$contract&type=$mintype&since=$since_time");
    text = String(resp.body)

    mat = maketable(text, 6)
    df = todf(mat)
    df[:pair] = uppercase(pair)
    df
end

function getspotbar(pair, since; mintype="1min")
    pair_formated = lowercase(replace(pair, "|", "_"))
    since_time::Int64 = 0
    if isa(since, DateTime)
        since_time = (datetime2unix(since) - 8 * 3600) * 1000
    else
        since_time = (datetime2unix(DateTime(since)) - 8 * 3600) * 1000
    end
    resp = HTTP.get("https://www.okex.com/api/v1/kline.do?symbol=$pair_formated&type=$mintype&since=$since_time");
    text = String(resp.body)
    mat = maketable(text, 6)
    df = todf(mat)
    df[:pair] = uppercase(pair)
    df
end


function todf(mat::Array{Float64, 2})
    df = DataFrame(mat, [:trade_time, :open, :high, :low, :close, :volume])
    df[:trade_time] =
        map((x) -> unix2datetime(x / 1000. + 8 * 3600.), df[:trade_time])
    df
end


function parserow!(i::Int, s::AbstractString, mat::Array{Float64, 2})
    items = split(strip(s, ['[', ']']), ",")
    n = size(mat, 2)
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

