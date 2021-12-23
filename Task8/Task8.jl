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

function inverse(side)
    return HorizonSide((Int(side) + 2) % 4)
end

function try_move(r, side)
    if (!isborder(r, side))
        move!(r, side)
    end
end

function moves(side, cnt)
    for i in 1:cnt
        try_move(r, side)
        if (!isborder(r, Nord))
            return false
        end
    end
    return true
end

function main(r)
    cnt = 1
    flag = true
    side = West
    while (flag)
        print(1)
        flag = moves(side, cnt)
        side = inverse(side)
        cnt *= 2
    end
end

r = Robot(animate = false, "mirea-progs/Task8/temp.sit")
main(r)
show(r)

#=
ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля (без внутренних перегородок)
РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом стоит маркер, и все остальные клетки поля промаркированы в шахматном порядке
=#
