%% Viscous flow height calculator

% Calculates the height of a viscous flow interacting with
% a number of cylinders.
% This code requires the SKPRIME function, which can be downloaded
% at https://github.com/ACCA-Imperial/SKPrime

% Array of cylinders
%rad = .3+0*linspace(-1,1,11).'; 
%cen = 1i*(-5:5).';

% Three cylinders
rad = [.5;.25;.5; .7]; % Vector of cylinder radii
cen = [1i;-1i;3i+3;1i+3]; % Vector of cylinder centers

h1 = calculateH1(cen,rad); % Returns a function handle corresponding to h1

F = 10; % Typical value of F
plotH(h1,cen,rad,F);

% Does it satisfy the far-field condition?
bigZ = 1e5*exp(1i*pi/4);
disp(['The far field value is ' ,num2str(abs(h1(bigZ))) '.'])
