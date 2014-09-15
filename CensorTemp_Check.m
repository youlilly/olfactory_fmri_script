%% STEP 4: Censor List
% Run a loop to calculate every volume motion; cutoff 2mm
% This finds points where the motion from one image to another is large
% enough that it can potentially create artifact.  A list is made of images
% where this applies.  This precrocessing scrpit ensures that all relevant
% images are put in the censor list, including images surronding the
% aberrant volumes.

% for i = 1:length(subs)
%     subfol = strcat('sub',num2str(subs(i)));
%     fullfol = strcat(mainpath,subfol);
% for run = 1:2
%     % Import the mation parameters from the text file output by SPM after
%     % realignment.
%     if run == 1
%         rpfile = strcat(fullfol,'\',epi1name,'\rp_asRMRRFSWT001-0004-00001-000336-01');
%     else
%         rpfile = strcat(fullfol,'\',epi2name,'\rp_asRMRRFSWT001-0008-00001-000336-01');
%     end
% rps = importdata(rpfile);
sub = [2 3 5:18];
mainpath = '/study/sweat/mri/preprocess/Prep';
cd(mainpath);

for i = 1:length(sub)
    subfol = strcat('sub',num2str(sub(i)));
    fullfol = strcat(mainpath,'/',subfol);
    
    for run = 1:2
        if run == 1
            impdir = strcat(fullfol,'/EPI1'); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        else
            impdir = strcat(fullfol,'/EPI2'); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        end
        cd(impdir);
        Filter = 'rp_asRMR';
        rpfile = spm_select('FPList',impdir,Filter);
        rps = importdata(rpfile);
        eval(['save ARF_sub' num2str(sub(i)) '_b' num2str(run) '_rp.txt -ascii rps']);
        
        diffs = [];
        mocalc = [];
        clist = [];
        clist1=[];
        clist2=[];
        clistn = [];
        
        % Calculate the motion across images.  This finds the difference in the
        % realignment parameters between each pair of images, corresponding to the
        % amount of motion from one image to the next.  These values are placed
        % into their own array.  The square root of the sum of squares is also
        % caluclated and put into a separate array.  These two arrays are saved
        % with the rps for the purpose of validation.
        for ir = 1:length(rps)-1
            sing_dev=rps(ir+1,:) - rps(ir,:);
            diffs = [diffs; sing_dev];
            all_dev=sqrt(diffs(ir,1).^2 + diffs(ir,2).^2 + diffs(ir,3).^2 + diffs(ir,4).^2 + diffs(ir,5).^2 + diffs(ir,6).^2);
           mocalc = [mocalc; all_dev];
           if (all_dev <= 2) && (sing_dev > 1.25)
               clist2=[clist2; ir];
           end
                       
        end
        
        % This finds the images that need to be censored.  The first part finds
        % where the motion was high and the second accounts for the images
        % surrounding the aberrant valume.
         clist1 = find(mocalc > 2);
         clist= vertcat(clist1, clist2);
         clist= sort(clist);
                 
        if ~isempty(clist)
            for cs = 1:length(clist)
                clistn = [clistn; clist(cs); clist(cs)+1; clist(cs)+2];
            end
        end
        
        % Save the motion parameters and censor list for later use in the model.
        eval(['save mps_sub' num2str(sub(i)) '_b' num2str(run) ' rps diffs mocalc']);
        eval(['save censorlist_sub' num2str(sub(i)) '_b' num2str(run) ' clistn']);
        
        figure; plot(rps(:,1),'r'); 
        hold on; plot(rps(:,2),'b');
        hold on; plot(rps(:,3),'g');
        hold on; plot(rps(:,4),'c');
        hold on; plot(rps(:,5),'m');
        hold on; plot(rps(:,6),'y');
        legend('X','Y','Z','r','Theta','PHI','Coordinate');
        
        title('Visual inspection');
       
        eval(['saveas(gcf,''ARF_sub' num2str(sub(i)) '_block' num2str(run) '_rp.ai'');']); %Save graph to an Illustrator file
        eval(['saveas(gcf,''ARF_sub' num2str(sub(i)) '_block' num2str(run) '_rp.tif'');']);
        
        close 
        
    end
    
end


%% plot
sub = [2 3 5:18];
mainpath = 'C:\Users\YAN\Desktop\ARF_preprocessing\VI';
cd(mainpath);

for i = 1:length(sub)
    subfol = strcat('sub',num2str(sub(i)));
    fullfol = strcat(mainpath,'\',subfol);
    
    for run = 1:2
        if run == 1
            impdir = strcat(fullfol,'\EPI1'); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        else
            impdir = strcat(fullfol,'\EPI2'); %strcat('C:/SweatStudy/Pilot_fMRI/EPI_files/Realigned');
        end
        cd(impdir);
        
        eval(['rpfile = strcat(''ARF_sub' num2str(sub(i)) '_b' num2str(run) '_rp.txt'')']);
        rps = importdata(rpfile);
        
        figure; plot(rps(:,1),'r'); 
        hold on; plot(rps(:,2),'b');
        hold on; plot(rps(:,3),'g');
        hold on; plot(rps(:,4),'c');
        hold on; plot(rps(:,5),'m');
        hold on; plot(rps(:,6),'y');
        legend('X','Y','Z','r','Theta','PHI','Coordinate');
        
        title('Visual inspection');
       
        eval(['saveas(gcf,''ARF_sub' num2str(sub(i)) '_block' num2str(run) '_rp.fig'');']); %Save graph to an Illustrator fil
        
        close 
        
    end
    
end
