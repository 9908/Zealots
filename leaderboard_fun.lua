local savename = "/leaderboard_save.lua"

function saveLeaderboard()
    love.filesystem.write( savename, table.show(leaderboard, "leaderboard"))
end

function loadLeaderboard()

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

function saveScore()
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
    local a = {}
    if not(leaderboard == {}) then
        for i, v in ipairs(leaderboard) do
            table.insert(a, v.score)
        end
        table.sort(a)
        return a[#a]
    else
        return 0
    end
end

function sortLeaderboard()
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
