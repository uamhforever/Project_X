function [ returnData1, returnData2, returnData3 ] = ZemaxFormula(...
        returnFlag,glassParameters,wavelength,derivativeOrder)
    %ZemaxFormula: A user defined function for ZemaxFormula glasses which use dispersion formulas from zemax.
    % The function returns differnt parameters when requested by the main program.
    % It follows the common format used for defining user defined coating.
    % Inputs:
    %   (returnFlag,glassParameters,wavelength,derivativeOrder)
    % Outputs: depends on the return flag
    %   returnFlag = 1
    %       Outputs: [FieldNames,FieldTypes,DefaultGlassParameterStruct]
    %   returnFlag = 2
    %       Outputs: [refractiveIndex]
    
    % <<<<<<<<<<<<<<<<<<<<<<<<< Author Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>
    %   Written By: Worku, Norman Girma
    %   Advisor: Prof. Herbert Gross
    %	Optical System Design and Simulation Research Group
    %   Institute of Applied Physics
    %   Friedrich-Schiller-University of Jena
    
    % <<<<<<<<<<<<<<<<<<< Change History Section >>>>>>>>>>>>>>>>>>>>>>>>>>
    % Date----------Modified By ---------Modification Detail--------Remark
    % Jun 19,2015   Worku, Norman G.     Original Version   
    
    %% Default input vaalues
    if nargin == 1
        if returnFlag == 1
            % Just continue
        else
            disp(['Error: The function ZemaxFormula() needs two arguments',...
                'return type and glassParameters.']);
            returnData1 = NaN;
            returnData2 = NaN;
            returnData3 = NaN;
            return;
        end
    elseif nargin < 2
        disp(['Error: The function ZemaxFormula() needs two arguments',...
            'return type and glassParameters.']);
        returnData1 = NaN;
        returnData2 = NaN;
        returnData3 = NaN;
        return;
    elseif nargin == 2
        wavelength = 0.55*10^-6;
        derivativeOrder = 0;
    elseif nargin == 3
        derivativeOrder = 0;
    end
    %%
    switch returnFlag(1)
        case 1 % Return the field names and initial values of glassParameters
            returnData1 = {'FormulaType','CoefficientData'};
            returnData2 = {{'Schott','Sellmeier1','Sellmeier2',...
                           'Sellmeier3','Sellmeier4','Sellmeier5','Herzberger',...
                           'Conrady','HandbookOfOptics1','HandbookOfOptics2',...
                           'Extended', 'Extended2', 'Extended3'},...
                           {'numeric','numeric','numeric','numeric','numeric',...
                           'numeric','numeric','numeric','numeric','numeric'}};
            defaultGlassParameter = struct();
            defaultGlassParameter.FormulaType = 'Sellmeier1';
            defaultGlassParameter.CoefficientData = [0,0,0,0,0,0,0,0,0,0];
            returnData3 = defaultGlassParameter;
        case 2 % Return the refractive index of given derivative order
            nWav = size(wavelength,2);
            formulaType = glassParameters.FormulaType;
            coefficientData = glassParameters.CoefficientData;
            
            refractiveIndex = computeRefractiveIndex(formulaType,coefficientData,wavelength,derivativeOrder);
            
            returnData1 = refractiveIndex;
            returnData2 = NaN;
            returnData3 = NaN;
    end
    
    
end

function refractiveIndex = computeRefractiveIndex(formulaType,coefficientData,wavLenInM,derivativeOrder)
        % for a given wavelength. Uses dispersion equation.
    nRay = size(wavLenInM,2);
    format long;
    
    % all the coeffifints are in sq. µm and the wavelength in um
    % First convert Wavelength to um as all sellmeir coefficients
    % are in sq um.
    wavLenInUM = wavLenInM*10^6;
    
    switch lower(formulaType)
        case  lower('Schott')
            A0 = coefficientData(1);
            A1 = coefficientData(2);
            A2 = coefficientData(3);
            A3 = coefficientData(4);
            A4 = coefficientData(5);
            A5 = coefficientData(6);
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(A0 + A1*(wavLenInUM.^2) + ...
                        A2*(wavLenInUM.^-2)+ A3*(wavLenInUM.^-4) + ...
                        A4*(wavLenInUM.^-6)+ A5*(wavLenInUM.^-8));
                case 1
                    refractiveIndex=(0.5.*(-((8.*a5)./wavLenInUM.^9)-(6.*a4)./wavLenInUM.^7-...
                        (4.*a3)./wavLenInUM.^5-(2.*a2)./wavLenInUM.^3+2.*a1.*wavLenInUM))./...
                        (a0+a5./wavLenInUM.^8+a4./wavLenInUM.^6+a3./wavLenInUM.^4+...
                        a2./wavLenInUM.^2+a1.*wavLenInUM.^2).^0.5;
                case 2
                    refractiveIndex=-((0.25.*(-((8.*a5)./wavLenInUM.^9)-(6.*a4)./wavLenInUM.^7-...
                        (4.*a3)./wavLenInUM.^5-(2.*a2)./wavLenInUM.^3+2.*a1.*wavLenInUM).^2)./...
                        (a0+a5./wavLenInUM.^8+a4./wavLenInUM.^6+a3./wavLenInUM.^4+...
                        a2./wavLenInUM.^2+a1.*wavLenInUM.^2).^1.5)+...
                        (0.5.*(2.*a1+(72.*a5)./wavLenInUM.^10+(42.*a4)./wavLenInUM.^8+...
                        (20.*a3)./wavLenInUM.^6+(6.*a2)./wavLenInUM.^4))./...
                        (a0+a5./wavLenInUM.^8+a4./wavLenInUM.^6+a3./wavLenInUM.^4+...
                        a2./wavLenInUM.^2+a1.*wavLenInUM.^2).^0.5;
            end
        case  lower('Sellmeier1')
            
            K1 = coefficientData(1);
            L1 = coefficientData(2);
            K2 = coefficientData(3);
            L2 = coefficientData(4);
            K3 = coefficientData(5);
            L3 = coefficientData(6);
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(1 + ...
                        ((K1*wavLenInUM.^2)./(wavLenInUM.^2 - L1)) + ...
                        ((K2*wavLenInUM.^2)./(wavLenInUM.^2 - L2)) + ...
                        ((K3*wavLenInUM.^2)./(wavLenInUM.^2 - L3)));
                case 1
                    refractiveIndex=(0.5.*(-((2.*K1.*wavLenInUM.^3)./(-L1+wavLenInUM.^2).^2)+(2.*K1.*wavLenInUM)./(-L1+wavLenInUM.^2)-...
                        (2.*K2.*wavLenInUM.^3)./(-L2+wavLenInUM.^2).^2+(2.*K2.*wavLenInUM)./(-L2+wavLenInUM.^2)-...
                        (2.*K3.*wavLenInUM.^3)./(-L3+wavLenInUM.^2).^2+(2.*K3.*wavLenInUM)./(-L3+wavLenInUM.^2)))./...
                        (1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+(K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+...
                        (K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((2.*K1.*wavLenInUM.^3)./(-L1+wavLenInUM.^2).^2)+...
                        (2.*K1.*wavLenInUM)./(-L1+wavLenInUM.^2)-(2.*K2.*wavLenInUM.^3)./(-L2+wavLenInUM.^2).^2+...
                        (2.*K2.*wavLenInUM)./(-L2+wavLenInUM.^2)-(2.*K3.*wavLenInUM.^3)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3.*wavLenInUM)./(-L3+wavLenInUM.^2)).^2)./...
                        (1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+(K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+...
                        (K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)).^1.5)+(0.5.*((8.*K1.*wavLenInUM.^4)./(-L1+wavLenInUM.^2).^3-...
                        (10.*K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2).^2+(2.*K1)./(-L1+wavLenInUM.^2)+...
                        (8.*K2.*wavLenInUM.^4)./(-L2+wavLenInUM.^2).^3-(10.*K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2).^2+...
                        (2.*K2)./(-L2+wavLenInUM.^2)+(8.*K3.*wavLenInUM.^4)./(-L3+wavLenInUM.^2).^3-...
                        (10.*K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2).^2+(2.*K3)./(-L3+wavLenInUM.^2)))./...
                        (1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+(K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+...
                        (K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('Sellmeier2')
            
            A = coefficientData(1);
            B = coefficientData(2);
            L1 = coefficientData(3);
            B2 = coefficientData(4);
            L2 = coefficientData(5);
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(1 + A + ...
                        ((B*wavLenInUM.^2)./(wavLenInUM.^2 - L1^2)) + ...
                        ((B2)./(wavLenInUM.^2 - L2^2)));
                case 1
                    refractiveIndex=(0.5.*(-((2.*B.*wavLenInUM.^3)./(-L1.^2+wavLenInUM.^2).^2)+...
                        (2.*B.*wavLenInUM)./(-L1.^2+wavLenInUM.^2)-(2.*B2.*wavLenInUM)./(-L2.^2+wavLenInUM.^2).^2))./...
                        (1+A+(B.*wavLenInUM.^2)./(-L1.^2+wavLenInUM.^2)+B2./(-L2.^2+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((2.*B.*wavLenInUM.^3)./(-L1.^2+wavLenInUM.^2).^2)+...
                        (2.*B.*wavLenInUM)./(-L1.^2+wavLenInUM.^2)-(2.*B2.*wavLenInUM)./(-L2.^2+wavLenInUM.^2).^2).^2)./...
                        (1+A+(B.*wavLenInUM.^2)./(-L1.^2+wavLenInUM.^2)+B2./(-L2.^2+wavLenInUM.^2)).^1.5)+...
                        (0.5.*((8.*B.*wavLenInUM.^4)./(-L1.^2+wavLenInUM.^2).^3-(10.*B.*wavLenInUM.^2)./(-L1.^2+wavLenInUM.^2).^2+...
                        (2.*B)./(-L1.^2+wavLenInUM.^2)+(8.*B2.*wavLenInUM.^2)./(-L2.^2+wavLenInUM.^2).^3-...
                        (2.*B2)./(-L2.^2+wavLenInUM.^2).^2))./(1+A+(B.*wavLenInUM.^2)./(-L1.^2+wavLenInUM.^2)+...
                        B2./(-L2.^2+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('Sellmeier3')
            K1 = coefficientData(1);
            L1 = coefficientData(2);
            K2 = coefficientData(3);
            L2 = coefficientData(4);
            K3 = coefficientData(5);
            L3 = coefficientData(6);
            K4 = coefficientData(7);
            L4 = coefficientData(8);
            
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(1 + ...
                        ((K1*wavLenInUM.^2)./(wavLenInUM.^2 - L1)) + ...
                        ((K2*wavLenInUM.^2)./(wavLenInUM.^2 - L2)) + ...
                        ((K3*wavLenInUM.^2)./(wavLenInUM.^2 - L3))+ ...
                        ((K4*wavLenInUM.^2)./(wavLenInUM.^2 - L4)));
                case 1
                    refractiveIndex=(0.5.*(-((2.*K1.*wavLenInUM.^3)./(-L1+wavLenInUM.^2).^2)+...
                        (2.*K1.*wavLenInUM)./(-L1+wavLenInUM.^2)-(2.*K2.*wavLenInUM.^3)./(-L2+wavLenInUM.^2).^2+...
                        (2.*K2.*wavLenInUM)./(-L2+wavLenInUM.^2)-(2.*K3.*wavLenInUM.^3)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3.*wavLenInUM)./(-L3+wavLenInUM.^2)-(2.*K4.*wavLenInUM.^3)./(-L4+wavLenInUM.^2).^2+...
                        (2.*K4.*wavLenInUM)./(-L4+wavLenInUM.^2)))./...
                        (1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+(K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+...
                        (K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)+(K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((2.*K1.*wavLenInUM.^3)./(-L1+wavLenInUM.^2).^2)+...
                        (2.*K1.*wavLenInUM)./(-L1+wavLenInUM.^2)-(2.*K2.*wavLenInUM.^3)./(-L2+wavLenInUM.^2).^2+...
                        (2.*K2.*wavLenInUM)./(-L2+wavLenInUM.^2)-(2.*K3.*wavLenInUM.^3)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3.*wavLenInUM)./(-L3+wavLenInUM.^2)-(2.*K4.*wavLenInUM.^3)./(-L4+wavLenInUM.^2).^2+...
                        (2.*K4.*wavLenInUM)./(-L4+wavLenInUM.^2)).^2)./(1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+...
                        (K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+(K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)+...
                        (K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2)).^1.5)+...
                        (0.5.*((8.*K1.*wavLenInUM.^4)./(-L1+wavLenInUM.^2).^3-(10.*K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2).^2+...
                        (2.*K1)./(-L1+wavLenInUM.^2)+(8.*K2.*wavLenInUM.^4)./(-L2+wavLenInUM.^2).^3-...
                        (10.*K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2).^2+(2.*K2)./(-L2+wavLenInUM.^2)+...
                        (8.*K3.*wavLenInUM.^4)./(-L3+wavLenInUM.^2).^3-(10.*K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3)./(-L3+wavLenInUM.^2)+(8.*K4.*wavLenInUM.^4)./(-L4+wavLenInUM.^2).^3-...
                        (10.*K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2).^2+(2.*K4)./(-L4+wavLenInUM.^2)))./...
                        (1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+(K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+...
                        (K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)+(K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('Sellmeier4')
            A = coefficientData(1);
            B = coefficientData(2);
            C = coefficientData(3);
            D = coefficientData(4);
            E = coefficientData(5);
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt( A + ...
                        ((B*wavLenInUM.^2)./(wavLenInUM.^2 - C)) + ...
                        ((D*wavLenInUM.^2)./(wavLenInUM.^2 - E)));
                case 1
                    refractiveIndex=(0.5.*(-((2.*B.*wavLenInUM.^3)./(-C+wavLenInUM.^2).^2)+...
                        (2.*B.*wavLenInUM)./(-C+wavLenInUM.^2)-(2.*D.*wavLenInUM.^3)./(-E+wavLenInUM.^2).^2+...
                        (2.*D.*wavLenInUM)./(-E+wavLenInUM.^2)))./(A+(B.*wavLenInUM.^2)./(-C+wavLenInUM.^2)+...
                        (D.*wavLenInUM.^2)./(-E+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((2.*B.*wavLenInUM.^3)./(-C+wavLenInUM.^2).^2)+...
                        (2.*B.*wavLenInUM)./(-C+wavLenInUM.^2)-(2.*D.*wavLenInUM.^3)./(-E+wavLenInUM.^2).^2+...
                        (2.*D.*wavLenInUM)./(-E+wavLenInUM.^2)).^2)./(A+(B.*wavLenInUM.^2)./(-C+wavLenInUM.^2)+...
                        (D.*wavLenInUM.^2)./(-E+wavLenInUM.^2)).^1.5)+(0.5.*((8.*B.*wavLenInUM.^4)./(-C+wavLenInUM.^2).^3-...
                        (10.*B.*wavLenInUM.^2)./(-C+wavLenInUM.^2).^2+(2.*B)./(-C+wavLenInUM.^2)+...
                        (8.*D.*wavLenInUM.^4)./(-E+wavLenInUM.^2).^3-(10.*D.*wavLenInUM.^2)./(-E+wavLenInUM.^2).^2+...
                        (2.*D)./(-E+wavLenInUM.^2)))./(A+(B.*wavLenInUM.^2)./(-C+wavLenInUM.^2)+...
                        (D.*wavLenInUM.^2)./(-E+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('Sellmeier5')
            K1 = coefficientData(1);
            L1 = coefficientData(2);
            K2 = coefficientData(3);
            L2 = coefficientData(4);
            K3 = coefficientData(5);
            L3 = coefficientData(6);
            K4 = coefficientData(7);
            L4 = coefficientData(8);
            K5 = coefficientData(9);
            L5 = coefficientData(10);
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(1 + ...
                        ((K1*wavLenInUM.^2)./(wavLenInUM.^2 - L1)) + ...
                        ((K2*wavLenInUM.^2)./(wavLenInUM.^2 - L2)) + ...
                        ((K3*wavLenInUM.^2)./(wavLenInUM.^2 - L3))+ ...
                        ((K4*wavLenInUM.^2)./(wavLenInUM.^2 - L4))+ ...
                        ((K5*wavLenInUM.^2)./(wavLenInUM.^2 - L5)));
                case 1
                    refractiveIndex=(0.5.*(-((2.*K1.*wavLenInUM.^3)./(-L1+wavLenInUM.^2).^2)+...
                        (2.*K1.*wavLenInUM)./(-L1+wavLenInUM.^2)-(2.*K2.*wavLenInUM.^3)./(-L2+wavLenInUM.^2).^2+...
                        (2.*K2.*wavLenInUM)./(-L2+wavLenInUM.^2)-(2.*K3.*wavLenInUM.^3)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3.*wavLenInUM)./(-L3+wavLenInUM.^2)-(2.*K4.*wavLenInUM.^3)./(-L4+wavLenInUM.^2).^2+...
                        (2.*K4.*wavLenInUM)./(-L4+wavLenInUM.^2)-(2.*K5.*wavLenInUM.^3)./(-L5+wavLenInUM.^2).^2+...
                        (2.*K5.*wavLenInUM)./(-L5+wavLenInUM.^2)))./(1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+...
                        (K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+(K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)+...
                        (K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2)+(K5.*wavLenInUM.^2)./(-L5+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-(0.25.*(-((2.*K1.*wavLenInUM.^3)./(-L1+wavLenInUM.^2).^2)+...
                        (2.*K1.*wavLenInUM)./(-L1+wavLenInUM.^2)-(2.*K2.*wavLenInUM.^3)./(-L2+wavLenInUM.^2).^2+...
                        (2.*K2.*wavLenInUM)./(-L2+wavLenInUM.^2)-(2.*K3.*wavLenInUM.^3)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3.*wavLenInUM)./(-L3+wavLenInUM.^2)-(2.*K4.*wavLenInUM.^3)./(-L4+wavLenInUM.^2).^2+...
                        (2.*K4.*wavLenInUM)./(-L4+wavLenInUM.^2)-(2.*K5.*wavLenInUM.^3)./(-L5+wavLenInUM.^2).^2+...
                        (2.*K5.*wavLenInUM)./(-L5+wavLenInUM.^2)).^2)./(1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+...
                        (K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+(K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)+...
                        (K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2)+(K5.*wavLenInUM.^2)./(-L5+wavLenInUM.^2)).^1.5+...
                        (0.5.*((8.*K1.*wavLenInUM.^4)./(-L1+wavLenInUM.^2).^3-(10.*K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2).^2+...
                        (2.*K1)./(-L1+wavLenInUM.^2)+(8.*K2.*wavLenInUM.^4)./(-L2+wavLenInUM.^2).^3-...
                        (10.*K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2).^2+(2.*K2)./(-L2+wavLenInUM.^2)+...
                        (8.*K3.*wavLenInUM.^4)./(-L3+wavLenInUM.^2).^3-(10.*K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2).^2+...
                        (2.*K3)./(-L3+wavLenInUM.^2)+(8.*K4.*wavLenInUM.^4)./(-L4+wavLenInUM.^2).^3-...
                        (10.*K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2).^2+(2.*K4)./(-L4+wavLenInUM.^2)+...
                        (8.*K5.*wavLenInUM.^4)./(-L5+wavLenInUM.^2).^3-(10.*K5.*wavLenInUM.^2)./(-L5+wavLenInUM.^2).^2+...
                        (2.*K5)./(-L5+wavLenInUM.^2)))./(1+(K1.*wavLenInUM.^2)./(-L1+wavLenInUM.^2)+...
                        (K2.*wavLenInUM.^2)./(-L2+wavLenInUM.^2)+(K3.*wavLenInUM.^2)./(-L3+wavLenInUM.^2)+...
                        (K4.*wavLenInUM.^2)./(-L4+wavLenInUM.^2)+(K5.*wavLenInUM.^2)./(-L5+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('Herzberger')
            A = coefficientData(1);
            B = coefficientData(2);
            C = coefficientData(3);
            D = coefficientData(4);
            E = coefficientData(5);
            F = coefficientData(6);
            
            L = 1./(wavLenInUM.^2 - 0.028);
            
            switch derivativeOrder
                case 0
                    refractiveIndex =  A + B*L + C*L.^2 + D*L.^2 + ...
                        E*L.^4 + F*L.^6;
                case 1
                    refractiveIndex=2.*D1.*wavLenInUM+4.*E1.*wavLenInUM.^3+6.*F1.*wavLenInUM.^5-...
                        (4.*C1.*wavLenInUM)./(-0.028+wavLenInUM.^2).^3-...
                        (2.*B.*wavLenInUM)./(-0.028+wavLenInUM.^2).^2;
                    
                case 2
                    refractiveIndex=2.*D+12.*E.*wavLenInUM.^2+30.*F.*wavLenInUM.^4+...
                        (24.*C.*wavLenInUM.^2)./(-0.028+wavLenInUM.^2).^4-...
                        (4.*C)./(-0.028+wavLenInUM.^2).^3+...
                        (8.*B.*wavLenInUM.^2)./(-0.028+wavLenInUM.^2).^3-(2.*B)./(-0.028+wavLenInUM.^2).^2;
                    
            end
        case  lower('Conrady')
            n0 = coefficientData(1);
            A = coefficientData(2);
            B = coefficientData(3);
            
            switch derivativeOrder
                case 0
                    refractiveIndex =  n0 + A./wavLenInUM + B./wavLenInUM.^3.5;
                case 1
                    refractiveIndex=-((3.5.*B)./wavLenInUM.^4.5)-A./wavLenInUM.^2;
                    
                case 2
                    refractiveIndex=(15.75.*B)./wavLenInUM.^5.5+(2.*A)./wavLenInUM.^3;
                    
            end
        case  lower('HandbookOfOptics1')
            A = coefficientData(1);
            B = coefficientData(2);
            C = coefficientData(3);
            D = coefficientData(4);
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(A + B./(wavLenInUM^2-C)-D*wavLenInUM^2);
                case 1
                    refractiveIndex=(0.5.*(-2.*D.*wavLenInUM-(2.*B.*wavLenInUM)./(-C1+wavLenInUM.^2).^2))./...
                        (A-D.*wavLenInUM.^2+B./(-C1+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-2.*D.*wavLenInUM-(2.*B.*wavLenInUM)./(-C1+wavLenInUM.^2).^2).^2)./...
                        (A-D.*wavLenInUM.^2+B./(-C1+wavLenInUM.^2)).^1.5)+...
                        (0.5.*(-2.*D+(8.*B.*wavLenInUM.^2)./(-C1+wavLenInUM.^2).^3-(2.*B)./(-C1+wavLenInUM.^2).^2))./...
                        (A-D.*wavLenInUM.^2+B./(-C1+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('HandbookOfOptics2')
            A = coefficientData(1);
            B = coefficientData(2);
            C = coefficientData(3);
            D = coefficientData(4);
            
            switch derivativeOrder
                case 0
                    refractiveIndex = sqrt(A + ...
                        (B*wavLenInUM.^2)./(wavLenInUM.^2-C) - D*wavLenInUM^2);
                case 1
                    refractiveIndex=(0.5.*(-2.*D.*wavLenInUM-(2.*B.*wavLenInUM.^3)./(-C1+wavLenInUM.^2).^2+...
                        (2.*B.*wavLenInUM)./(-C1+wavLenInUM.^2)))./...
                        (A-D.*wavLenInUM.^2+(B.*wavLenInUM.^2)./(-C1+wavLenInUM.^2)).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-2.*D.*wavLenInUM-(2.*B.*wavLenInUM.^3)./(-C+wavLenInUM.^2).^2+...
                        (2.*B.*wavLenInUM)./(-C+wavLenInUM.^2)).^2)./(A-D.*wavLenInUM.^2+...
                        (B.*wavLenInUM.^2)./(-C+wavLenInUM.^2)).^1.5)+(0.5.*(-2.*D+(8.*B.*wavLenInUM.^4)./(-C+wavLenInUM.^2).^3-...
                        (10.*B.*wavLenInUM.^2)./(-C+wavLenInUM.^2).^2+(2.*B)./(-C+wavLenInUM.^2)))./...
                        (A-D.*wavLenInUM.^2+(B.*wavLenInUM.^2)./(-C+wavLenInUM.^2)).^0.5;
                    
            end
        case  lower('Extended')
            A0 = coefficientData(1);
            A1 = coefficientData(2);
            A2 = coefficientData(3);
            A3 = coefficientData(4);
            A4 = coefficientData(5);
            A5 = coefficientData(6);
            A6 = coefficientData(7);
            A7 = coefficientData(8);
            
            switch derivativeOrder
                case 0
                    refractiveIndex =  A0 + A1*wavLenInUM.^2 + A2*wavLenInUM.^-2 + ...
                        A3*wavLenInUM.^-4 + A4*wavLenInUM.^-6 + ...
                        A5*wavLenInUM.^-8 + A6*wavLenInUM.^-10 + ...
                        A7*wavLenInUM.^-12;
                case 1
                    refractiveIndex=(0.5.*(-((12.*a7)./wavLenInUM.^13)-(10.*a6)./wavLenInUM.^11-...
                        (8.*a5)./wavLenInUM.^9-(6.*a4)./wavLenInUM.^7-(4.*a3)./wavLenInUM.^5-...
                        (2.*a2)./wavLenInUM.^3+2.*a1.*wavLenInUM))./(a0+a7./wavLenInUM.^12+...
                        a6./wavLenInUM.^10+a5./wavLenInUM.^8+a4./wavLenInUM.^6+a3./wavLenInUM.^4+...
                        a2./wavLenInUM.^2+a1.*wavLenInUM.^2).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((12.*a7)./wavLenInUM.^13)-(10.*a6)./wavLenInUM.^11-...
                        (8.*a5)./wavLenInUM.^9-(6.*a4)./wavLenInUM.^7-(4.*a3)./wavLenInUM.^5-...
                        (2.*a2)./wavLenInUM.^3+2.*a1.*wavLenInUM).^2)./(a0+a7./wavLenInUM.^12+...
                        a6./wavLenInUM.^10+a5./wavLenInUM.^8+a4./wavLenInUM.^6+a3./wavLenInUM.^4+...
                        a2./wavLenInUM.^2+a1.*wavLenInUM.^2).^1.5)+(0.5.*(2.*a1+(156.*a7)./wavLenInUM.^14+...
                        (110.*a6)./wavLenInUM.^12+(72.*a5)./wavLenInUM.^10+(42.*a4)./wavLenInUM.^8+...
                        (20.*a3)./wavLenInUM.^6+(6.*a2)./wavLenInUM.^4))./(a0+a7./wavLenInUM.^12+a6./wavLenInUM.^10+...
                        a5./wavLenInUM.^8+a4./wavLenInUM.^6+a3./wavLenInUM.^4+a2./wavLenInUM.^2+a1.*wavLenInUM.^2).^0.5;
                    
            end
        case  lower('Extended2')
            A0 = coefficientData(1);
            A1 = coefficientData(2);
            A2 = coefficientData(3);
            A3 = coefficientData(4);
            A4 = coefficientData(5);
            A5 = coefficientData(6);
            A6 = coefficientData(7);
            A7 = coefficientData(8);
            
            switch derivativeOrder
                case 0
                    refractiveIndex =  A0 + A1*wavLenInUM.^2 + A2*wavLenInUM.^-2 + ...
                        A3*wavLenInUM.^-4 + A4*wavLenInUM.^-6 + ...
                        A5*wavLenInUM.^-8 + A6*wavLenInUM.^4 + ...
                        A7*wavLenInUM.^6;
                case 1
                    refractiveIndex=(0.5.*(-((8.*a5)./wavLenInUM.^9)-(6.*a4)./wavLenInUM.^7-...
                        (4.*a3)./wavLenInUM.^5-(2.*a2)./wavLenInUM.^3+2.*a1.*wavLenInUM+...
                        4.*a6.*wavLenInUM.^3+6.*a7.*wavLenInUM.^5))./(a0+a5./wavLenInUM.^8+...
                        a4./wavLenInUM.^6+a3./wavLenInUM.^4+a2./wavLenInUM.^2+a1.*wavLenInUM.^2+...
                        a6.*wavLenInUM.^4+a7.*wavLenInUM.^6).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((8.*a5)./wavLenInUM.^9)-(6.*a4)./wavLenInUM.^7-...
                        (4.*a3)./wavLenInUM.^5-(2.*a2)./wavLenInUM.^3+2.*a1.*wavLenInUM+...
                        4.*a6.*wavLenInUM.^3+6.*a7.*wavLenInUM.^5).^2)./(a0+a5./wavLenInUM.^8+...
                        a4./wavLenInUM.^6+a3./wavLenInUM.^4+a2./wavLenInUM.^2+a1.*wavLenInUM.^2+...
                        a6.*wavLenInUM.^4+a7.*wavLenInUM.^6).^1.5)+(0.5.*(2.*a1+(72.*a5)./wavLenInUM.^10+...
                        (42.*a4)./wavLenInUM.^8+(20.*a3)./wavLenInUM.^6+(6.*a2)./wavLenInUM.^4+...
                        12.*a6.*wavLenInUM.^2+30.*a7.*wavLenInUM.^4))./(a0+a5./wavLenInUM.^8+...
                        a4./wavLenInUM.^6+a3./wavLenInUM.^4+a2./wavLenInUM.^2+a1.*wavLenInUM.^2+...
                        a6.*wavLenInUM.^4+a7.*wavLenInUM.^6).^0.5;
                    
            end
        case  lower('Extended3')
            A0 = coefficientData(1);
            A1 = coefficientData(2);
            A2 = coefficientData(3);
            A3 = coefficientData(4);
            A4 = coefficientData(5);
            A5 = coefficientData(6);
            A6 = coefficientData(7);
            A7 = coefficientData(8);
            A8 = coefficientData(9);
            
            switch derivativeOrder
                case 0
                    refractiveIndex =  A0 + A1*wavLenInUM.^2 + A2*wavLenInUM.^4 +...
                        A3*wavLenInUM.^-2 + A4*wavLenInUM.^-4 + ...
                        A5*wavLenInUM.^-6 + A6*wavLenInUM.^-8 + ...
                        A7*wavLenInUM.^-10 + A8*wavLenInUM.^-12;
                case 1
                    refractiveIndex=(0.5.*(-((12.*a8)./wavLenInUM.^13)-(10.*a7)./wavLenInUM.^11-...
                        (8.*a6)./wavLenInUM.^9-(6.*a5)./wavLenInUM.^7-(4.*a4)./wavLenInUM.^5-...
                        (2.*a3)./wavLenInUM.^3+2.*a1.*wavLenInUM+4.*a2.*wavLenInUM.^3))./(a0+a8./wavLenInUM.^12+...
                        a7./wavLenInUM.^10+a6./wavLenInUM.^8+a5./wavLenInUM.^6+a4./wavLenInUM.^4+a3./wavLenInUM.^2+...
                        a1.*wavLenInUM.^2+a2.*wavLenInUM.^4).^0.5;
                    
                case 2
                    refractiveIndex=-((0.25.*(-((12.*a8)./wavLenInUM.^13)-(10.*a7)./wavLenInUM.^11-...
                        (8.*a6)./wavLenInUM.^9-(6.*a5)./wavLenInUM.^7-(4.*a4)./wavLenInUM.^5-...
                        (2.*a3)./wavLenInUM.^3+2.*a1.*wavLenInUM+4.*a2.*wavLenInUM.^3).^2)./(a0+a8./wavLenInUM.^12+...
                        a7./wavLenInUM.^10+a6./wavLenInUM.^8+a5./wavLenInUM.^6+a4./wavLenInUM.^4+a3./wavLenInUM.^2+...
                        a1.*wavLenInUM.^2+a2.*wavLenInUM.^4).^1.5)+(0.5.*(2.*a1+(156.*a8)./wavLenInUM.^14+...
                        (110.*a7)./wavLenInUM.^12+(72.*a6)./wavLenInUM.^10+(42.*a5)./wavLenInUM.^8+...
                        (20.*a4)./wavLenInUM.^6+(6.*a3)./wavLenInUM.^4+12.*a2.*wavLenInUM.^2))./(a0+...
                        a8./wavLenInUM.^12+a7./wavLenInUM.^10+a6./wavLenInUM.^8+a5./wavLenInUM.^6+...
                        a4./wavLenInUM.^4+a3./wavLenInUM.^2+a1.*wavLenInUM.^2+a2.*wavLenInUM.^4).^0.5;
            end
    end
    % Change all back to the SI Units
    switch derivativeOrder
        case 0
            % Do nothing as refractive index has no unit.
        case 1
            % The 1st derivative is in 1/um
            refractiveIndex = refractiveIndex*10^6; % In 1/m
        case 2
            % The 2nd derivative is in 1/(um)^2
            refractiveIndex = refractiveIndex*10^12; % In 1/m^2
    end

end

