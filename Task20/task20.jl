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
    if (abs(R.x + R.y - R.spawn - R.spawn) % 2 == 0)
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

function dfs_move_to(R, x, y)
    for i in 1:4
        x1 = R.x + nx[i]
        y1 = R.y + ny[i]
        if (used[x1][y1] == 0 && !isborder(r, sides[i]))
            used[x1][y1] = 1
            move!(r, sides[i])
            R.x += nx[i]
            R.y += ny[i] 
            dfs_move_to(R, x, y)
            if (R.x == x && R.y == y)
                return 
            end
            move!(r, inverse(sides[i]))
            R.x -= nx[i]
            R.y -= ny[i]
        end
    end
end

function try_move(R, side)
    if (!isborder(R.r, side))
        move!(R.r, side)
    end
end

function cnt_horizontal(R)
    x = R.min_x
    y = R.min_y
    ans = 0
    while (y != R.max_y)
        flag = false
        x = R.min_x
        clear()
        dfs_move_to(R, x, y)
        while (x != R.max_x)
            if (isborder(R.r, Nord))
                if (!flag)
                    flag = true
                    ans += 1
                end
            else
                flag = false
            end
            clear()
            dfs_move_to(R, x + 1, y)
            x += 1
        end
        y += 1    
    end
    return ans
end

function main(r)
    R = MyRobot()
    clear()
    dfs_find_bord(R)    
    println(cnt_horizontal(R))
end

r = Robot(animate = false, "mirea-progs/Task20/temp.sit")
main(r)
show(r)


#=
Посчитать число всех горизонтальных прямолинейных перегородок (вертикальных - нет)
=#
