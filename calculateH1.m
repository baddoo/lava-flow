%% CALCULATEH1

function h1 = calculateH1(cen,rad)

% Returns a function handle 

M = numel(rad)-1; % Connectivity of domain

if M==0
    
    % In the simply connected  case we can use the Milne-Thomson circle theorem directly    
h1 = @(z) (z-cen) + rad^2./(z-cen);
    
else
% Define Mobius map that maps the first circle to the unit disc,
% and every other circle inside the unit disc

a = 2; b = 1; % These parameters could be any values s.t. |a|^2 - |b|^2 = 1. These are just convenient
res = (a*rad(1)+b*cen(1)+b/conj(a)*(conj(a)*cen(1)-conj(b)*rad(1)))./conj(a); % Define residue of map
mob = @(z) (b*z + a*rad(1)-b*cen(1))./(conj(a)*z + conj(b)*rad(1) - conj(a)*cen(1));

rot = exp(-1i*angle(res));
% Calculate transformed radii and centers of other circles
tCen = (mob(cen(2:end) - rad(2:end).^2./conj(conj(b)/conj(a)*rad(1)-cen(1) + cen(2:end))));
tRad = abs(tCen - mob(cen(2:end) + rad(2:end)));

% Rotate domain so that the residue is pure real
tCen = tCen*rot;

% Define Schottky planar domain associated with circlur domain
dom = skpDomain(tCen(:),tRad(:));

% Calculate parameteric derivative of hydrodynamic Green's function
dpg0y = greensC0Dpxy(rot*b/conj(a), 'y', dom);
dpg0x = greensC0Dpxy(rot*b/conj(a), 'x', dom);

% Define function h
chi = angle(res);
h1 = @(z) real(-2*pi*real(res)*(cos(chi)*dpg0y(rot*mob(z)) + sin(chi)*dpg0x(rot*mob(z))) - z);

end

end