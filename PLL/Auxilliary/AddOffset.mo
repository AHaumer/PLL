within PLL.Auxilliary;
block AddOffset "Output sum of input and offset"
  parameter Real gain=1;
  parameter Real offset=0;

  Modelica.Blocks.Interfaces.RealInput u "Commanded input"
    annotation (Placement(transformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

equation
  y = gain*u + offset;
  annotation (
    Documentation(info="<html>
<p>
This block multiplies the input <code>u</code> with the <code>gain</code> and adds the <code>offset</code>.
</p>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          lineColor={0,0,127},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          extent={{-20,-20},{20,20}}),
        Line(points={{-60,0},{-20,0}}, color={0,0,127}),
        Line(points={{20,0},{80,0}}, color={0,0,127}),
        Text(
          textColor={0,0,255},
          extent={{-150,40},{150,80}},
          textString="%name"),
        Text(
          extent={{-20,20},{20,-20}},
          textColor={28,108,200},
          textString="+",
          textStyle={TextStyle.Bold}),
        Text(
          extent={{-100,-40},{100,-70}},
          textColor={28,108,200},
          textString="%offset + %gain*u")}));
end AddOffset;
