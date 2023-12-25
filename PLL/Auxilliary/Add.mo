within PLL.Auxilliary;
block Add "Output sum of the two inputs"
  parameter Real k1=1;
  parameter Real k2=1;

  Modelica.Blocks.Interfaces.RealInput u1 "Commanded input"
    annotation (Placement(transformation(extent={{-100,-20},{-60,20}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Feedback input" annotation (
      Placement(transformation(
        origin={0,-80},
        extent={{-20,-20},{20,20}},
        rotation=90)));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

equation
  y = k1*u1 + k2*u2;
  annotation (
    Documentation(info="<html>
<p>
This block adds both inputs with a graphical layout as the <a href=\"modelica://Modelica.Blocks.Math.Feedback\">standard feedback block</a>.
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
        Line(points={{0,-20},{0,-60}}, color={0,0,127}),
        Text(
          textColor={0,0,255},
          extent={{-150,40},{150,80}},
          textString="%name"),
        Text(
          extent={{-100,-20},{-40,-60}},
          textColor={28,108,200},
          textString="%k1"),
        Text(
          extent={{20,-60},{80,-100}},
          textColor={28,108,200},
          textString="%k2"),
        Text(
          extent={{-20,20},{20,-20}},
          textColor={28,108,200},
          textString="+",
          textStyle={TextStyle.Bold})}));
end Add;
