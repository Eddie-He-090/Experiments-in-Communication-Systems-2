A='lorem ipsum';
B='�������';
T='Text.txt';
Data1 = importdata(T);
disp('Precedent text: ');
disp(Data1);
X=input('Input: ','s');
fid=fopen(T, 'at+');
% fprintf(fid,'\n%s',[A,X]);
fprintf(fid,'\n%s',X);
fclose(fid);
Data2 = importdata(T);
disp('Updated text: ');
disp(Data2);