 function [PolEllipseBeforeCoating,PolEllipseAfterCoating] = ...
         getPolarizationEllipseParameters(RayTraceResult,surfIndex)
     % getPolarizationEllipseParameters: Returns polarization ellipse
     % parameters of the ray before and after the coating of a surf
    PolEllipseBeforeCoating = computeEllipseParameters...
        ( RayTraceResult.PolarizationVectorBeforeCoating(surfIndex,:));
    PolEllipseAfterCoating = computeEllipseParameters...
        ( RayTraceResult.PolarizationVectorAfterCoating(surfIndex,:));
 end