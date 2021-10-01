import HorizonSideRobots
using HorizonSideRobots
a = [Nord, Ost, Sud, West]
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

function mark(r)
    global x, y, spawn, min_x, max_x, min_y, max_y
    if (x <= max_x - abs(y - min_y))
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
    while (!isborder(r, a[indd]))
        move!(r, a[indd])
        up_coord(indd)
    end
end

function run_and_mark(r, indd)
    while (!isborder(r, a[indd]))
        move!(r, a[indd])
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
        if (used[x1][y1] == 0 && !isborder(r, a[indd]))
            used[x1][y1] = 1
            move!(r, a[indd])
            up_coord(indd)
            min_x = min(x, min_x)
            min_y = min(y, min_y)
            max_x = max(x, max_x)
            max_y = max(y, max_y)
            dfs_find_bord(r)
            indd1 = (indd + 1) % 4 + 1
            move!(r, a[indd1])
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
        if (used[x1][y1] == 0 && !isborder(r, a[indd]))
            used[x1][y1] = 1
            move!(r, a[indd])
            up_coord(indd)
            dfs(r)
            indd1 = (indd + 1) % 4 + 1
            move!(r, a[indd1])
            up_coord(indd1)
        end
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
