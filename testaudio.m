%This script displays the different input and output of the computer. It
%provides the IDs for the microphone and speaker. 

info = audiodevinfo;

disp('Input devices:');
disp(struct2table(info.input));

disp('Output devices:');
disp(struct2table(info.output));