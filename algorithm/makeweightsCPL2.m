function weights=makeweightsCPL2(edges,gvals,uvals,gvalScale,uvalScale,EPSILON)

%Constants
if nargin < 6
    EPSILON = 1e-5;
end

if gvalScale > 0
    gvalDistances=sum(abs(gvals(edges(:,1),:)- ...
        gvals(edges(:,2),:)),2);
    gvalDistances=normalize(gvalDistances); %Normalize to [0,1]
else
    gvalDistances=zeros(size(edges,1),1);
    gvalScale=0;
end
gweights=exp(-2.0*gvalScale*gvalDistances);

if uvalScale > 0
    uvalDistances=sum((uvals(edges(:,1),:)- ...
        uvals(edges(:,2),:)).^2,2);
    uvalDistances=normalize(uvalDistances); %Normalize to [0,1]
else
    uvalDistances=zeros(size(edges,1),1);
    uvalScale=0;
end

%Compute Gaussian weights
weights=exp(-uvalScale*uvalDistances.*gweights)+EPSILON;
