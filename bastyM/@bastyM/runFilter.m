function dfPose = runFilter(obj,hampelWindow,rloessWindow)

dfPose = obj.OrientedData;

if nargin < 3
        hampelWindow = obj.hampelWindow;
        rloessWindow = obj.rloessWindow;
else
    obj.hampelWindow = hampelWindow;
    obj.rloessWindow = rloessWindow;
end

hdfPose = varfun(@(x) hampel(x,hampelWindow),dfPose);
dfPose  = varfun(@(x) smoothdata(x,'rloess',rloessWindow),hdfPose);
end
