within PLL.Sources;
block SinglephaseSource "Basic single phase signal source"
  extends Modelica.Blocks.Interfaces.SO;
  parameter Real A0=1 "Rated amplitude";
  parameter SI.Frequency f0=50 "Rated frequency";
  parameter SI.Time t_Phi=0.2 "Phase disturbance";
  parameter SI.Angle dPhi=15*pi/180 "Phase disturbance";
  parameter SI.Time t_f=0.5 "Frequency disturbance";
  parameter SI.Frequency df=1 "Frequency disturbance";
  parameter SI.Time t_A=0.8 "Amplitude disturbance";
  parameter Real dA=0.5 "Amplitude disturbance";
  Real A=step_amplitude.y "Amplitude";
  Modelica.Blocks.Sources.Step step_f(
    height=df,
    offset=f0,
    startTime=t_f)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=2*pi,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Modelica.Blocks.Sources.Step step_phase(
    height=dPhi,
    offset=0,
    startTime=t_Phi)
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Cos cos
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Sources.Step step_amplitude(
    height=dA,
    offset=A0,
    startTime=t_A)
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad", start=0) "Angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Math.Gain gain(k=2*pi)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
equation
  connect(step_f.y, integrator.u)
    annotation (Line(points={{-69,0},{-52,0}}, color={0,0,127}));
  connect(integrator.y, add.u1) annotation (Line(points={{-29,0},{-20,0},{-20,6},
          {-12,6}}, color={0,0,127}));
  connect(step_phase.y, add.u2) annotation (Line(points={{-29,-30},{-20,-30},{-20,
          -6},{-12,-6}}, color={0,0,127}));
  connect(add.y,cos. u)
    annotation (Line(points={{11,0},{28,0}}, color={0,0,127}));
  connect(product1.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(cos.y, product1.u1)
    annotation (Line(points={{51,0},{60,0},{60,6},{68,6}}, color={0,0,127}));
  connect(step_amplitude.y, product1.u2) annotation (Line(points={{51,-30},{60,-30},
          {60,-6},{68,-6}}, color={0,0,127}));
  connect(add.y, phi) annotation (Line(points={{11,0},{20,0},{20,-60},{110,-60}},
        color={0,0,127}));
  connect(step_f.y, gain.u) annotation (Line(points={{-69,0},{-60,0},{-60,60},{-52,
          60}}, color={0,0,127}));
  connect(gain.y, w)
    annotation (Line(points={{-29,60},{110,60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block provides a single sinusoidal signal with choosen amplitude A0 and choosen frequency f0. 
Additionally the following disturbances are injected:
</p>
<ul>
<li>at time t_Phi a step dPhi in the phase of the signal</li>
<li>at time t_f a step df in the frequency of the signal</li>
<li>at time t_A a step dA in the amplitude of the signal</li>
</ul>
</html>"));
end SinglephaseSource;
