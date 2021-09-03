function peaks_merg = Peaksmerge( peaks, d )
% Peaksmerge : Merge peaks according the distance d, following 'Peakhunting'.
%   Detailed explanation goes here
%   Input
%    peaks   :   found peak list by Peakhunting, n*2 matrix
%    d       :   distance for those peaks smaller than d, they wiil be
%                condersed the same peak. and position will be calculated as averages.
%   Output
%    peaks_merg : merged peaks list.
%   Syntax: e.g. peaks_merg = Peaksmerge( peaks, 13 )


if size(peaks,1) <= 1
    peaks_merg = [];
    return
end

peaks_rest = peaks;
peaks_merg = [];
while size(peaks_rest, 1) >= 1
    peaks_same_id = find(sqrt( (peaks_rest(:,1)-peaks_rest(1,1)).^2 + (peaks_rest(:,2)-peaks_rest(1,2)).^2) <= d);
    peaks_merg = [peaks_merg; floor(mean(peaks_rest(peaks_same_id,:),1))];
    peaks_nosame_id = find(sqrt( (peaks_rest(:,1)-peaks_rest(1,1)).^2 + (peaks_rest(:,2)-peaks_rest(1,2)).^2) > d);
    peaks_rest = peaks_rest(peaks_nosame_id,:);
end

end

