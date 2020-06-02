function [rt,mean_rt,std_rt]=rec_outlier_removal(rt,n_std)

mean_rt=nanmean(rt);
std_rt=nanstd(rt);
n_points_bef=0;
n_points_aft=-1;

while n_points_bef~=n_points_aft
    n_points_bef=nnz(~isnan(rt));
    for i=1:size(rt,1)
        if rt(i)>=(mean_rt+n_std*std_rt) || rt(i)<=(mean_rt-n_std*std_rt)
            rt(i,1)=NaN;
        end
    end
    n_points_aft=nnz(~isnan(rt));
    mean_rt=nanmean(rt);
    std_rt=nanstd(rt);
end

end