within PLL.Components;
block Enhanced1phasePLL "Enhanced single phase phase locked loop"
  extends Modelica.Blocks.Interfaces.SIMO(final nout=3);
  extends Interfaces.w_theta;
  parameter Real A0=1 "Rated amplitude of input";
  parameter SI.Frequency f0=50 "Rated frequency";
  parameter Real zeta1(min=0.25, max=0.75)=0.5 "First damping ratio";
  parameter Real zeta2(min=1, max=2)=1 "Second damping ratio";
  parameter Real kp=2*zeta1*2*pi*f0 "Proportional gain";
  parameter Real ki=kp^2/(8*zeta2^2) "Integral gain";
  parameter Real ka=kp "Amplitude integral gain";
  parameter Real epsilon=0.001 "Avoid division by 0";
  parameter Real lamda(min=0, max=20)=0 "Factor for adaptive integrator";
  Real e=feedback.y "Control error";
  Real A=addOffset1.y "Estimated amplitude";
  Basic1phasePLL base1phasePLL(
    A0=A0,
    f0=f0,
    kp=kp,
    ki=ki,
    useAdaption=true)
           annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-90,10},{-70,-10}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=ka,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Auxilliary.AddOffset addOffset1(offset=A0)
    annotation (Placement(transformation(extent={{-10,70},{10,50}})));
  Modelica.Blocks.Math.Product product2
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-40,-40})));
  Auxilliary.AddOffset
                 addOffset2(offset=epsilon*A0)
                      annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-60,-20})));
  Modelica.Blocks.Sources.RealExpression adaption(y=1/(1 + lamda*abs(e)/(abs(A)
         + epsilon*A0)))
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
equation
  connect(u, feedback.u1)
    annotation (Line(points={{-120,0},{-88,0}}, color={0,0,127}));
  connect(feedback.y, division.u1) annotation (Line(points={{-71,0},{-60,0},{
          -60,6},{-52,6}},
                       color={0,0,127}));
  connect(product1.y, integrator.u)
    annotation (Line(points={{-49,60},{-42,60}}, color={0,0,127}));
  connect(addOffset1.y, product2.u1) annotation (Line(points={{9,60},{20,60},{
          20,66},{38,66}}, color={0,0,127}));
  connect(product2.y, feedback.u2) annotation (Line(points={{61,60},{70,60},{70,
          30},{-80,30},{-80,8}}, color={0,0,127}));
  connect(feedback.y, product1.u1) annotation (Line(points={{-71,0},{-60,0},{-60,
          20},{-90,20},{-90,66},{-72,66}}, color={0,0,127}));
  connect(base1phasePLL.y[1], product2.u2) annotation (Line(points={{11,
          -0.333333},{80,-0.333333},{80,40},{30,40},{30,54},{38,54}},
                                                           color={0,0,127}));
  connect(division.y, base1phasePLL.u)
    annotation (Line(points={{-29,0},{-12,0}},color={0,0,127}));
  connect(addOffset1.y, abs1.u) annotation (Line(points={{9,60},{20,60},{20,-40},
          {-28,-40}},color={0,0,127}));
  connect(addOffset2.y, division.u2) annotation (Line(points={{-60,-11},{-60,-6},
          {-52,-6}},          color={0,0,127}));
  connect(adaption.y, base1phasePLL.adaption) annotation (Line(points={{-29,20},
          {-20,20},{-20,8},{-12,8}}, color={0,0,127}));
  connect(integrator.y, addOffset1.u)
    annotation (Line(points={{-19,60},{-8,60}}, color={0,0,127}));
  connect(addOffset2.u, abs1.y)
    annotation (Line(points={{-60,-28},{-60,-40},{-51,-40}},
                                                   color={0,0,127}));
  connect(product2.y, y[3]) annotation (Line(points={{61,60},{84,60},{84,
          3.33333},{110,3.33333}}, color={0,0,127}));
  connect(base1phasePLL.y[1], y[1]) annotation (Line(points={{11,-0.333333},{80,
          -0.333333},{80,-3.33333},{110,-3.33333}}, color={0,0,127}));
  connect(base1phasePLL.y[2], y[2])
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(base1phasePLL.y[1], product1.u2) annotation (Line(points={{11,
          -0.333333},{80,-0.333333},{80,40},{-80,40},{-80,54},{-72,54}}, color=
          {0,0,127}));
  connect(base1phasePLL.w, w) annotation (Line(points={{11,6},{90,6},{90,60},{
          110,60}}, color={0,0,127}));
  connect(base1phasePLL.theta, theta) annotation (Line(points={{11,-6},{80,-6},
          {80,-60},{110,-60}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is the enhanced version of the single phase PLL, based on the <a href=\"modelica://PLL.Components.Basic1phasePLL\">basic version of the single phase PLL</a>, 
avoiding the mentioned double-frequency ripple on the estimated frequency.
</p>
<p>
The output <code>y[1]</code> is a cosine signal in phase with the input <code>u</code>, 
the output <code>y[2]</code> is a sine signal 90&deg; phase shifted to <code>y[1]</code>. 
The output <code>y[3]</code> is a cosine signal in phase with the input <code>u</code> and the estimated amplitude, i.e. the fundamental harmonic.
</p>
</html>"));
end Enhanced1phasePLL;
