function fea_lpn(cnt,mrk)

a=NaN;b=NaN;
for i=1:length(mrk.y)
    if(i~=1)
        lb=mrk.pos(i-1);
        ub=mrk.pos(i);
    else
        lb=0;
        ub=mrk.pos(i);
    end
    if(mrk.y(i)==1)
        if(isnan(a))
            a=cnt(lb+1:ub,:);
        else
            a=[a ; cnt(lb+1:ub,:)];
        end
        %count1=count1+ub-lb;
    end
    
    if(mrk.y(i)==2)
        if(isnan(b))
            b=cnt(lb+1:ub,:);
        else
            b=[b ; cnt(lb+1:ub,:)];
            %count2=count2+ub-lb;
        end
    end
end
a=double(a); b=double(b);
a1=a(1:1810,:); a2=a(1811:3620,:);a3=a(3621:5430,:); a4=a(5431:7240,:);a5=a(7241:9050,:);a6=a(9051:10860,:);a7=a(10861:12670,:);a8=a(12671:14474,:);
b1=b(1:1873,:); b2=b(1873+1:1873*2,:);b3=b(1873*2+1:1873*3,:); b4=b(1873*3+1:1873*4,:);b5=b(1873*4+1:1873*5,:);b6=b(1873*5+1:1873*6,:);b7=b(1873*6+1:1873*7,:);b8=b(1873*7+1:1873*8,:);
X=zeros(118*16,9); Y=zeros(118*16,1);
for i=1:118*16
    
    if(i<=118) x=a1(:,i); elseif(i<=118*2) x=a2(:,i-118); elseif(i<=118*3) x=a3(:,i-118*2);elseif(i<=118*4) x=a4(:,i-118*3);elseif(i<=118*5) x=a5(:,i-118*4);elseif(i<=118*6) x=a6(:,i-118*5);elseif(i<=118*7) x=a7(:,i-118*6);elseif(i<=118*8) x=a8(:,i-118*7);
    elseif(i<=118*9) x=b1(:,i-118*8);elseif(i<=118*10) x=b2(:,i-118*9);elseif(i<=118*11) x=b3(:,i-118*10);elseif(i<=118*12) x=b4(:,i-118*11);elseif(i<=118*13) x=b5(:,i-118*12);elseif(i<=118*14) x=b6(:,i-118*13);elseif(i<=118*15) x=b7(:,i-118*14);elseif(i<=118*16) x=b8(:,i-118*15);
    end
%     [ndata nvars]=size(x);
%     
%     N2 = floor(ndata/2);
%     N4 = floor(ndata/4);
%     TOL = 1.0e-6;
%     
%     exponent = zeros(N4+1,1);
%     
%     for p=N4:N2  % second quartile of data should be sufficiently evolved
%         dist = norm(x(p+1,:)-x(p,:));
%         indx = p+1;
%         for j=1:ndata-5
%             if (p ~= j) && norm(x(p,:)-x(j,:))<dist
%                 dist = norm(x(p,:)-x(j,:));
%                 indx = j; % closest point!
%             end
%         end
%         expn = 0.0; % estimate local rate of expansion (i.e. largest eigenvalue)
%         for k=1:5
%             if norm(x(p+k,:)-x(indx+k,:))>TOL && norm(x(p,:)-x(indx,:))>TOL
%                 expn = expn + (log(norm(x(p+k,:)-x(indx+k,:)))-log(norm(x(p,:)-x(indx,:))))/k;
%             end
%         end
%         exponent(p-N4+1)=expn/5;
%     end
%     
%     %statistical feature extraction
%     X(i,1)=max(exponent);
%     X(i,2)=min(exponent);
%     X(i,3)=mean(exponent);
%     X(i,4)=std(exponent);

[C,L] = wavedec(x,6,'db4');          % All wavelet coefficients here and respe.length
    cA6 = appcoef(C,L,'db4',6);
    [cD1,cD2,cD3,cD4,cD5,cD6] = detcoef(C,L,[1,2,3,4,5,6]);
    
    % Autocorrelation(AC)
    [ACF4, Lags4] = autocorr(cD4, length(cD4)-1);
    [ACF5, Lags5] = autocorr(cD5, length(cD5)-1);
    [ACF6, Lags6] = autocorr(cD6, length(cD6)-1);
    
    var_AC4=sum((ACF4-mean(ACF4)).^2)/(length(ACF4)-1);
    var_AC5=sum((ACF5-mean(ACF5)).^2)/(length(ACF5)-1);
    var_AC6=sum((ACF6-mean(ACF6)).^2)/(length(ACF6)-1);
    
    % Moving Average Filter
    l1=length(cD1);
    l2=length(cD2);
    l3=length(cD3);
    m=5;                                    % 'm' must be odd for symmetrical arrangments
    sum1=0;
    
    % Moving average for cD1
    for k = 1:l1
        if k<=m || k>(l1-m)
            arr(k)=0;                    % leaving initial and last samples
        else
            sum1=0;
            for l=(k-m):(k+m-1)
                sum1=sum1+abs(cD1(l));
            end
            sum1=sum1/(2*m);
            S1(k-m)=sum1;
        end
    end
    clear arr l1 k sum1;
    
    % Moving average for cD2
    for k = 1:l2
        if k<=m || k>(l2-m)
            arr(k)=0;
        else
            sum1=0;
            for l = (k-m):(k+m-1)
                sum1=sum1+abs(cD2(l));
            end
            sum1=sum1/(2*m);
            S2(k)=sum1;
        end
    end
    
    clear arr l2 k sum1;
    sum1=0;
    
    % Moving average for cD3
    for k = 1:l3
        if k<=m || k>(l3-m)
            arr(k)=0;
        else
            for l=(k-m):(k+m-1)
                sum1=sum1+abs(cD3(l));
            end
            sum1=sum1/(2*m);
            S3(k-m)=sum1;
            sum1=0;
        end
    end
    clear k l3 arr sum1;
    
    % Following variance provide power of high-frequency vibrations
    
    var_1=sum((cD1-mean(cD1)).^2)/(length(cD1)-1);X(i,1)
    var_2=sum((cD2-mean(cD2)).^2)/(length(cD2)-1);X(i,2)
    var_3=sum((cD3-mean(cD3)).^2)/(length(cD3)-1);X(i,3)
    
    % Sample Mean & Quotient provides maximum local extent of high frequencyvibrations
    M_S1=mean(S1);
    M_S2=mean(S2);
    M_S3=mean(S3);
    X(i,1)=var_1;X(i,2)=var_2;X(i,3)=var_3;X(i,4)=var_AC4;X(i,5)=var_AC5;X(i,6)=var_AC6;X(i,7)=M_S1;X(i,8)=M_S2;X(i,9)=M_S3;
    
    clear cA6 cD1 cD2 cD3 cD4 cD5 cD6;
    clear ACF4 ACF5 ACF6 Lags4 Lags5 Lags6;
    clear var_1 var_2 var_3 var_AC4 var_AC5 var_AC6 M_S1 M_S2 M_S3;
    clear C L m S1 S2 S3;
    
    if(i<=118*8)
        Y(i,1)=0;
    else
        Y(i,1)=1;
    end
end

%feature scaling
for i=1:9
    z=X(:,i);
    xhat(:,i)=(z-mean(z))/std(z);
end
X=xhat;

%Z=[X,Y];
save('X');
save('Y');
%save('Z.txt','-ascii');
end