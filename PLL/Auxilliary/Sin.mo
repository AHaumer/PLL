within PLL.Auxilliary;
block Sin "Output the sine of the input"
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
  y = internalAmplitude*Modelica.Math.sin(u);
  connect(amplitude, internalAmplitude)
    annotation (Line(points={{0,-120},{0,-80}}, color={0,0,127}));
  connect(const.y, internalAmplitude)
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
        Line(
          points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
              {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},
              {-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},
              {29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{
              57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}},
          smooth=Smooth.Bezier),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{12,84},{84,36}},
          textColor={192,192,192},
          textString="sin")}),
    Documentation(info="<html>
<p>
This blocks computes the output <strong>y</strong> as <strong>sine</strong> of the input <strong>u</strong>.
</p>
<p>
The amplitude of the cosine is given either by a parameter or ba yn optopnal input.
</p>
</html>"));
end Sin;
