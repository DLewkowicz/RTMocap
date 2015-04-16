clear all
close all

for i=1:4
  
   %Read the data and convert to N-by-3-by-M Matrix
   data=RTMocap_read(['Raw_data_',num2str(i,'%03d'),'.txt']);
   
   %Read the time vector
   time=dlmread(['Raw_time_',num2str(i,'%03d'),'.txt']);
   
   %Interpolate the data with the time vector
   data_interpolated=RTMocap_interp(data,200,time);
   
   %Smooth the data at 15hz
   data_smoothed=RTMocap_smooth(data_interpolated,200,15);
   
   %Get kinematic inforation from marker number 5 (left-wrist)
   ktab(i)=RTMocap_kinematics(data_smoothed(:,:,5),200);
   
   %Plot information for all markers plus kinematics of marker number 5
   RTMocap_display(data_smoothed,200,5);
   
   %save figures
   saveas(gcf, ['Raw_profile_',num2str(i,'%03d'),'.pdf'], 'pdf' );
   close
   
   saveas(gcf, ['Raw_3D_',num2str(i,'%03d'),'.pdf'], 'pdf' );
   close
   
end   
