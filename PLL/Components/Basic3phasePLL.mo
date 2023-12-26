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
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,30})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{28,70},{48,90}})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,50})));
  Auxilliary.AddOffset addOffset(offset=epsilon*A0) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,50})));
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
    annotation (Placement(transformation(extent={{0,-2},{20,18}})));
  Modelica.Blocks.Math.Cos cos
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1/(1 + lamda*abs(uq)/
        (abs(ud) + epsilon*A0)))
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
equation
  connect(toSpacePhasor.y, rotator.u)
    annotation (Line(points={{-90,41},{-90,80},{-32,80}},
                                                 color={0,0,127}));
  connect(u, toSpacePhasor.u) annotation (Line(points={{-120,0},{-90,0},{-90,18}},
                     color={0,0,127}));
  connect(abs1.y, addOffset.u) annotation (Line(points={{0,39},{0,30},{20,30},{
          20,42}},  color={0,0,127}));
  connect(addOffset.y, division.u2)
    annotation (Line(points={{20,59},{20,74},{26,74}}, color={0,0,127}));
  connect(division.y, integrator1.u) annotation (Line(points={{49,80},{60,80},{
          60,-30},{-98,-30},{-98,-60},{-92,-60}},
                                               color={0,0,127}));
  connect(addOffset1.y, add2.u1)
    annotation (Line(points={{-1,-60},{22,-60}},  color={0,0,127}));
  connect(division.y, gain.u) annotation (Line(points={{49,80},{60,80},{60,-30},
          {-98,-30},{-98,-80},{-22,-80}}, color={0,0,127}));
  connect(gain.y, add2.u2)
    annotation (Line(points={{1,-80},{30,-80},{30,-68}},  color={0,0,127}));
  connect(add2.y, integrator2.u)
    annotation (Line(points={{39,-60},{48,-60}}, color={0,0,127}));
  connect(integrator2.y, phi)
    annotation (Line(points={{71,-60},{110,-60}}, color={0,0,127}));
  connect(integrator2.y, rotator.angle) annotation (Line(points={{71,-60},{80,
          -60},{80,-24},{-20,-24},{-20,68}},
                                      color={0,0,127}));
  connect(addOffset1.y, w) annotation (Line(points={{-1,-60},{10,-60},{10,-40},{
          90,-40},{90,60},{110,60}},
                                  color={0,0,127}));
  connect(integrator2.y, sin.u) annotation (Line(points={{71,-60},{80,-60},{80,
          -24},{-20,-24},{-20,8},{-2,8}},                color={0,0,127}));
  connect(integrator2.y, cos.u) annotation (Line(points={{71,-60},{80,-60},{80,
          -24},{-20,-24},{-20,-10},{-2,-10}},
                                         color={0,0,127}));
  connect(integrator1.y, product1.u2) annotation (Line(points={{-69,-60},{-60,-60},
          {-60,-66},{-52,-66}}, color={0,0,127}));
  connect(realExpression.y, product1.u1) annotation (Line(points={{-69,-40},{-60,
          -40},{-60,-54},{-52,-54}}, color={0,0,127}));
  connect(product1.y, addOffset1.u)
    annotation (Line(points={{-29,-60},{-18,-60}}, color={0,0,127}));
  connect(rotator.y[2], division.u1) annotation (Line(points={{-9,80},{20,80},{
          20,86},{26,86}},  color={0,0,127}));
  connect(rotator.y[1], abs1.u)
    annotation (Line(points={{-9,80},{0,80},{0,62}},      color={0,0,127}));
  connect(cos.y, y[1]) annotation (Line(points={{21,-10},{70,-10},{70,-2.5},{
          110,-2.5}}, color={0,0,127}));
  connect(sin.y, y[2]) annotation (Line(points={{21,8},{70,8},{70,2.5},{110,2.5}},
        color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
The the basic version of the three phase PLL performs a Clarke and Park transformation on the inputs <code>u[1..3]</code>, 
using the angle &theta; determined by the control loop.  
The d- and the q-component are divided to obtain an amplitude of 1.
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
