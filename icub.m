 %Wysylanie wiadomosci do robota oraz odbieranie 

t=tcpip('127.0.0.1',10030); %Laczenie z robotem
fopen(t);

fprintf(t,'CONNECT foo');    %Wyslanie komendy do polaczenia sie z robotem
disp(fscanf(t));             %otrzymanie odpowiedzi o polaczeniu
    
%pobranie informacji z robota
fprintf(t,'d');
fprintf(t,sprintf('get axes'));
fscanf(t);

fprintf(t,'d');
fprintf(t,sprintf('get encs 2'));
d=fscanf(t);


d1= textscan(d,' %s ','Delimiter',')(');
celldisp(d1);
T=d1{1}{2};
wynik=textscan(T,' %f %f %f %f %f %f','Delimiter','][}{');

%wartosci encodera
% glowa_gora_dol=cell2mat(wynik(1));
% glowa_lewo_prawo=cell2mat(wynik(2));
% glowa_obrot=cell2mat(wynik(3));
% oczy_gora_dol=cell2mat(wynik(4));
% oczy_lewo_prawo=cell2mat(wynik(5));
% eyes_vergence=cell2mat(wynik(6));
% 
%  
% %Sterowanie przy pomocy Jakobianu manipulatoraa
% %theta1_oczy= oczy_gora_dol;
% %theta2_oczy= oczy_lewo_prawo;

 u1=[0; 0; 0];
 u2=[0;0.012; 0];


theta1_oczy=15;
theta2_oczy=20;
theta1_oczy1=theta2_oczy*(3.14/180);
theta2_oczy1=theta2_oczy*(3.14/180);

w1 = [0; 1; 0];%kierunek obrotu   [x,y,z]
w2 = [1; 0; 0];%kierunekexpm obrotu  [x,y,z]

p02 = [0;0.019; 0; 1]; % polozenie /home/patrykpoczatkowe manipulatorak obrotu   [x,y,z]
p01 = [0;0.012;0; 1]; % polozenie poczatkowe manipulatora // polozenie konc


s1 = [w1; cross(-w1,u1)];
s2 = [w2; cross(-w2,u2)];

hat = @(a) [0   -a(3) a(2) a(4); ...  %macierz skosnometryczna
              a(3) 0   -a(1) a(5); ...
             -a(2) a(1) 0   a(6); ...
               0    0    0    0 ];

 

 p2 =expm(hat(s1)*theta1_oczy1)*expm(hat(s2)*theta2_oczy1)*p02

 J1=[hat(s1)*p2,expm(hat(s1)*theta1_oczy1)*hat(s2)*inv(expm(hat(s1)*theta1_oczy1))*p2]

 dq1=inv(J1(1:2,:))*[p2(1);p2(2)]
% % 
% 
%  %//////////////////////////////////////////////////////////////////////////////////////////
% 
 
 theta1_glowa_stopnie=0;
 theta1_glowa=theta1_glowa_stopnie *(3.14/180);

 theta2_glowa_stopnie=0;
 theta2_glowa=theta2_glowa_stopnie *(3.14/180);
 
 theta3_glowa_stopnie=0;
 theta3_glowa=theta3_glowa_stopnie *(3.14/180);
%  
 
 %Sterowanie przy pomocy Jakobianu manipulatora
 u1_glowa=[0; 0; 0];  
 u2_glowa=[0; 0.05; 0];
 u3_glowa=[0; 0.125;0];
 
 w1_glowa=[1; 0; 0];%kierunek obrotu   [x,y,z]
 w2_glowa=[0; 1; 0];%kierunek obrotu   [x,y,z]
 w3_glowa=[0; 0; 1];%kierunek obrotu   [x,y,z]
 
 p01_glowa = [0; 0; 05; 1]; % polozenie poczatkowe manipulatora // polozenie koncowki
 p02_glowa = [0; 0.125; 0; 1]; % polozenie poczatkowe manipulatorak obrotu   [x,y,z]
 p03_glowa = [0; 0.19; 0; 1]; % polozenie /home/patrykpoczatkowe manipulatorak obrotu   [x,y,z]

s1_glowa = [w1_glowa; cross(-w1_glowa,u1_glowa)];
s2_glowa = [w2_glowa; cross(-w2_glowa,u2_glowa)];
s3_glowa = [w3_glowa; cross(-w3_glowa,u3_glowa)];


p3=expm(hat(s1_glowa)*theta1_glowa)*expm(hat(s2_glowa)*theta2_glowa)*expm(hat(s3_glowa)*theta3_glowa)*p03_glowa

p_p=hat(s1_glowa)*theta1_glowa*expm(hat(s1_glowa)*theta1_glowa)*expm(hat(s2_glowa)*theta2_glowa)*expm(hat(s3_glowa)*theta3_glowa)*p3;
p2_p=hat(s2_glowa)*theta2_glowa*expm(hat(s2_glowa)*theta2_glowa)*expm(hat(s1_glowa)*theta1_glowa)*expm(hat(s3_glowa)*theta3_glowa)*p3;
p3_p=hat(s3_glowa)*theta3_glowa*expm(hat(s3_glowa)*theta3_glowa)*expm(hat(s1_glowa)*theta1_glowa)*expm(hat(s2_glowa)*theta2_glowa)*p3;

J2 = [p_p,p2_p,p3_p]
%dq_glowa=inv(J(1:3,:))*[p3(1);p3(2),p3(3)];
%////////////////////////////////////////////////////////////////////////////////////
 %Kinematyka odwrotna, znalezienie zmiennych przegubowych w zaleznosci od
 %pozycji i orientacji koncowki roboczej.
dq2=inv(J2(1:3,:))*[p3(1);p3(2);p3(3)]


    
%wyslanie wartosci ruchu glowy i oczu
    fprintf(t,'d');          
   fprintf(t,sprintf('set poss (%f %f %f %f %f %f)',...
       theta1_glowa_stopnie,theta2_glowa_stopnie,theta3_glowa_stopnie,theta1_oczy,theta2_oczy,0));
% otrzymanie potwierdzenia o wykonaniu ruchu
disp(fscanf(t));

%zamkniecie polaczenia
fclose(t);
delete(t);
