%% Collate intensity ratings

Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];
%pre-rating
PreRatings = [];
for sub = [9 11 12]
initials = Subinitials(sub,:);    
eval(['load OCB_pre_rating_olf_sub' num2str(sub) '_' initials ';']);
inten = odor_sorted(:,3)';
PreRatings = [PreRatings; sub inten];
end

%post-rating
PostRatings = [];
for sub = [9 11 12]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);
inten = odor_sorted(:,4)';
PostRatings = [PostRatings; sub inten];
end


%% Collate familiarity ratings
% in "odor_sorted": odorid visindex intensityindex familiarityindex pungencyindex

Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];
%pre-rating
PreRatings = [];
for sub = 1:12
initials = Subinitials(sub,:);    
eval(['load OCB_pre_rating_olf_sub' num2str(sub) '_' initials ';']);
inten = odor_sorted(:,4)';
PreRatings = [PreRatings; sub inten];
end

%% Collate risk ratings

Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];


%post-rating
PostRatings = [];
for sub = [9 11 12]
initials = Subinitials(sub,:);    
eval(['load OCB_risk_rating_olf_sub' num2str(sub) '_' initials ';']);
risk = odor_sorted(:,2)';
PostRatings = [PostRatings; sub risk];
end


%% Collate triangular test pre-post ratings

Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];
%pre-rating
AllAcc = [];

for sub = [9 11 12]
initials = Subinitials(sub,:);    
eval(['load OCB_pre_triangular_sub' num2str(sub) '_' initials ' acc rt;']);
mRT = mean(rt);
AllAcc = [AllAcc; sub acc/5*100 mRT];
end

%post-rating
AllpostAcc = [];

for sub = [9 11 12]
initials = Subinitials(sub,:);    
eval(['load OCB_post_triangular_sub' num2str(sub) '_' initials ' acc rt;']);
mRT = mean(rt);
AllpostAcc = [AllpostAcc; sub acc/5*100 mRT];
end

%% pre-Cond performance

Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];
%pre-rating
AllodorA = [];
AllSuds = [];

for sub = [9 11 12]
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


%% post-Cond Odor A CS+
Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];

AllpostodorA = [];
AllpostSuds = [];

for sub = [9 11 12]
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

AllpostodorA = [AllpostodorA; sub odor1A odor2A odor3A odor4A odor5A];
AllpostSuds = [AllpostSuds; sub SUDS2]
end

%% post-Cond Odor B CS+
Subinitials = ['AC';'NH';'AG';'HK';'CR';'AJ'; 'SR'; 'XT'; 'JF'; 'HN'; 'QB'; 'AG' ];

AllpostodorB  = [];
AllpostSuds = [];

for sub = [9 11]
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

AllpostodorB = [AllpostodorB; sub odor5B odor4B odor3B odor2B odor1B];
AllpostSuds = [AllpostSuds; sub SUDS2]
end

