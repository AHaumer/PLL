within PLL.Components;
block Basic3phasePLL "Basic version of three phase phase-locked loop"
  extends Modelica.Blocks.Interfaces.MIMO(final nin=2, final nout=2);
  final parameter Integer m=3 "Number of phases";
  parameter Real A0=1 "Rated amplitude of input";
  parameter SI.Frequency f0=50 "Rated frequency";
  parameter SI.AngularVelocity wn=0.25*2*pi*f0 "Natural angular velocity";
  parameter Real zeta(min=0.5, max=1)=0.5 "Damping ratio";
  parameter Real kp=2*zeta*wn "Proportional gain";
  parameter Real ki=wn^2 "Integral gain";
  parameter Real epsilon=0.001 "Avoid division by 0";
  parameter Real lamda(min=0, max=20)=0 "Factor for adaptive integrator";
  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad", start=0)
    "Estimated angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator
    annotation (Placement(transformation(extent={{-40,-70},{-20,-90}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{20,-70},{40,-90}})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-60})));
  Auxilliary.AddOffset addOffset(offset=epsilon*A0) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,-60})));
  Modelica.Blocks.Continuous.Integrator integrator1(k=ki, initType=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Auxilliary.AddOffset addOffset1(offset=2*pi*f0)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Math.Gain gain(k=kp)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Auxilliary.Add add2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,60})));
  Modelica.Blocks.Continuous.Integrator integrator2(k=1, initType=Modelica.Blocks.Types.Init.NoInit)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,40})));
  Modelica.Blocks.Math.Sin sin
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Math.Cos cos
    annotation (Placement(transformation(extent={{0,0},{20,-20}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1/(1 + lamda*abs(udq[
        2])/(abs(udq[1]) + epsilon*A0)))
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Interfaces.RealOutput udq[2] "ud, uq" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
equation
  connect(gain.y, add2.u2)
    annotation (Line(points={{11,40},{40,40},{40,52}},    color={0,0,127}));
  connect(add2.y, integrator2.u)
    annotation (Line(points={{49,60},{80,60},{80,52}},
                                                 color={0,0,127}));
  connect(integrator1.y, product1.u2) annotation (Line(points={{-59,60},{-50,60},
          {-50,54},{-42,54}},   color={0,0,127}));
  connect(realExpression.y, product1.u1) annotation (Line(points={{-59,80},{-50,
          80},{-50,66},{-42,66}},    color={0,0,127}));
  connect(product1.y, addOffset1.u)
    annotation (Line(points={{-19,60},{-8,60}},    color={0,0,127}));
  connect(rotator.y[2], division.u1) annotation (Line(points={{-19,-80},{0,-80},
          {0,-86},{18,-86}},color={0,0,127}));
  connect(cos.y, y[1]) annotation (Line(points={{21,-10},{70,-10},{70,-2.5},{
          110,-2.5}}, color={0,0,127}));
  connect(sin.y, y[2]) annotation (Line(points={{21,10},{70,10},{70,2.5},{110,2.5}},
        color={0,0,127}));
  connect(rotator.y[1], abs1.u)
    annotation (Line(points={{-19,-80},{-10,-80},{-10,-72}}, color={0,0,127}));
  connect(abs1.y, addOffset.u) annotation (Line(points={{-10,-49},{-10,-40},{10,
          -40},{10,-52}}, color={0,0,127}));
  connect(addOffset.y, division.u2)
    annotation (Line(points={{10,-69},{10,-74},{18,-74}}, color={0,0,127}));
  connect(addOffset1.y, add2.u1)
    annotation (Line(points={{9,60},{32,60}}, color={0,0,127}));
  connect(addOffset1.y, w) annotation (Line(points={{9,60},{20,60},{20,80},{90,80},
          {90,60},{110,60}}, color={0,0,127}));
  connect(integrator2.y, phi)
    annotation (Line(points={{80,29},{80,-60},{110,-60}}, color={0,0,127}));
  connect(u, rotator.u) annotation (Line(points={{-120,0},{-90,0},{-90,-80},{-42,
          -80}}, color={0,0,127}));
  connect(division.y, gain.u) annotation (Line(points={{41,-80},{50,-80},{50,-30},
          {-80,-30},{-80,40},{-12,40}}, color={0,0,127}));
  connect(division.y, integrator1.u) annotation (Line(points={{41,-80},{50,-80},
          {50,-30},{-80,-30},{-80,40},{-90,40},{-90,60},{-82,60}}, color={0,0,127}));
  connect(integrator2.y, rotator.angle) annotation (Line(points={{80,29},{80,24},
          {-30,24},{-30,-68}}, color={0,0,127}));
  connect(integrator2.y, sin.u) annotation (Line(points={{80,29},{80,24},{-10,24},
          {-10,10},{-2,10}}, color={0,0,127}));
  connect(integrator2.y, cos.u) annotation (Line(points={{80,29},{80,24},{-10,24},
          {-10,-10},{-2,-10}}, color={0,0,127}));
  connect(rotator.y, udq)
    annotation (Line(points={{-19,-80},{0,-80},{0,-110}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
The the basic version of the three phase PLL assumes that a Clarke transformation is performed, then feeding the &alpha;- &beta;-component to this block. 
Here a Park transformation on the inputs <code>u[1..2]</code> is applied, using the angle &theta; determined by the control loop.  
The d- and the q-component are divided by the estimated amplitude to obtain an amplitude of 1.
Subsequnetly, the q-current is controlled to become 0, ie. determining the desired angle &theta; 
as well as the frequency resp. angular velocity &omega; = 2 &pi; f = <code>w</code>.
</p>
<p>
The output <code>y[1]</code> is a cosine signal in phase with the input <code>u</code>, 
the output <code>y[2]</code> is a sine signal 90&deg; phase shifted to <code>y[1]</code>. 
Result of the Clarke - Park - transformation can be inspected with <code>u<sub>0</sub></code>, <code>u<sub>d</sub></code> and <code>u<sub>q</sub></code>.
</p>
<p>
Problems: especially a double-frequency ripple on the estimated frequency under distorted conditions, 
i.e. when the input signals contain not only a positive sequence but also a negative sequence and / or zero component. 
For symmterical components, see <a href=\"modelica://PLL.UsersGuide.References\">[Fortescue1918]</a>.
</p>
</html>"));
end Basic3phasePLL;
