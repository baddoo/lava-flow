%% Viscous flow height calculator

% Calculates the height of a viscous flow interacting with
% a number of cylinders
% This code requires the SKPRIME function, which can be downloaded
% at https://github.com/ACCA-Imperial/SKPrime

rad = [.5;.25;.5; .7]; % Vector of cylinder radii

% Array of cylinders
%rad = .3+0*linspace(-1,1,11).';
%cen = 1i*(-5:5).';
cen = [1i;-1i;3i+3;1i+3]; % Vector of cylinder centers

%cen = 2*exp(1i*pi/2*(0:3)')*exp(1i*pi/4);
%rad = 1 + 0*cen;

h1 = calculateH1(cen,rad); % Returns a function handle corresponding to h1

 % Plots h1
zb = exp(1i*linspace(0,2*pi)).*rad + cen;
 
 z = linspace(-2+min(min(real(zb))),2+max(max(real(zb)))) ...
    +1i*linspace(-2+min(min(imag(zb))),2+max(max(imag(zb))))';
zf = z;
 M = numel(rad)-1;
 for m=0:M
    z(abs(z-cen(m+1))<rad(m+1))=nan; 
end
 
F = 100; % Typical value of F


% Define limits
lims = 1+1/F*[-.1+min(min(real(h1(z)))),.1+max(max(real(h1(z))))];

beta = pi/8;

fullH = 1 + 1/F*h1(z);

% Plot cylinders
for m = 0:M
   [X,Y,Z] = cylinder(rad(m+1));
mesh(X+real(cen(m+1)),Y+imag(cen(m+1)),5*Z,'FaceColor','k','EdgeColor','k')
hold on
fill3(X(2,:)+real(cen(m+1)),Y(2,:)+imag(cen(m+1)),0*Z +lims(2),'k') % Fill top of cylinder
end

surf(real(z),imag(z),fullH,'FaceColor','interp','EdgeAlpha',0)

 % Supplement grid with points close to boundary
for m=0:M
    zs = cen(m+1)+(rad(m+1)+linspace(eps,.2,10)').*exp(1i*linspace(0,2*pi));
surf(real(zs),imag(zs),1+1/F*h1(zs),'FaceColor','interp','EdgeAlpha',0)
end

caxis(lims)
hold off
% Rescale Z axis
set(gca,'DataAspectRatio',[1 1 1/F])
zlim(lims) 
% Does it satisfy the far-field condition?
bigZ = 1e5*exp(1i*pi/4);
disp(['The far field value is ' ,num2str(abs(h1(bigZ)./bigZ)) ])
