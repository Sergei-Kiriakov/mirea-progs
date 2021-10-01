import HorizonSideRobots
using HorizonSideRobots
sides = [Nord, Ost, Sud, West]
nx = [0, 1, 0, -1]
ny = [1, 0, -1, 0]
x = 25
y = 25
spawn = 25
used = [Int[0 for i in 1:50] for i in 1:50]
max_x = 25
min_x = 25
max_y = 25
min_y = 25

function clear()
    for i in 1:50
        for j in 1:50
            used[i][j] = 0
        end
    end
end

"""
    function inverse(side::HorizonSide)

    -- Возвращает противоположную сторону
"""
function inverse(side::HorizonSide)
    return HorizonSide((Int(side) + 2) % 4)
end

function mark(r)
    global x, y, spawn, min_x, max_x, min_y, max_y
    if (x == min_x || x == max_x || y == min_y || y == max_y)
        putmarker!(r)
    end
end

function up_coord(indd)
    global x, y
    if (indd == 1)
        y += 1
    elseif (indd == 2)
        x += 1
    elseif (indd == 3)
        y -= 1
    else
        x -= 1
    end
end

function run(r, indd)
    while (!isborder(r, sides[indd]))
        move!(r, sides[indd])
        up_coord(indd)
    end
end

function run_and_mark(r, indd)
    while (!isborder(r, sides[indd]))
        move!(r, sides[indd])
        putmarker!(r)
        up_coord(indd)
    end
end

function go_spawn(r)
    global x, y, spawn
    if (x < spawn)
        while (x != spawn)
            x += 1
            move!(r, Ost)
        end
    else
        while (x != spawn)
            x -= 1
            move!(r, West)
        end
    end
    if (y < spawn)
        while (y != spawn)
            y += 1
            move!(r, Nord)
        end
    else
        while (y != spawn)
            y -= 1
            move!(r, Sud)
        end
    end
end

function dfs_find_bord(r)
    global x, y, min_x, max_x, min_y, max_y
    for indd in 1:4
        x1 = x + nx[indd]
        y1 = y + ny[indd]
        if (used[x1][y1] == 0 && !isborder(r, sides[indd]))
            used[x1][y1] = 1
            move!(r, a[indd])
            up_coord(indd)
            min_x = min(x, min_x)
            min_y = min(y, min_y)
            max_x = max(x, max_x)
            max_y = max(y, max_y)
            dfs_find_bord(r)
            indd1 = (indd + 1) % 4 + 1
            move!(r, sides[indd1])
            up_coord(indd1)
        end
    end
end

function dfs(r)
    global x, y
    mark(r)
    for indd in 1:4
        x1 = x + nx[indd]
        y1 = y + ny[indd]
        if (used[x1][y1] == 0 && !isborder(r, sides[indd]))
            used[x1][y1] = 1
            move!(r, sides[indd])
            up_coord(indd)
            dfs(r)
            indd1 = (indd + 1) % 4 + 1
            move!(r, sides[indd1])
            up_coord(indd1)
        end
    end
end

function try_move(r, side)
    if (!isborder(r, side))
        move!(r, side)
    end
end


function moves(side, cnt)
    for i in 1:cnt
        try_move(r, side)
        if (!isborder(r, Sud))
            return false
        end
    end
    return true
end

function find_marker(r)
    cnt = 3
    while (!ismarker(r))
        move!(r, West)
        move!(r, Nord)
        indd = 1
        i = 0
        flag = true
        while (i < 4 && flag)
            flag = moves(sides[indd], cnt - 1)
            indd = indd % 4 + 1
            i += 1
        end
        cnt += 2
    end
end

function main(r)
    clear()
    dfs_find_bord(r)
    clear()
    dfs(r)
end

#=
Для решения задачи запускать функцию main()
=#
