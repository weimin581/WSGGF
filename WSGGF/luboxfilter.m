function imDst = luboxfilter(imSrc, r)

%   BOXFILTER   O(1) time box filtering using cumulative sum
%
%   - Definition imDst(x, y)=sum(sum(imSrc(x-r:x+r,y-r:y+r)));
%   - Running time independent of r; 
%   - Equivalent to the function: colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);
%   - But much faster.
[hei, wid] = size(imSrc);
imSrc = [imSrc zeros(hei,r);zeros(r,wid + r)];
imDst = zeros(hei+r,wid+r);

%cumulative sum over Y axis
imCum = cumsum(imSrc, 1);
%difference over Y axis
imDst(1:r+1, :) = imCum(1:r+1, :);
imDst(r+2:hei+r, :) = imCum(r+2:hei+r, :) - imCum(1:hei-1, :);


%cumulative sum over X axis
imCum = cumsum(imDst, 2);
%difference over Y axis
imDst(:, 1:r+1) = imCum(:, 1:r+1);
imDst(:, r+2:wid+r) = imCum(:, r+2:wid+r) - imCum(:, 1:wid-1);
end