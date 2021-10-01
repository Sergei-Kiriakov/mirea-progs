function run(r, indd)
    a = [Nord, Ost, Sud, West]
    cnt = 0
    while (!isborder(r, a[indd]))
        move!(r, a[indd])
        putmarker!(r)
        cnt += 1
    end
    indd = (indd - 1 + 2) % 4 + 1
    while (cnt != 0)
        move!(r, a[indd])
        cnt -= 1
    end
end

function main(r)
    run(r, 1)
    run(r, 2)
    run(r, 3)
    run(r, 4)
end

#=
Для решения задачи запускать функцию main()
=#