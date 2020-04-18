function dcor = distcorr_2(x,y)
% This function calculates the distance correlation between x and y.
% Reference: http://en.wikipedia.org/wiki/Distance_correlation 
% Date: 18 Jan, 2013
% Author: Shen Liu (shen.liu@hotmail.com.au)
% Check if the sizes of the inputs match
                if size(x,2) ~= size(y,2)
                    error('Inputs must have the same number of cols')
                end
%                 % Delete rows containing unobserved values
%                 N = any([isnan(x) isnan(y)],2);
%                 x(N,:) = [];
%                 y(N,:) = [];
                % Calculate doubly centered distance matrices for x and y
                x    = x';
                y    = y';
                a    = pdist2(x,x);
                mcol = mean(a);
                mrow = mean(a,2);
                
%                 ajbar = ones(size(mrow))*mcol;  %%%%%%
%                 akbar = mrow*ones(size(mcol));
%                 abar = mean(mean(a))*ones(size(a));
%                 A = a - ajbar - akbar + abar;
                
                A1   = bsxfun(@minus, a, mcol);
                A1   = bsxfun(@minus, A1, mrow);
                A1   = bsxfun(@plus, A1, mean(mcol));
                
                b    = pdist2(y,y);
                                
                mcol = mean(b);
                mrow = mean(b,2);
                
                
%                 bjbar = ones(size(mrow))*mcol;
%                 bkbar = mrow*ones(size(mcol));
%                 bbar = mean(mean(b))*ones(size(b));
%                 B = b - bjbar - bkbar + bbar;
                
                B1 = bsxfun(@minus, b, mcol);
                B1 = bsxfun(@minus, B1, mrow);
                B1 = bsxfun(@plus, B1, mean(mcol));
                                
                
%                 % Calculate squared sample distance covariance and variances
%                 dcov = sum(sum(A.*B))/(size(mrow,1)^2);
%                 dvarx = sum(sum(A.*A))/(size(mrow,1)^2);
%                 dvary = sum(sum(B.*B))/(size(mrow,1)^2);
%                 % Calculate the distance correlation
%                 dcor = sqrt(dcov/sqrt(dvarx*dvary));
                
                
                
                dcov1   = sum(sum(A1.*B1))/(size(mrow,1)^2);
                dvarx1  = sum(sum(A1.*A1))/(size(mrow,1)^2);
                dvary1  = sum(sum(B1.*B1))/(size(mrow,1)^2);
                % Calculate the distance correlation
                dcor    = sqrt(dcov1/sqrt(dvarx1*dvary1));
                
                
                
                
                
                
                 
                

end