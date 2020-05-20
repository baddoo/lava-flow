% Plots H
function plotH(h1,cen,rad,F)

fullH = @(z) 1 + 1/F*h1(z);

% Matrix of boundary points
zb = exp(1i*linspace(0,2*pi)).*rad + cen;

% Grid points
z = linspace(-2+min(min(real(zb))),2+max(max(real(zb)))) ...
+1i*linspace(-2+min(min(imag(zb))),2+max(max(imag(zb))))';

% Remove grid points inside cylinders
M = numel(rad)-1;
 for m=0:M
    z(abs(z-cen(m+1))<rad(m+1))=nan; 
 end
 
% Define limits
lims = 1+1/F*[-.1+min(min(real(h1(z)))),.1+max(max(real(h1(z))))];

% Plot cylinders
for m = 0:M
   [X,Y,Z] = cylinder(rad(m+1),100);
mesh(X+real(cen(m+1)),Y+imag(cen(m+1)),5*Z,'FaceColor','k','EdgeColor','k')
hold on
fill3(X(2,:)+real(cen(m+1)),Y(2,:)+imag(cen(m+1)),0*Z +lims(2),'k') % Fill top of cylinder
end

% Plot fluid
surf(real(z),imag(z),fullH(z),'FaceColor','interp','EdgeAlpha',0)
colormap hot

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

end