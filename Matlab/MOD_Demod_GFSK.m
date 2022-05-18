
x = input('Ingrese la trma de bits para modular = ');   % [0 0 0 0 0 1 0 1 0 0 1 1 1 0 0]
N = length(x);
Tb = 1;   

nb = 100;   
digit = []; 
for n = 1:1:N
    if x(n) == 1;
       sig = ones(1,nb);
    else x(n) == 0;
        sig = zeros(1,nb);
    end
     digit = [digit sig];
end
t1 = Tb/nb:Tb/nb:nb*N*(Tb/nb);   
figure('Name','Modulacion GFSK','NumberTitle','off');
subplot(3,1,1);
plot(t1,digit,'LineWidth',2.5);
grid on;
axis([0 Tb*N -0.5 1.5]);
xlabel('Tiempo[s]');
ylabel('Amplitud [V]');
title('Senal de entrada');
% **************************** Modulacion FSK  *****************************
Ac = 10;         % Amplitud del carrier  
br = 1/Tb;       % Bit rate
Fc1 = br*10;     % Frecuencia del Carrier para entrada '1'
Fc2 = br*5;      % Frecuencia del Carrier para entrada '0'
t2 = Tb/nb:Tb/nb:Tb;   % senal del tiempo   
mod = [];
for (i = 1:1:N)
    if (x(i) == 1)
        y = Ac*cos(2*pi*Fc1*t2);   % Modulation signal with carrier signal 1
    else
        y = Ac*cos(2*pi*Fc2*t2);   % Modulation signal with carrier signal 2
    end
    mod = [mod y];
end
t3 = Tb/nb:Tb/nb:Tb*N;   % Time period
%subplot(3,1,2);
%plot(t3,mod);
%xlabel('Tiempo[s]');
%ylabel('Amplitud [V]');
%title('Senal Modulada por FSK');
% ****************************  Filtrado Gaussiano  *****************************
gaussian_filter = fspecial('gaussian',[1 100],1);

gfsk = conv(mod,gaussian_filter);

subplot(3,1,2);
plot(gfsk);
xlabel('Tiempo[s]');
ylabel('Amplitud [V]');
title('Senal Modulada por GFSK');

% *************************** GFSK Demodulation ****************************
 % ********************* SENAL TRANSMITIDA ******************************
x = mod;
% ********************* MODELO DEL CANAL *****************************
h = 5;   % ATENUACION DE LA SENAL 
w = 7;   % RUIDO
% ********************* SENAL RECIBIDA *********************************
y = h.*x + w;   % Convolucion

 
s = length(t2);
demod = [];
for n = s:s:length(y)
  t4 = Tb/nb:Tb/nb:Tb;        
  c1 = cos(2*pi*Fc1*t4);      % Senal del carrier para un 1 binario
  c2 = cos(2*pi*Fc2*t4);      % Senal del carrier para un o binario
  mc1 = c1.*y((n-(s-1)):n);   % Convolucion 
  mc2 = c2.*y((n-(s-1)):n);   % Convolucion 
  t5 = Tb/nb:Tb/nb:Tb;
  z1 = trapz(t5,mc1);         % Intregacion 
  z2 = trapz(t5,mc2);         % Intregacion 
  rz1 = round(2*z1/Tb);
  rz2 = round(2*z2/Tb);
  if(rz1 > Ac/2)              % condiciones logicas
    a = 1;
  else(rz2 > Ac/2)
    a = 0;
  end
  demod = [demod a];
end

% ********** Representacion demodulada de la informacion como una senal digital **d********
digit = [];
for n = 1:length(demod);
    if demod(n) == 1;
       sig = ones(1,nb);
    else demod(n) == 0;
        sig = zeros(1,nb);
    end
     digit = [digit sig];
end
t5 = Tb/nb:Tb/nb:nb*length(demod)*(Tb/nb);   % Time period
subplot(3,1,3)
plot(t5,digit,'LineWidth',2.5);grid on;
axis([0 Tb*length(demod) -0.5 1.5]);
xlabel('Tiempo[s]');
ylabel('Amplitud [V]');
title('Senal demodulada por GFSK');
