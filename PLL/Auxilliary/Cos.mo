within PLL.Auxilliary;
block Cos "Output the cosine of the input"
  extends Modelica.Blocks.Interfaces.SISO(u(unit="rad"));
  parameter Boolean useAmplitudeInput=false;
  parameter Real Amplitude=1 "Amplitude of signal"
    annotation(Dialog(enable=not useAmplitudeInput));
  Modelica.Blocks.Interfaces.RealInput amplitude if useAmplitudeInput
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
protected
  Modelica.Blocks.Sources.Constant const(k=Amplitude) if not useAmplitudeInput
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Interfaces.RealInput internalAmplitude annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=90,
        origin={0,-80}), iconTransformation(
        extent={{-2,-2},{2,2}},
        rotation=90,
        origin={0,-80})));
equation
  y = internalAmplitude*Modelica.Math.cos(u);
  connect(amplitude,internalAmplitude)
    annotation (Line(points={{0,-120},{0,-80}}, color={0,0,127}));
  connect(const.y,internalAmplitude)
    annotation (Line(points={{-19,-80},{0,-80}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},
              {-48.6,26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},
              {-4.42,-78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},
              {24.5,-45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{
              69.5,73.4},{75.2,78.6},{80,80}},
          smooth=Smooth.Bezier),
        Text(
          extent={{-36,82},{36,34}},
          textColor={192,192,192},
          textString="cos")}),
    Documentation(info="<html>
<p>
This blocks computes the output <strong>y</strong> as <strong>cos</strong> of the input <strong>u</strong>.
</p>
<p>
The amplitude of the cosine is given either by a parameter or ba yn optopnal input.
</p>
</html>"));
end Cos;
