
function main()

    input = map(collect, readlines("4/input.in", keep=false))

    counter = 0

    for i in 1:length(input)
        for j in 1:length(input[i])-3
            if input[i][j:j+3] == ['X', 'M', 'A', 'S'] || input[i][j:j+3] == ['S', 'A', 'M', 'X']
                counter += 1
            end
        end
    end

    for i in 1:length(input)-3
        for j in 1:length(input[i])
            if [input[i][j], input[i+1][j], input[i+2][j], input[i+3][j]] == ['X', 'M', 'A', 'S'] || [input[i][j], input[i+1][j], input[i+2][j], input[i+3][j]] == ['S', 'A', 'M', 'X']
                counter += 1
            end
        end
    end

    for i in 1+3:length(input)
        for j in 1:length(input[i])-3
            if [input[i][j], input[i-1][j+1], input[i-2][j+2], input[i-3][j+3]] == ['X', 'M', 'A', 'S'] || [input[i][j], input[i-1][j+1], input[i-2][j+2], input[i-3][j+3]] == ['S', 'A', 'M', 'X']
                counter += 1
            end
        end
    end

    for i in 1+3:length(input)
        for j in 1:length(input[i])-3
            if [input[i][j+3], input[i-1][j+2], input[i-2][j+1], input[i-3][j]] == ['X', 'M', 'A', 'S'] || [input[i][j+3], input[i-1][j+2], input[i-2][j+1], input[i-3][j]] == ['S', 'A', 'M', 'X']
                counter += 1
            end
        end
    end


    println("Part 1: $counter")


    counter = 0

    for i in 1:length(input)-2
        for j in 1:length(input[i])-2
            if ([input[i][j], input[i+1][j+1], input[i+2][j+2]] == ['M', 'A', 'S'] || [input[i][j], input[i+1][j+1], input[i+2][j+2]] == ['S', 'A', 'M']) &&
               ([input[i+2][j], input[i+1][j+1], input[i][j+2]] == ['M', 'A', 'S'] || [input[i+2][j], input[i+1][j+1], input[i][j+2]] == ['S', 'A', 'M'])
                counter += 1
            end
        end
    end

    println("Part 2: $counter")
end

main()

