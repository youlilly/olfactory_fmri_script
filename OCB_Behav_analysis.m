%% OCB Behavioral analyzers - for piloting experiments

Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG'; 'AF'; 'QL'; 'BT'; 'YZ'; 'SL'; 'YZ'; 'TL'; 'BD'; 'MJ'; 'CB'; 'AS'; 'MZ'; 'EE'; 'FL'; 'SR'; 'YX'];

%% Collate Pleasantness ratings
% Prerating "odor_sorted": odorid visindex intensityindex familiarityindex pungencyindex
% Postrating "odor_sorted": odorid riskindex visindex intensityindex
% familiarityindex pungencyindex

allsubs = 1:28;

%pre-rating
PreRatings = [];
for sub = allsubs
initials = Subinitials(sub,:);    
eval(['load OCB_pre_rating_olf_sub' num2str(sub) '_' initials ';']);
valence = odor_sorted(:,2)';
PreRatings = [PreRatings; sub valence];
end

%post-rating
PostRatings = [];
for sub = [2:20 22:27]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);
valence = odor_sorted(:,3)';
PostRatings = [PostRatings; sub valence];
end

%% Collate intensity ratings
% Prerating "odor_sorted": odorid visindex intensityindex familiarityindex pungencyindex
% Postrating "odor_sorted": odorid riskindex visindex intensityindex
% familiarityindex pungencyindex

%pre-rating
PreRatings = [];
for sub = 1:28
initials = Subinitials(sub,:);    
eval(['load OCB_pre_rating_olf_sub' num2str(sub) '_' initials ';']);
inten = odor_sorted(:,3)';
PreRatings = [PreRatings; sub inten];
end

%post-rating
PostRatings = [];
for sub = [2:20 22:27]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);
inten = odor_sorted(:,4)';
PostRatings = [PostRatings; sub inten];
end


%% Collate familiarity ratings
% Prerating "odor_sorted": odorid visindex intensityindex familiarityindex pungencyindex
% Postrating "odor_sorted": odorid riskindex visindex intensityindex
% familiarityindex pungencyindex
%pre-rating
PreRatings = [];
for sub = 1:28
initials = Subinitials(sub,:);    
eval(['load OCB_pre_rating_olf_sub' num2str(sub) '_' initials ';']);
famil = odor_sorted(:,4)';
PreRatings = [PreRatings; sub famil];
end 


%post-rating
PostRatings = [];
for sub = [2:20 22:27]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);
famil = odor_sorted(:,5)';
PostRatings = [PostRatings; sub famil];
end

%% Collate pungency ratings
% Prerating "odor_sorted": odorid visindex intensityindex familiarityindex pungencyindex
% Postrating "odor_sorted": odorid riskindex visindex intensityindex
% familiarityindex pungencyindex
%pre-rating
PreRatings = [];
for sub = 1:28
initials = Subinitials(sub,:);    
eval(['load OCB_pre_rating_olf_sub' num2str(sub) '_' initials ';']);
pung = odor_sorted(:,5)';
PreRatings = [PreRatings; sub pung];
end 


%post-rating
PostRatings = [];
for sub = [2:20 22:27]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);
pung = odor_sorted(:,6)';
PostRatings = [PostRatings; sub pung];
end

%% Collate risk ratings
%post-rating
PostRatings = [];
for sub = [3:2:20 23:2:27]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);

if rem(sub,2) == 0
risk = odor_sorted(:,2)';
else
risk = [odor_sorted(5,2) odor_sorted(4,2) odor_sorted(3,2) odor_sorted(2,2) odor_sorted(2,2)];
end

PostRatings = [PostRatings; sub risk];
end


%% Collate triangular test pre-post ratings

%pre-rating
AllAcc = [];

for sub = [20:27]
initials = Subinitials(sub,:);    
eval(['load OCB_pre_triangular_sub' num2str(sub) '_' initials ' acc rt;']);
mRT = mean(rt);
AllAcc = [AllAcc; sub acc/5*100 mRT];
end

% post-rating
AllpostAcc = [];

for sub = [20 22:27]
initials = Subinitials(sub,:);    
eval(['load OCB_post_triangular_sub' num2str(sub) '_' initials ' acc rt;']);
mRT = mean(rt);
AllpostAcc = [AllpostAcc; sub acc/5*100 mRT];
end

%% pre-Cond overall performance

%pre-rating
AllodorA = [];
AllSuds = [];

for sub = 20:28
initials = Subinitials(sub,:);    
eval(['load OCB_beh_precond_sub' num2str(sub) '_' initials ';']);
odor1 = rtypes(find(rtypes(:,2)==1), 3);
odor2 = rtypes(find(rtypes(:,2)==2), 3);
odor3 = rtypes(find(rtypes(:,2)==3), 3);
odor4 = rtypes(find(rtypes(:,2)==4), 3);
odor5 = rtypes(find(rtypes(:,2)==5), 3);

odor1A = length(find(odor1 == 7)) /length(odor1)*100 % proportion of odor A judgment
odor2A = length(find(odor2 == 7)) /length(odor2)*100 % proportion of odor A judgment
odor3A = length(find(odor3 == 7)) /length(odor3)*100 % proportion of odor A judgment
odor4A = length(find(odor4 == 7)) /length(odor4)*100 % proportion of odor A judgment
odor5A = length(find(odor5 == 7)) /length(odor5)*100 % proportion of odor A judgment

AllodorA = [AllodorA; sub odor1A odor2A odor3A odor4A odor5A];
AllSuds = [AllSuds; sub SUDS1]
end

%% Pre-Cond Odor A as CS+

AllpreodorA = [];
AllodorA_rt = [];%average RTs for all/correct odorA response

for sub = [4:2:27]
initials = Subinitials(sub,:);    
eval(['load OCB_beh_precond_sub' num2str(sub) '_' initials ';']);


odor1 = rtypes(find(rtypes(:,2)==1), 3);
odor2 = rtypes(find(rtypes(:,2)==2), 3);
odor3 = rtypes(find(rtypes(:,2)==3), 3);
odor4 = rtypes(find(rtypes(:,2)==4), 3);
odor5 = rtypes(find(rtypes(:,2)==5), 3);

odor1A = length(find(odor1 == 7)) /length(odor1)*100; % proportion of odor A judgment
odor2A = length(find(odor2 == 7)) /length(odor2)*100; % proportion of odor A judgment
odor3A = length(find(odor3 == 7)) /length(odor3)*100; % proportion of odor A judgment
odor4A = length(find(odor4 == 7)) /length(odor4)*100; % proportion of odor A judgment
odor5A = length(find(odor5 == 7)) /length(odor5)*100; % proportion of odor A judgment

%%this makes sure only the odor-related RTs (excluding no-odor judgment) are used for mean
odor1rt = [odor1 rtypes(find(rtypes(:,2)==1), 4)];
odor2rt = [odor2 rtypes(find(rtypes(:,2)==2), 4)];
odor3rt = [odor3 rtypes(find(rtypes(:,2)==3), 4)];
odor4rt = [odor4 rtypes(find(rtypes(:,2)==4), 4)];
odor5rt = [odor5 rtypes(find(rtypes(:,2)==5), 4)];

odor1rt = odor1rt(find(odor1rt(:,1)==7|odor1rt(:,1)==9),2); 
odor2rt = odor2rt(find(odor2rt(:,1)==7|odor2rt(:,1)==9),2);
odor3rt = odor3rt(find(odor3rt(:,1)==7|odor3rt(:,1)==9),2);
odor4rt = odor4rt(find(odor4rt(:,1)==7|odor4rt(:,1)==9),2);
odor5rt = odor5rt(find(odor5rt(:,1)==7|odor5rt(:,1)==9),2);

AllpreodorA = [AllpreodorA; sub odor1A odor2A odor3A odor4A odor5A];
AllodorA_rt = [AllodorA_rt; sub mean(odor1rt) mean(odor2rt) mean(odor3rt) mean(odor4rt) mean(odor5rt)];

end

%% pre-Cond Odor B CS+

AllpreodorB  = [];
AllodorB_rt = [];%average RTs for all/correct odorB response

for sub = [5:2:27]
initials = Subinitials(sub,:);    
eval(['load OCB_beh_precond_sub' num2str(sub) '_' initials ';']);


odor1 = rtypes(find(rtypes(:,2)==1), 3);
odor2 = rtypes(find(rtypes(:,2)==2), 3);
odor3 = rtypes(find(rtypes(:,2)==3), 3);
odor4 = rtypes(find(rtypes(:,2)==4), 3);
odor5 = rtypes(find(rtypes(:,2)==5), 3);

odor1B = length(find(odor1 == 9)) /length(odor1)*100; % proportion of odor A judgment
odor2B = length(find(odor2 == 9)) /length(odor2)*100; % proportion of odor A judgment
odor3B = length(find(odor3 == 9)) /length(odor3)*100; % proportion of odor A judgment
odor4B = length(find(odor4 == 9)) /length(odor4)*100; % proportion of odor A judgment
odor5B = length(find(odor5 == 9)) /length(odor5)*100; % proportion of odor A judgment

%%this makes sure only the odor-related RTs (excluding no-odor judgment) are used for mean
odor1rt = [odor1 rtypes(find(rtypes(:,2)==1), 4)];
odor2rt = [odor2 rtypes(find(rtypes(:,2)==2), 4)];
odor3rt = [odor3 rtypes(find(rtypes(:,2)==3), 4)];
odor4rt = [odor4 rtypes(find(rtypes(:,2)==4), 4)];
odor5rt = [odor5 rtypes(find(rtypes(:,2)==5), 4)];

odor1rt = odor1rt(find(odor1rt(:,1)==7|odor1rt(:,1)==9),2); 
odor2rt = odor2rt(find(odor2rt(:,1)==7|odor2rt(:,1)==9),2);
odor3rt = odor3rt(find(odor3rt(:,1)==7|odor3rt(:,1)==9),2);
odor4rt = odor4rt(find(odor4rt(:,1)==7|odor4rt(:,1)==9),2);
odor5rt = odor5rt(find(odor5rt(:,1)==7|odor5rt(:,1)==9),2);

AllpreodorB = [AllpreodorB; sub odor5B odor4B odor3B odor2B odor1B];
AllodorB_rt = [AllodorB_rt; sub mean(odor5rt) mean(odor4rt) mean(odor3rt) mean(odor2rt) mean(odor1rt)];

end


%% post-Cond Odor A CS+

AllpostodorA = [];
AllpostSuds = [];
AllpostodorA_rt = [];%average RTs for all/correct odorA response


for sub = [4:2:27]
initials = Subinitials(sub,:);    
eval(['load OCB_beh_postcond_sub' num2str(sub) '_' initials ';']);

i = 1;
while i <= length(rtypes)
if ismember(rtypes(i,1),csp_trials)
        rtypes(i,:) = [];
    end
    i = i + 1;
end

odor1 = rtypes(find(rtypes(:,2)==1), 3);
odor2 = rtypes(find(rtypes(:,2)==2), 3);
odor3 = rtypes(find(rtypes(:,2)==3), 3);
odor4 = rtypes(find(rtypes(:,2)==4), 3);
odor5 = rtypes(find(rtypes(:,2)==5), 3);

odor1A = length(find(odor1 == 7)) /length(odor1)*100 % proportion of odor A judgment
odor2A = length(find(odor2 == 7)) /length(odor2)*100 % proportion of odor A judgment
odor3A = length(find(odor3 == 7)) /length(odor3)*100 % proportion of odor A judgment
odor4A = length(find(odor4 == 7)) /length(odor4)*100 % proportion of odor A judgment
odor5A = length(find(odor5 == 7)) /length(odor5)*100 % proportion of odor A judgment

%%this makes sure only the odor-related RTs (excluding no-odor judgment) are used for mean
odor1rt = [odor1 rtypes(find(rtypes(:,2)==1), 4)];
odor2rt = [odor2 rtypes(find(rtypes(:,2)==2), 4)];
odor3rt = [odor3 rtypes(find(rtypes(:,2)==3), 4)];
odor4rt = [odor4 rtypes(find(rtypes(:,2)==4), 4)];
odor5rt = [odor5 rtypes(find(rtypes(:,2)==5), 4)];

odor1rt = odor1rt(find(odor1rt(:,1)==7|odor1rt(:,1)==9),2); 
odor2rt = odor2rt(find(odor2rt(:,1)==7|odor2rt(:,1)==9),2);
odor3rt = odor3rt(find(odor3rt(:,1)==7|odor3rt(:,1)==9),2);
odor4rt = odor4rt(find(odor4rt(:,1)==7|odor4rt(:,1)==9),2);
odor5rt = odor5rt(find(odor5rt(:,1)==7|odor5rt(:,1)==9),2);

AllpostodorA = [AllpostodorA; sub odor1A odor2A odor3A odor4A odor5A];
AllpostSuds = [AllpostSuds; sub SUDS2]
AllpostodorA_rt = [AllpostodorA_rt; sub mean(odor1rt) mean(odor2rt) mean(odor3rt) mean(odor4rt) mean(odor5rt)];

end

%% post-Cond Odor B CS+

AllpostodorB  = [];
AllpostSuds = [];
AllpostodorB_rt = [];%average RTs for all/correct odorB response

for sub = [3:2:20 23:2:27]%[5:2:19]
initials = Subinitials(sub,:);    
eval(['load OCB_beh_postcond_sub' num2str(sub) '_' initials ';']);

i = 1;
while i <= length(rtypes)
if ismember(rtypes(i,1),csp_trials)
        rtypes(i,:) = [];
    end
    i = i + 1;
end

odor1 = rtypes(find(rtypes(:,2)==1), 3);
odor2 = rtypes(find(rtypes(:,2)==2), 3);
odor3 = rtypes(find(rtypes(:,2)==3), 3);
odor4 = rtypes(find(rtypes(:,2)==4), 3);
odor5 = rtypes(find(rtypes(:,2)==5), 3);

odor1B = length(find(odor1 == 9)) /length(odor1)*100 % proportion of odor A judgment
odor2B = length(find(odor2 == 9)) /length(odor2)*100 % proportion of odor A judgment
odor3B = length(find(odor3 == 9)) /length(odor3)*100 % proportion of odor A judgment
odor4B = length(find(odor4 == 9)) /length(odor4)*100 % proportion of odor A judgment
odor5B = length(find(odor5 == 9)) /length(odor5)*100 % proportion of odor A judgment

odor1rt = [odor1 rtypes(find(rtypes(:,2)==1), 4)];
odor2rt = [odor2 rtypes(find(rtypes(:,2)==2), 4)];
odor3rt = [odor3 rtypes(find(rtypes(:,2)==3), 4)];
odor4rt = [odor4 rtypes(find(rtypes(:,2)==4), 4)];
odor5rt = [odor5 rtypes(find(rtypes(:,2)==5), 4)];

odor1rt = odor1rt(find(odor1rt(:,1)==7|odor1rt(:,1)==9),2); 
odor2rt = odor2rt(find(odor2rt(:,1)==7|odor2rt(:,1)==9),2);
odor3rt = odor3rt(find(odor3rt(:,1)==7|odor3rt(:,1)==9),2);
odor4rt = odor4rt(find(odor4rt(:,1)==7|odor4rt(:,1)==9),2);
odor5rt = odor5rt(find(odor5rt(:,1)==7|odor5rt(:,1)==9),2);


AllpostodorB = [AllpostodorB; sub odor5B odor4B odor3B odor2B odor1B];
AllpostSuds = [AllpostSuds; sub SUDS2]
AllpostodorB_rt = [AllpostodorB_rt; sub mean(odor5rt) mean(odor4rt) mean(odor3rt) mean(odor2rt) mean(odor1rt)];

end

