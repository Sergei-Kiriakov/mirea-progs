import HorizonSideRobots
using HorizonSideRobots
sides = [Nord, Ost, Sud, West]
nx = [0, 1, 0, -1]
ny = [1, 0, -1, 0]
used = [Int[0 for i in 1:50] for i in 1:50]

mutable struct MyRobot
    r::Robot
    x::Int
    y::Int
    max_x::Int
    min_x::Int
    spawn::Int
    max_y::Int
    min_y::Int
    MyRobot() = new(r, 25, 25, 25, 25, 25, 25, 25)
end

function clear()
    for i in 1:50
        for j in 1:50
            used[i][j] = 0
        end
    end
end

function inverse(side)
    return HorizonSide((Int(side) + 2) % 4)
end

function mark(R)
    if (R.x == R.max_x || R.x == R.min_x || R.y == R.min_y || R.y == R.max_y)
        putmarker!(R.r)
    end
end

function up(R)
    R.min_x = min(R.x, R.min_x)
    R.min_y = min(R.y, R.min_y)
    R.max_x = max(R.x, R.max_x)
    R.max_y = max(R.y, R.max_y)
end

function dfs_find_bord(R)
    for i in 1:4
        x1 = R.x + nx[i]
        y1 = R.y + ny[i]
        if (used[x1][y1] == 0 && !isborder(R.r, sides[i]))
            used[x1][y1] = 1
            move!(R.r, sides[i])
            R.x += nx[i]
            R.y += ny[i] 
            up(R)
            dfs_find_bord(R)
            R.x -= nx[i]
            R.y -= ny[i] 
            move!(r, inverse(sides[i]))
        end
    end
end

function dfs(R)
    mark(R)
    for i in 1:4
        x1 = R.x + nx[i]
        y1 = R.y + ny[i]
        if (used[x1][y1] == 0 && !isborder(r, sides[i]))
            used[x1][y1] = 1
            move!(r, sides[i])
            R.x += nx[i]
            R.y += ny[i] 
            dfs(R)
            move!(r, inverse(sides[i]))
            R.x -= nx[i]
            R.y -= ny[i]
        end
    end
end

function main(r)
    R = MyRobot()
    clear()
    dfs_find_bord(R)
    clear()
    dfs(R)
end

#=
Для решения задачи запускать функцию main()
=#

