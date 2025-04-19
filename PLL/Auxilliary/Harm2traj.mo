within PLL.Auxilliary;
block Harm2traj "Determine trajectory from harmonc (rms and arg)"
  extends Modelica.Blocks.Interfaces.SO;
  parameter SI.Frequency f=50 "Rated frequency";
  Modelica.Blocks.Interfaces.RealInput u_rms
    "Root mean square of polar representation" annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}), iconTransformation(extent
          ={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput u_arg(unit="rad")
    "Angle of polar representation" annotation (Placement(transformation(extent
          ={{-140,-80},{-100,-40}}), iconTransformation(extent={{-140,-80},{-100,
            -40}})));
equation
//sqrt(2)*u_rms*
  y = cos(2*pi*f*time - u_arg);
  annotation (Icon(graphics={
        Text(
          extent={{-100,100},{-20,60}},
          textString="rms"),
        Text(
          extent={{-100,-60},{-20,-100}},
          textString="arg"),
        Text(
          extent={{-80,-20},{80,-60}},
          textString="f=%f")}));
end Harm2traj;
