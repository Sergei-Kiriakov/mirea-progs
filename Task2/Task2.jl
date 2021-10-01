function run(r, indd)
    cnt = 0
    a = [Nord, Ost, Sud, West]
    while (!isborder(r, a[indd]))
        move!(r, a[indd])
        putmarker!(r)
        cnt += 1
    end
end

function go(x, y)
    a = [Nord, Ost, Sud, West]
    if (x > 0)
        
    end

function f(r)
    run(r, 1)
    run(r, 4)
    run(r, 3)
    run(r, 2)
    run(r, 1)
    run(r, 4)
end

#using HorizonSideRobots
#r = Robot()
#show!(r)