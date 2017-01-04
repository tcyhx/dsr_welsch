function weights=makeweightsG(edges,vals,valScale,EPSILON)

%Constants
if nargin < 4
    EPSILON = 1e-5;
end

%Compute intensity differences
if valScale > 0
    valDistances=sum(abs(vals(edges(:,1),:)- ...
        vals(edges(:,2),:)),2);
    valDistances=normalize(valDistances); %Normalize to [0,1]
else
    valDistances=zeros(size(edges,1),1);
    valScale=0;
end

%Compute Gaussian weights
weights=exp(-2.0*valScale*valDistances)+EPSILON;
