                
lambda0 =  0.1;


% Glass data BK7
glassParameters = [1.03961212,0.00600069867,0.231792344,0.0200179144,1.01046945,103.560653];
wavLen = lambda0;
K1 = glassParameters(1);
L1 = glassParameters(2);
K2 = glassParameters(3);
L2 = glassParameters(4);
K3 = glassParameters(5);
L3 = glassParameters(6);

dndl1 = -((0.25.*(-((2.*K1.*wavLen.^3)./(-L1+wavLen.^2).^2)+...
    (2.*K1.*wavLen)./(-L1+wavLen.^2)-...
    (2.*K2.*wavLen.^3)./(-L2+wavLen.^2).^2+...
    (2.*K2.*wavLen)./(-L2+wavLen.^2)-...
    (2.*K3.*wavLen.^3)./(-L3+wavLen.^2).^2+...
    (2.*K3.*wavLen)./(-L3+wavLen.^2)).^2)./...
    (1+(K1.*wavLen.^2)./(-L1+wavLen.^2)+...
    (K2.*wavLen.^2)./(-L2+wavLen.^2)+...
    (K3.*wavLen.^2)./(-L3+wavLen.^2)).^1.5)+...
    (0.5.*((8.*K1.*wavLen.^4)./(-L1+wavLen.^2).^3-...
    (10.*K1.*wavLen.^2)./(-L1+wavLen.^2).^2+...
    (2.*K1)./(-L1+wavLen.^2)+...
    (8.*K2.*wavLen.^4)./(-L2+wavLen.^2).^3-...
    (10.*K2.*wavLen.^2)./(-L2+wavLen.^2).^2+...
    (2.*K2)./(-L2+wavLen.^2)+...
    (8.*K3.*wavLen.^4)./(-L3+wavLen.^2).^3-...
    (10.*K3.*wavLen.^2)./(-L3+wavLen.^2).^2+...
    (2.*K3)./(-L3+wavLen.^2)))./...
    (1+(K1.*wavLen.^2)./(-L1+wavLen.^2)+...
    (K2.*wavLen.^2)./(-L2+wavLen.^2)+...
    (K3.*wavLen.^2)./(-L3+wavLen.^2)).^0.5;
                
 dndl2 = -(0.25*(-((2*K1*wavLen^3)/(-L1+wavLen^2)^2)+...
    (2*K1*wavLen)/(-L1+wavLen^2)-...
    (2*K2*wavLen^3)/(-L2+wavLen^2)^2+...
    (2*K2*wavLen)/(-L2+wavLen^2)-...
    (2*K3*wavLen^3)/(-L3+wavLen^2)^2+...
    (2*K3*wavLen)/(-L3+wavLen^2))^2)/...
    (1+(K1*wavLen^2)/(-L1+wavLen^2)+...
    (K2*wavLen^2)/(-L2+wavLen^2)+...
    (K3*wavLen^2)/(-L3+wavLen^2))^1.5+...
    (0.5*((8*K1*wavLen^4)/(-L1+wavLen^2)^3-...
    (10*K1*wavLen^2)/(-L1+wavLen^2)^2+...
    (2*K1)/(-L1+wavLen^2)+...
    (8*K2*wavLen^4)/(-L2+wavLen^2)^3-...
    (10*K2*wavLen^2)/(-L2+wavLen^2)^2+...
    (2+K2)/(-L2+wavLen^2)+...
    (8*K3*wavLen^4)/(-L3+wavLen^2)^3-...
    (10*K3*wavLen^2)/(-L3+wavLen^2)^2+...
    (2*K3)/(-L3+wavLen^2)))/...
    (1+(K1*wavLen^2)/(-L1+wavLen^2)+...
    (K2*wavLen^2)/(-L2+wavLen^2)+...
    (K3*wavLen^2)/(-L3+wavLen^2))^0.5;
x=1