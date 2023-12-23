within PLL.Components;
block Basic3phasePLL "Basic version of three phase phase-locked loop"
  extends Modelica.Blocks.Interfaces.MIMO(final nin=m, final nout=2);
  final parameter Integer m=3 "Number of phases";
  parameter Real A0=1 "Rated amplitude of input";
  parameter SI.Frequency f0=50 "Rated frequency";
  parameter SI.AngularVelocity wn=0.25*2*pi*f0 "Natural angular velocity";
  parameter Real zeta(min=0.5, max=1)=0.5 "Damping ratio";
  parameter Real kp=2*zeta*wn "Proportional gain";
  parameter Real ki=wn^2 "Integral gain";
  parameter Real epsilon=0.001 "Avoid division by 0";
  parameter Real lamda(min=0, max=20)=0 "Factor for adaptive integrator";
  Real ud=rotator.y[1] "d-component of input signal";
  Real uq=rotator.y[2] "q-component of input signal";
  Real u0=toSpacePhasor.zero "0-component of input signal";
  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad", start=0)
    "Estimated angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasor(m=m)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-10,50})));
  Auxilliary.AddOffset addOffset(offset=epsilon*A0) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,50})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=ki, initType=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Auxilliary.AddOffset addOffset1(offset=2*pi*f0)
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Math.Gain gain(k=kp)
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Auxilliary.Add add2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-60})));
  Modelica.Blocks.Continuous.Integrator integrator2(k=1, initType=Modelica.Blocks.Types.Init.NoInit)
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Modelica.Blocks.Math.Sin sin
    annotation (Placement(transformation(extent={{-8,-2},{12,18}})));
  Modelica.Blocks.Math.Cos cos
    annotation (Placement(transformation(extent={{-8,-20},{12,0}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1/(1 + lamda*abs(uq)/
        (abs(ud) + epsilon*A0)))
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
equation
  connect(toSpacePhasor.y, rotator.u)
    annotation (Line(points={{-59,80},{-42,80}}, color={0,0,127}));
  connect(u, toSpacePhasor.u) annotation (Line(points={{-120,0},{-90,0},{-90,80},
          {-82,80}}, color={0,0,127}));
  connect(abs1.y, addOffset.u) annotation (Line(points={{-10,39},{-10,30},{10,30},
          {10,42}}, color={0,0,127}));
  connect(addOffset.y, division.u2)
    annotation (Line(points={{10,59},{10,74},{18,74}}, color={0,0,127}));
  connect(division.y, integrator1.u) annotation (Line(points={{41,80},{52,80},{52,
          -30},{-98,-30},{-98,-60},{-92,-60}}, color={0,0,127}));
  connect(addOffset1.y, add2.u1)
    annotation (Line(points={{-1,-60},{22,-60}},  color={0,0,127}));
  connect(division.y, gain.u) annotation (Line(points={{41,80},{52,80},{52,-30},
          {-98,-30},{-98,-80},{-22,-80}}, color={0,0,127}));
  connect(gain.y, add2.u2)
    annotation (Line(points={{1,-80},{30,-80},{30,-68}},  color={0,0,127}));
  connect(add2.y, integrator2.u)
    annotation (Line(points={{39,-60},{48,-60}}, color={0,0,127}));
  connect(integrator2.y, phi)
    annotation (Line(points={{71,-60},{110,-60}}, color={0,0,127}));
  connect(integrator2.y, rotator.angle) annotation (Line(points={{71,-60},{80,-60},
          {80,20},{-30,20},{-30,68}}, color={0,0,127}));
  connect(addOffset1.y, w) annotation (Line(points={{-1,-60},{10,-60},{10,-40},{
          90,-40},{90,60},{110,60}},
                                  color={0,0,127}));
  connect(integrator2.y, sin.u) annotation (Line(points={{71,-60},{80,-60},{80,
          20},{-30,20},{-30,8},{-10,8}},                 color={0,0,127}));
  connect(integrator2.y, cos.u) annotation (Line(points={{71,-60},{80,-60},{80,
          20},{-30,20},{-30,-10},{-10,-10}},
                                         color={0,0,127}));
  connect(integrator1.y, product1.u2) annotation (Line(points={{-69,-60},{-60,-60},
          {-60,-66},{-52,-66}}, color={0,0,127}));
  connect(realExpression.y, product1.u1) annotation (Line(points={{-69,-40},{-60,
          -40},{-60,-54},{-52,-54}}, color={0,0,127}));
  connect(product1.y, addOffset1.u)
    annotation (Line(points={{-29,-60},{-18,-60}}, color={0,0,127}));
  connect(rotator.y[2], division.u1) annotation (Line(points={{-19,80},{10,80},
          {10,86},{18,86}}, color={0,0,127}));
  connect(rotator.y[1], abs1.u)
    annotation (Line(points={{-19,80},{-10,80},{-10,62}}, color={0,0,127}));
  connect(cos.y, y[1]) annotation (Line(points={{13,-10},{70,-10},{70,-2.5},{
          110,-2.5}}, color={0,0,127}));
  connect(sin.y, y[2]) annotation (Line(points={{13,8},{70,8},{70,2.5},{110,2.5}},
        color={0,0,127}));
end Basic3phasePLL;