function [u] = mesolver(g,u0,f,m,nei,lambda,sigma_g,sigma_u,itr)

[~, ~, Zg]=size(g);          
[X, Y, Zu]=size(u0); N = X*Y; 
[~, edges] = lattice(X,Y,nei);

fVals = reshape(f,N,Zu);
F = double(fVals);
C = sparse(1:N,1:N,m(:));

if Zg > 1, g = colorspace('YUV<-', g);end;
gVals = reshape(g,N,Zg);
weights_g = makeweightsG(edges,gVals,sigma_g);
gW = adjacency(edges,weights_g,N);

%fprintf(1,'lambda: %d, step:     ',lambda);
for i=1:itr
    %if Zu > 1,u0 = colorspace('Lab<-', u0);end;
    uVals = reshape(u0,N,Zu);
    weights_u = makeweightsCPL2(edges,gVals,uVals,sigma_g,sigma_u); 
    uW = adjacency(edges,weights_u,N);
    W=gW.*uW;
    D  = sparse(1:N,1:N,sum(W));
    L = D-W;
    
    R = (C+lambda*L);
    U = (R \ F);
    %sigma_u = min(sigma_u,1/var(U(:)));
    u = reshape(U,X,Y,Zu);
    u0 = u;
    fprintf('.');
end
fprintf('\n');
