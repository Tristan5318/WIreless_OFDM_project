info = audiodevinfo;

disp('Input devices:');
disp(struct2table(info.input));

disp('Output devices:');
disp(struct2table(info.output));