within PLL.Components;
block Enhanced1phasePLL "Enhanced single phase phase locked loop"
  extends Modelica.Blocks.Interfaces.SIMO(final nout=3);
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
  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad", start=0)
    "Estimated angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Basic1phasePLL base1phasePLL(
    A0=A0,
    f0=f0,
    kp=kp,
    ki=ki,
    useAdaption=true)
           annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-90,10},{-70,-10}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
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
        origin={0,-30})));
  Auxilliary.AddOffset
                 addOffset2(offset=epsilon*A0)
                      annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,-30})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1/(1 + lamda*abs(e)/(
        abs(A) + epsilon*A0)))
    annotation (Placement(transformation(extent={{20,-2},{40,18}})));
equation
  connect(u, feedback.u1)
    annotation (Line(points={{-120,0},{-88,0}}, color={0,0,127}));
  connect(feedback.y, division.u1) annotation (Line(points={{-71,0},{-60,0},{-60,
          6},{-42,6}}, color={0,0,127}));
  connect(product1.y, integrator.u)
    annotation (Line(points={{-49,60},{-42,60}}, color={0,0,127}));
  connect(addOffset1.y, product2.u1) annotation (Line(points={{9,60},{20,60},{
          20,66},{38,66}}, color={0,0,127}));
  connect(base1phasePLL.w, w) annotation (Line(points={{71,6},{90,6},{90,60},{110,
          60}}, color={0,0,127}));
  connect(base1phasePLL.phi, phi) annotation (Line(points={{71,-6},{90,-6},{90,-60},
          {110,-60}}, color={0,0,127}));
  connect(product2.y, feedback.u2) annotation (Line(points={{61,60},{70,60},{70,
          30},{-80,30},{-80,8}}, color={0,0,127}));
  connect(feedback.y, product1.u1) annotation (Line(points={{-71,0},{-60,0},{-60,
          20},{-90,20},{-90,66},{-72,66}}, color={0,0,127}));
  connect(base1phasePLL.y[1], product2.u2) annotation (Line(points={{71,-0.333333},
          {80,-0.333333},{80,40},{30,40},{30,54},{38,54}}, color={0,0,127}));
  connect(base1phasePLL.y[1], product1.u2) annotation (Line(points={{71,-0.333333},
          {80,-0.333333},{80,40},{-80,40},{-80,54},{-72,54}},
                                                         color={0,0,127}));
  connect(division.y, base1phasePLL.u)
    annotation (Line(points={{-19,0},{48,0}}, color={0,0,127}));
  connect(addOffset1.y, abs1.u) annotation (Line(points={{9,60},{20,60},{20,-30},
          {12,-30}}, color={0,0,127}));
  connect(addOffset2.y, division.u2) annotation (Line(points={{-39,-30},{-52,-30},
          {-52,-6},{-42,-6}}, color={0,0,127}));
  connect(product2.y, y[3]) annotation (Line(points={{61,60},{80,60},{80,3.33333},
          {110,3.33333}}, color={0,0,127}));
  connect(base1phasePLL.y, y[1:2])
    annotation (Line(points={{71,0},{110,0}}, color={0,0,127}));
  connect(realExpression.y, base1phasePLL.adaption)
    annotation (Line(points={{41,8},{48,8}}, color={0,0,127}));
  connect(integrator.y, addOffset1.u)
    annotation (Line(points={{-19,60},{-8,60}}, color={0,0,127}));
  connect(addOffset2.u, abs1.y)
    annotation (Line(points={{-22,-30},{-11,-30}}, color={0,0,127}));
end Enhanced1phasePLL;
