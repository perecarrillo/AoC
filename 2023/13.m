fid = fopen("13.in");

line = fgetl(fid);

totalSum = 0;

while ischar(line)
    map = [];
    while ischar(line) && ~isempty(line)
        map = [map; line];
        line = fgetl(fid);
    end
    %disp(map);
    %disp("------------------");
    
    sum = findMirror(map, 0);
    
    exit = false;
    for j=1:size(map, 1)
        if exit
            break
        end
        for k=1:size(map, 2)
            prev = map(j, k);
            if map(j, k) == '.'
                map(j, k) = '#';
            else
                map(j, k) = '.';
            end            
            localSum = findMirror(map, sum);

            map(j, k) = prev;

            if localSum ~= 0 && localSum ~= sum
                sum = localSum;
                exit = true;
                break
            end
            
        end
    end

    totalSum = totalSum + sum;
    line = fgetl(fid);
end
int32(totalSum)
fclose(fid);

function sum = findMirror(map, different)
    sum = 0;
    for i = 2:size(map, 2) - 1
        %disp(map(:, i:end))
        %disp("////////////////////")
        if fliplr(map(:, 1:i)) == map(:, 1:i)
            %sum = sum + i/2;
            if mod(i, 2) == 0 && i/2 ~= different
                sum = i/2;
                break
            end
        end
        if fliplr(map(:, i:end)) == map(:, i:end)
            %sum = sum + (size(map, 2) - i + 1)/2;
            if mod(size(map, 2)-i+1, 2) == 0 && i + (size(map, 2) - i + 1)/2 - 1 ~= different
                sum = i + (size(map, 2) - i + 1)/2 - 1;
                break
            end
        end
    end
    
    for i = 2:size(map, 1) - 1
        %disp(map(1:i, :))
        %disp("////////////////////")
        if flipud(map(1:i, :)) == map(1:i, :)
            %sum = sum + i/2;
            if mod(i, 2) == 0 && 100 * (i/2) ~= different
                sum = 100 * (i/2);
                break
            end
        end
        if flipud(map(i:end, :)) == map(i:end, :)
            %sum = sum + (size(map, 1) - i + 1)/2;
            if mod(size(map, 1)-i+1, 2) == 0 && 100 * (i + (size(map, 1) - i + 1)/2 - 1) ~= different
                sum = 100 * (i + (size(map, 1) - i + 1)/2 - 1);
                break
            end
        end
    end
    return
end