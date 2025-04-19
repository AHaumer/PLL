within PLL.Components;
block SimpledqPLL "Angle tracking observer"
  extends Modelica.Blocks.Interfaces.MIMOs(final n=2);
  extends Interfaces.w_theta;
  parameter Modelica.Units.SI.Time Ti=1e-6 "Integral time constant of controller";
  parameter Modelica.Units.SI.Angle phi0=0 "Initial angle";
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator
    annotation (Placement(transformation(extent={{-50,10},{-30,-10}})));
  Modelica.Blocks.Continuous.Integrator integralController(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=phi0)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Math.Gain gain(k=1/Ti)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(integralController.y,rotator. angle) annotation (Line(points={{51,0},{
          60,0},{60,20},{-40,20},{-40,12}}, color={0,0,127}));
  connect(gain.y,integralController. u)
    annotation (Line(points={{11,0},{28,0}}, color={0,0,127}));
  connect(u, rotator.u)
    annotation (Line(points={{-120,0},{-52,0}}, color={0,0,127}));
  connect(gain.y, w) annotation (Line(points={{11,0},{20,0},{20,60},{110,60}},
        color={0,0,127}));
  connect(integralController.y, theta) annotation (Line(points={{51,0},{60,0},{
          60,-60},{110,-60}},
                           color={0,0,127}));
  connect(rotator.y, y) annotation (Line(points={{-29,0},{-20,0},{-20,-20},{80,
          -20},{80,0},{110,0}}, color={0,0,127}));
  connect(rotator.y[2], gain.u)
    annotation (Line(points={{-29,-0.25},{-48,0},{-12,0}}, color={0,0,127}));
  annotation (
    Icon(graphics={
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Line(points={{-72,20},{-72,20},{-40,60},{-40,-40},{40,60},{40,-60},{56,-40}}),
        Line(
          points={{56,80},{-72,-80}},
          color={0,0,127},
          thickness=0.5)}),
      Documentation(info="<html>
<p>
This block calculates angle and angular velocity of the input <code>u[2]</code> in &alpha;,&beta;-frame.
</p>
<p>
The used calculation method is based on an angle tracking observer as common in electrical
engineering. This implementation is very robust. It determines the angle of the input space phasor.
</p>
<p>
The angle of a complex space phasor is controlled in such a way that its imaginary part is equal to zero. 
The controlled angle&nbsp;<code>theta</code> is the unwrapped continuous angle. 
The output&nbsp;<code>theta</code> approximates the desired angle by a first order system
which time constant is the integral time constant of the controller:
</p>
<blockquote><pre>
Im(e<sup><code>j*(u-y)</code></sup>) = sin(u - y)
</pre></blockquote>
<p>
This expression can be approximated for small differences by
<code>(u - y)</code>.
Using an integral controller, the transfer function of the closed loop can, thus, be
determined as:
<code>y&nbsp;=&nbsp;u&nbsp;/&nbsp;(1&nbsp;+&nbsp;s*Ti)</code>.
</p>
<p>
The derivative of the output&nbsp;<code>theta</code> is the angular velocity&nbsp;<code>w</code>,
provided as an output signal as well.
</p>
</html>"));
end SimpledqPLL;
