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

function mark(R, n)
    if ((abs(R.min_y - R.y) % (2 * n) < n && abs(R.min_x - R.x) % (2 * n) < n) || (abs(R.min_y - R.y) % (2 * n) >= n && abs(R.min_x - R.x) % (2 * n) >= n)) 
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

function dfs(R, n)
    mark(R, n)
    for i in 1:4
        x1 = R.x + nx[i]
        y1 = R.y + ny[i]
        if (used[x1][y1] == 0 && !isborder(r, sides[i]))
            used[x1][y1] = 1
            move!(r, sides[i])
            R.x += nx[i]
            R.y += ny[i] 
            dfs(R, n)
            move!(r, inverse(sides[i]))
            R.x -= nx[i]
            R.y -= ny[i]
        end
    end
end

function main(r, n)
    R = MyRobot()
    clear()
    dfs_find_bord(R)
    clear()
    dfs(R, n)
end

r = Robot(animate = false, "mirea-progs/Task12/temp.sit")
n = 3
main(r, n)
show(r)


#=
На прямоугольном поле произвольных размеров расставить маркеры в виде "шахматных" клеток, начиная с юго-западного угла поля,
когда каждая отдельная "шахматная" клетка имеет размер n x n клеток поля (n - это параметр функции).
Начальное положение Робота - произвольное, конечное - совпадает с начальным.
Клетки на севере и востоке могут получаться "обрезанными" - зависит от соотношения размеров поля и "шахматных" клеток.
(Подсказка: здесь могут быть полезными две глобальных переменных,
в которых будут содержаться текущие декартовы координаты Робота относительно начала координат в левом нижнем углу поля, например)
=#
