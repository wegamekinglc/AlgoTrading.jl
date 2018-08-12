module Okex

using HTTP
using MD5
using DataFrames
using Dates

export getspotbar, getfuturebar


function getmaturity(contract)
    current = now()
    if contract == "this_week"
        ret = thisweekcontract(current)
    elseif contract == "next_week"
        ret = nextweekcontract(current)
    elseif contract == "quarter"
        ret = thisquartercontract(current)
    end
    ret
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


function thisweekcontract(current::DateTime)
    if Dates.isfriday(current)
        ret = DateTime(Date(current)) + Dates.Hour(16)
    else
        ret = DateTime(Date(current)) + Dates.Hour(16)
        ret = Dates.tonext(ret, Dates.Friday)
    end
    ret
end


function nextweekcontract(current::DateTime)
    thisweek = thisweekcontract(current)
    ret = Dates.tonext(thisweek, Dates.Friday)
    ret
end


function lastfridayofquater(current::DateTime)
    lastday = Dates.lastdayofquarter(current)
    if Dates.isfriday(lastday)
        lastfriday = lastday
    else
        lastfriday = toprev(lastday, Dates.Friday)
    end
    lastfriday + Dates.Hour(16)
end


function thisquartercontract(current::DateTime)
    lastfriday = lastfridayofquater(current)
    if current > lastfriday
        ret = lastfridayofquater(Dates.tonext(lastfriday, Dates.Friday))
    else
        ret = lastfriday
    end
    ret
end


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
    df[:maturity] = getmaturity(contract)
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


function getaccount(api_key::AbstractString, secret_key::AbstractString)
    query_sign = bytes2hex(md5("$api_key&secret_key=$secret_key"))
    query = "https://www.okex.com/api/v1/userinfo.do?sign=$query_sign"
    resp = HTTP.post(query)
    res = String(resp.body)
    if length(res) == 0
        Dict{String, Any}()
    else
        JSON.parse(res)
    end
end


function getorderinfo(api_key::AbstractString, secret_key::AbstractString, pair::AbstractString; order_id::Int64=-1)
    pair_formated = lowercase(replace(pair, "|", "_"))
    query_sign = bytes2hex(md5("$api_key&symbol=$pair_formated&order_id=$order_id&secret_key=$secret_key"))
    query = "https://www.okex.com/api/v1/order_info.do?sign=$query_sign"
    resp = HTTP.post(query)
    res = String(resp.body)
    if length(res) == 0
        Dict{String, Any}()
    else
        JSON.parse(res)
    end
end

end
