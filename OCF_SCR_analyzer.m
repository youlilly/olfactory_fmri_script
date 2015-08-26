%% load filtered scr files: need to crab both scr (1), resp (2) and event
%% (5) channels
% Channel 1: SCR; unit: microS
% Channel 2: Respiration; unit: Volts
% Channel 5: dio signals from presentation computer

for s = 3
    
    for b = 1:6
        
        eval(['data = load_acq(''Sub' num2str(s) '_B' num2str(b) '_filtered.acq'');']);
        scrdata = data.data(:,1);
        respdata = data.data(:,2);
        trigger = data.data(:,5);
        
        figure;
        subplot(3,1,1)
        plot(1:length(scrdata),scrdata);
        
        subplot(3,1,2)
        plot(1:length(respdata),respdata);
        
        subplot(3,1,3)
        plot(1:length(trigger),trigger);        
        
        
        eval(['save OCF_SCR_Sub' num2str(s) '_B' num2str(b) '_filtered.mat scrdata respdata trigger;']);
        eval(['saveas(gcf,''OCF_Sub' num2str(s) '_B' num2str(b) '_filtered_psychophys.tif'');']); 
        close(gcf)
        
        clear data
    end
    
end


%% Load unfiltered scr files; additional fitering needed

for s = 35
    
    for b =3
        
        eval(['data = load_acq(''Sub' num2str(s) '_B' num2str(b) '.acq'');']);
        scrdata = data.data(:,1);
        respdata = data.data(:,2);
        trigger = data.data(:,5);
        
        figure;
        subplot(3,1,1)
        plot(1:length(scrdata),scrdata);
        
        subplot(3,1,2)
        plot(1:length(respdata),respdata);
        
        subplot(3,1,3)
        plot(1:length(trigger),trigger);        
        
        
        eval(['save OCF_SCR_Sub' num2str(s) '_B' num2str(b) '.mat scrdata respdata trigger;']);
        eval(['saveas(gcf,''OCF_Sub' num2str(s) '_B' num2str(b) '_psychophys.tif'');']); 
        close(gcf)
        
        clear data        
    end
    
end
%% filter data between 0.0159 and 5hz

for s = 35
    for b = 3
        
        eval(['load OCF_SCR_Sub' num2str(s) '_B' num2str(b) '.mat scrdata respdata trigger;']);
        
        % now low-pass filter at 0.5hz, using parameters generated by
        % scr_predata, based on 1000hz sampling rate
        % [filt.b filt.a]=butter(lp.order, lp.freq/nyq);nyq = sr/2;
        filt.b = [0.0016 0.0016];
        filt.a = [1 -0.9969];
        
        scrdata = scr_filtfilt(filt.b, filt.a, scrdata);
        
        % now high-pass filter at 0.0159hz, using parameters generated by
        % scr_predata, based on 1000hz sampling rate
        %  [filt.b filt.a]=butter(hp.order, hp.freq/nyq, 'high');;nyq =
        %  sr/2;
%         filt.b = [1, -1];
%         filt.a = [1, -0.9999];
%         
%         scrdata = scr_filtfilt(filt.b, filt.a, scrdata);
        
        figure;
        subplot(3,1,1)
        plot(1:length(scrdata),scrdata);
        
        subplot(3,1,2)
        plot(1:length(respdata),respdata);
        
        subplot(3,1,3)
        plot(1:length(trigger),trigger);
        
        eval(['save OCF_SCR_Sub' num2str(s) '_B' num2str(b) '_filtered.mat scrdata respdata trigger;']);
        eval(['saveas(gcf,''OCF_Sub' num2str(s) '_B' num2str(b) '_filtered_psychophys.tif'');']);
        close(gcf)
        
        clear data           
        
    end
    
end

%% find the triggers that correspond to onsets of different conditions
SubInt = ['AA';'BB';'NG';];

for s = 3
    initials = SubInt(s,:);
    
    for b = 5
        
        eval(['load OCF_SCR_Sub' num2str(s) '_B' num2str(b) '_filtered.mat scrdata respdata trigger;']);
        
        switch b
            case(1)
        eval(['load OCF_precond_sub' num2str(s) '_' initials '.mat StimR;']);
        eventcode = StimR; %specifies trial type
        trigdiff = trigger(2:end)-trigger(1:end-1);
        trigind = find(trigdiff ==5)+1; %this code find the timepoint where there is a trigger (change from 0 to 5 volts) in Biopac data; sampling 1000/s
        eventdata = [trigind(2:end) eventcode]; %82 trials; 1st Col: event onset; 2nd COl: event type
        
            case(2)
        eval(['load OCF_cond_sub' num2str(s) '_' initials '.mat StimR;']);
        eventcode = StimR(:,1); %specifies trial type
        trigdiff = trigger(2:end)-trigger(1:end-1);
        trigind = find(trigdiff ==5); %this code find the timepoint where there is a trigger (change from 0 to 5 volts) in Biopac data; sampling 1000/s
        tindiff = trigind(2:end)-trigind(1:end-1);
        trig = trigind (find(tindiff > 8000)+1) + 1; %all meaning triggers should at least have 8000 seconds apart
        trig = [trigind(2)+1; trig]; %need to add back the 2nd trigger (the 1st trigger is marking the start of a trial), which has been missed due to multiple differential scores
        eventdata = [trig eventcode]; %21 trials; 1st Col: event onset; 2nd COl: event type
                            
            case(3)
        eval(['load OCF_postcond_sub' num2str(s) '_' initials '.mat StimR;']);
        eventcode = StimR; %specifies trial type
        trigdiff = trigger(2:end)-trigger(1:end-1);
        trigind = find(trigdiff ==5); %this code find the timepoint where there is a trigger (change from 0 to 5 volts) in Biopac data; sampling 1000/s
        tindiff = trigind(2:end)-trigind(1:end-1);
        trig = trigind (find(tindiff > 8000)+1) + 1; %all meaning triggers should at least have 8000 seconds apart
        trig = [trigind(2)+1; trig]; %need to add back the 2nd trigger (the 1st trigger is marking the start of a trial), which has been missed due to multiple differential scores
        eventdata = [trig eventcode]; %87 trials; 1st Col: event onset; 2nd COl: event type
        %UCS trials positions: [3,14,38,59,76;]
        for ii = [3 14 38 59 76]
            eventdata(ii,2) = 99; %change the event code to 99 (indicating UCS)
        end
        
            case(4)
        eval(['load OCF_postcond2_sub' num2str(s) '_' initials '.mat StimR;']);
        eventcode = StimR; %specifies trial type
        trigdiff = trigger(2:end)-trigger(1:end-1);
        trigind = find(trigdiff ==5); %this code find the timepoint where there is a trigger (change from 0 to 5 volts) in Biopac data; sampling 1000/s
        tindiff = trigind(2:end)-trigind(1:end-1);
        trig = trigind (find(tindiff > 8000)+1) + 1; %all meaning triggers should at least have 8000 seconds apart
        trig = [trigind(2)+1; trig]; %need to add back the 2nd trigger (the 1st trigger is marking the start of a trial), which has been missed due to multiple differential scores
        eventdata = [trig eventcode]; %1st Col: event onset; 2nd COl: event type
        for ii = [3 14 38 59 76]
            eventdata(ii,2) = 99; %change the event code to 99 (indicating UCS)
        end        
        
                                        
            case(5)
        eval(['load OCF_localizer_sub' num2str(s) '_' initials '.mat StimR;']);
        eventcode = StimR'; %specifies trial type
        trigdiff = trigger(2:end)-trigger(1:end-1);
        trigind = find(trigdiff ==5)+1; %this code find the timepoint where there is a trigger (change from 0 to 5 volts) in Biopac data; sampling 1000/s
        eventdata = [trigind(2:end) eventcode]; %90 trials; 1st Col: event onset; 2nd COl: event type
                        
                
        end
        
        %generates the eventdata varialbe; 1st column: onset times, 2nd
        %column: trial types
                eval(['save OCF_SCR_Sub' num2str(s) '_B' num2str(b) '_filtered_eventdata.mat eventdata;']);

        
    end
end


%% Conditioning block 1 & 2
% Gabor onsets (targetonTimes), time window [-1000 3000]
% UCS onsets, time window [-1000 5000]

Allsub_peak = cell(1,7); %O1-O5 peak SCR
Allsub_peaklat = cell(1,7); %O1-O5 peak SCR latency



allsubs = [1];

sr = 1000;%The sampling rate of the Biosemi data; this will be used further down, but can be set here because it will be consistent for all subjects

for s = allsubs
    

%Declare varialbes to store peak values
O1_peak = [];
O2_peak = [];
O3_peak = [];
O4_peak = [];
O5_peak = [];
Rec_peak = [];
UCS_peak = [];

%Declare variables to store peak latencies
O1_peaklat = [];
O2_peaklat = [];
O3_peaklat = [];
O4_peaklat = [];
O5_peaklat = [];
Rec_peaklat = [];
UCS_peaklat = [];
 
        
    for b = 1:5
             
    
                eval(['load OCF_SCR_Sub' num2str(s) '_B' num2str(b) '_filtered_eventdata.mat eventdata;']);


        O1onsets = eventdata(eventdata(:,2)==1,1);
        O2onsets = eventdata(eventdata(:,2)==2,1);
        O3onsets = eventdata(eventdata(:,2)==3,1);        
        O4onsets = eventdata(eventdata(:,2)==4,1);
        O5onsets = eventdata(eventdata(:,2)==5,1);
        Reconsets = eventdata(eventdata(:,2)==8,1);
        UCSonsets = eventdata(eventdata(:,2)==99,1);
        

                    for i=1:length(O1onsets)
                        t1 = O1onsets(i); % 
                        SC1 = data(t1-1000:t1+5000,1); % set the time window to be -1000 to 5000ms centered on O1 onset 
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); %Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        O1_peak = [O1_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        O1_peaklat  = [O1_peaklat peaklat]; %store the peak latencies into the cell
                    end
                    
                    Allsub_peak{1,1} = [Allsub_peak{1,1}; a mean(O1_peak)];
                    Allsub_peaklat{1,1} = [Allsub_peaklat{1,1}; a mean(O1_peaklat)];
                    
                    for i = 1:length(O2onsets)
                        t1 = O2onsets(i);
                        SC1 = data(t1-1000:t1+5000,1); % set the time window to be -1000 to 5000ms centered on O2 onset 
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); %Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        O2_peak = [O2_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        O2_peaklat  = [O2_peaklat  peaklat]; %store the peak latencies into the cell                                           
                    end
                    
                    Allsub_peak{1,2} = [Allsub_peak{1,2}; a mean(O2_peak)];
                    Allsub_peaklat{1,2} = [Allsub_peaklat{1,2}; a mean(O2_peaklat)]; 
                    
                    for i=1:length(O3onsets)
                        t1 = O3onsets(i); 
                        SC1 = data(t1-1000:t1+5000,1); % set the time window to be -1000 to 5000ms centered on O3 onset 
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); % Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        O3_peak = [O3_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        O3_peaklat  = [O3_peaklat  peaklat]; %store the peak latencies into the cell
                    end
                    
                    Allsub_peak{1,3} = [Allsub_peak{1,3}; a mean(O3_peak)];
                    Allsub_peaklat{1,3} = [Allsub_peaklat{1,3}; a mean(O3_peaklat)];
                    
                    for i = 1:length(O4onsets)
                        t1 = O4onsets(i);
                        SC1 = data(t1-1000:t1+5000,1); 
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); %Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        O4_peak = [O4_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        O4_peaklat  = [O4_peaklat  peaklat]; %store the peak latencies into the cell                                           
                    end
                    
                    Allsub_peak{1,4} = [Allsub_peak{1,4}; a mean(O4_peak)];
                    Allsub_peaklat{1,4} = [Allsub_peaklat{1,4}; a mean(O4_peaklat)];                         
                    

                    for i = 1:length(Reconsets)
                        t1 = Reconsets(i);
                        SC1 = data(t1-1000:t1+5000,1); % set the time window to be -1000 to 4500ms centered on Gabor onset (targonTimes)
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); %Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        FCSafe_peak = [Rec_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        FCSafe_peaklat  = [Rec_peaklat  peaklat]; %store the peak latencies into the cell                                           
                    end
                    
                    Allsub_peak{1,5} = [Allsub_peak{1,5}; a mean(Rec_peak)];
                    Allsub_peaklat{1,5} = [Allsub_peaklat{1,5}; a mean(Rec_peaklat)];                         
                    
                    
                    for i = 1:length(O5onsets)
                        t1 = O5onsets(i);
                        SC1 = data(t1-1000:t1+5000,1); % set the time window to be -1000 to 4500ms centered on Gabor onset (targonTimes)
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); %Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        FCSafe_peak = [O5_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        FCSafe_peaklat  = [O5_peaklat  peaklat]; %store the peak latencies into the cell                                           
                    end
                    
                    Allsub_peak{1,5} = [Allsub_peak{1,5}; a mean(O5_peak)];
                    Allsub_peaklat{1,5} = [Allsub_peaklat{1,5}; a mean(O5_peaklat)];                         
                    
                                        
                    for i = 1:length(UCSonsets)
                        t1 = UCSonsets(i);
                        SC1 = data(t1-1000:t1+5000,1); % set the time window to be -1000 to 4500ms centered on Gabor onset (targonTimes)
                        SC1 = [SC1; sr];
                        [peak, peaklat, basept, baselat, rtn, rtnd]=findscr_event_related_CANLab_com(SC1); %Gets information from a preexisting program designed to gather information about GSR for the short time frame
                        FCSafe_peak = [UCS_peak peak]; %store the peak amplitudes into the cell: color, CS+
                        FCSafe_peaklat  = [UCS_peaklat  peaklat]; %store the peak latencies into the cell                                           
                    end
                    
                    Allsub_peak{1,5} = [Allsub_peak{1,5}; a mean(UCS_peak)];
                    Allsub_peaklat{1,5} = [Allsub_peaklat{1,5}; a mean(UCS_peaklat)];                         
                    
                                        
                        

                
           
     

    end
end