within PLL.Interfaces;
partial block w_theta "Signal output w and theta"
  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput theta(unit="rad", start=0)
    "Estimated angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end w_theta;
