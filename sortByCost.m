function [ sorted ] = sortByCost( unsorted )

% Predefine structure array
sorted(length(unsorted)) = unsorted(1);

for i = 1:length(sorted)
    min = 99999;
    minIdx = 0;
    for j = 1:length(unsorted)
        if unsorted(j).cost.total < min
            min = unsorted(j).cost.total;
            minIdx = j;
        end
    end
    sorted(i) = unsorted(minIdx);
    unsorted(minIdx) = [];
end


end