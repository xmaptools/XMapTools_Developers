function bp = findChangePointsMean(y, maxChanges)
% Free-MATLAB replacement for findchangepts(y,'MaxNumChanges',maxChanges,'Statistic','mean').
% Greedy binary segmentation: repeatedly splits the segment that gives the
% largest reduction in residual sum of squares (RSS) around the segment means,
% up to maxChanges splits. Returns changepoint indices (1-based, point AFTER
% which the segment changes), matching findchangepts' index convention.

y = y(:);
n = numel(y);
bp = [];
segments = {[1, n]};

for k = 1:maxChanges
    bestGain = 0;
    bestSeg  = -1;
    bestIdx  = -1;

    for s = 1:numel(segments)
        idx = segments{s};
        a = idx(1); b = idx(2);
        if (b - a) < 3
            continue; % too short to split meaningfully
        end
        [gain, splitLocal] = bestSplitRSS(y(a:b));
        if gain > bestGain
            bestGain = gain;
            bestSeg  = s;
            bestIdx  = a + splitLocal - 1; % global index of last point in first sub-segment
        end
    end

    if bestSeg == -1
        break; % no further split improves RSS
    end

    bp(end+1) = bestIdx; %#ok<AGROW>
    idx = segments{bestSeg};
    segments{bestSeg}   = [idx(1), bestIdx];
    segments{end+1}     = [bestIdx+1, idx(2)]; %#ok<AGROW>
end

bp = sort(bp(:));
end

function [gain, splitIdx] = bestSplitRSS(y)
% Finds the single split point (1-based, within y) minimizing the summed
% residual sum of squares of the two resulting constant-mean segments.
% gain = RSS(no split) - RSS(best split).

n = numel(y);
if n < 4
    gain = 0; splitIdx = 1;
    return;
end

cs  = cumsum(y);
tot = cs(end);
totalRSS = sum((y - mean(y)).^2);

bestRSS = Inf;
splitIdx = 1;
for i = 2:(n-2)
    m1 = cs(i) / i;
    m2 = (tot - cs(i)) / (n - i);
    rss = sum((y(1:i) - m1).^2) + sum((y(i+1:end) - m2).^2);
    if rss < bestRSS
        bestRSS = rss;
        splitIdx = i;
    end
end

gain = totalRSS - bestRSS;
end