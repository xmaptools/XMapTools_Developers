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
css = cumsum(y.^2);
tot  = cs(end);
tot2 = css(end);
totalRSS = tot2 - (tot.^2)/n;

bestRSS = Inf;
splitIdx = 1;
for i = 2:(n-2)
    s1  = cs(i);      s2  = tot - s1;
    ss1 = css(i);     ss2 = tot2 - ss1;
    rss = (ss1 - (s1.^2)/i) + (ss2 - (s2.^2)/(n - i));
    if rss < bestRSS
        bestRSS = rss;
        splitIdx = i;
    end
end

gain = totalRSS - bestRSS;
end