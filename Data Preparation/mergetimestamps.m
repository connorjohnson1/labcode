  %create first and second behavior matrices
                behav1 = timestamp1.behavecam;
                behav1(1,3) = 0;
                [m,n] = size(behav1);
                behav2 = timestamp2.behavecam;
                behav2(1,3) = 0;
                [m2,~] = size(behav2);
                
                %shift behav frame # and time down
                behav2(:,2) = behav2(:,2) + m;
                behav2(:,3) = behav2(:,3) + behav1(end,3);
                
                %create combined behavior time
                %should I change to behav3 to instead redefine variable
                %behavecam?
                behav3 = zeros(m+m2,n);
                behav3(1:m,:) = behav1;
                behav3(m+1:end,:) = behav2;
                
                %create first and second mscam matrices
                ms1 = timestamp1.mscam;
                ms1(1,3) = 0;
                [m,n] = size(ms1);
                ms2 = timestamp2.mscam;
                ms2(1,3) = 0;
                [m2,~] = size(ms2);
                
                %shift ms frame # and time down
                ms2(:,2) = ms2(:,2) + m;
                ms2(:,3) = ms2(:,3) + ms1(end,3);
                
                %create combined ms time
                ms3 = zeros(m+m2,n);
                ms3(1:m,:) = ms1;
                ms3(m+1:end,:) = ms2;
                
                %put new matrices in a struct and save it
                %edit: change timestamp3 to timestamp 
                timestamp = struct('behavecam',behav3,'mscam',ms3);