local savename = "/leaderboard_save.lua"

function saveLeaderboard()
    -- write leaderboard to filesave
    love.filesystem.write( savename, table.show(leaderboard, "leaderboard"))
end

function loadLeaderboard()
    -- load leaderboard from filesave
    if love.filesystem.exists( savename ) then
        chunk = love.filesystem.load( savename )
        chunk() -- runs the code

        if debug then
            print("loading saved leaderboard")
            for i, v in ipairs(leaderboard) do
                print(v.date)
                print(v.score)
            end
            --print("Sorted:")
            --sortLeaderboard()
        end
    else
        leaderboard = {}
    end
end

function resetLeaderboard()
    -- clear the filesave of leaderboard
    leaderboard = {}
    saveLeaderboard()
end

function saveScore()
    -- save score in leaderboard
    max = maxLeaderboard()
    if score > max then
        score_info = {

            date = os.date("%d/%m/%Y %H:%M"),
            score = score

        }
        print(score_info.score)
        table.insert(leaderboard, score_info)
        print(leaderboard[#leaderboard].score)
        saveLeaderboard()
    end
end

function maxLeaderboard()
    -- return the max value inside leatherboard
    local a = {}
    if not(leaderboard == {}) then
        for i, v in ipairs(leaderboard) do
            table.insert(a, v.score)
        end
        table.sort(a)
        if #a == 0 then
            return 0
        else
            return a[#a]
        end
    else
        return 0
    end
end

function sortLeaderboard()
    -- not used
    local a = {}
    local aidx = {}
    for i, v in ipairs(leaderboard) do
        table.insert(a, v.score)
        table.insert(aidx, i)
    end
    not_sorted = a
    table.sort(a)
    for i,n in ipairs(a) do
        print(n,aidx[i])
    end
end
