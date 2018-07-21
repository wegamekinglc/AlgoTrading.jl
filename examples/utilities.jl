function updatebalance!(balance::Balance, incashes, outcashes, comms)
    for cash in incashes
        update!(balance, cash)
    end

    for cash in outcashes
        update!(balance, cash)
    end

    for cash in comms
        update!(balance, -cash)
    end
end
