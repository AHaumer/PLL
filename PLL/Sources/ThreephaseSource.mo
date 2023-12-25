within PLL.Sources;
block ThreephaseSource "Basic single phase signal source"
  extends Modelica.Blocks.Interfaces.MO(final nout=m);
  final parameter Integer m=3 "Number of phases";
  parameter SI.Frequency f0=50 "Rated frequency";
  parameter Real A0=0 "Zero component";
  parameter Real A1=1 "Positive sequence";
  parameter Real A2=0 "Negative sequence";
  parameter SI.Time t_Phi=0.1 "Phase disturbance";
  parameter SI.Angle dPhi=15*pi/180 "Phase disturbance";
  parameter SI.Time t_f=0.3 "Frequency disturbance";
  parameter SI.Frequency df=1 "Frequency disturbance";
  parameter SI.Time t_A0=0.6 "Zero component disturbance";
  parameter Real dA0=0.05 "Zero component disturbance";
  parameter SI.Time t_A1=0.4 "Amplitude disturbance";
  parameter Real dA1=0.5 "Amplitude disturbance";
  parameter SI.Time t_A2=0.5 "Negative sequenc disturbance";
  parameter Real dA2=0.05 "Negative sequence disturbance";

  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad", start=0) "Angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Sources.Step step_f(
    height=df,
    offset=f0,
    startTime=t_f)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Math.Gain gain(k=2*pi)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  SymmetricComponent zeroComponent(phaseShift=zeros(m))
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  SymmetricComponent positiveSequence(phaseShift=-symmetricOrientation(m))
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  SymmetricComponent negativeSequence(phaseShift=symmetricOrientation(m))
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=2*pi,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Auxilliary.Add           add
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Blocks.Sources.Step step_phase(
    height=dPhi,
    offset=0,
    startTime=t_Phi)
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Modelica.Blocks.Math.Add3 add3[m]
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.Step step_A0(
    height=dA0,
    offset=A0,
    startTime=t_A0)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Sources.Step step_A1(
    height=dA1,
    offset=A1,
    startTime=t_A1)
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Modelica.Blocks.Sources.Step step_A2(
    height=dA2,
    offset=A2,
    startTime=t_A2)
    annotation (Placement(transformation(extent={{-48,-30},{-28,-10}})));
equation
  connect(step_f.y, gain.u) annotation (Line(points={{-69,0},{-60,0},{-60,80},{
          40,80},{40,60},{58,60}},
                color={0,0,127}));
  connect(step_f.y, zeroComponent.u) annotation (Line(points={{-69,0},{-60,0},{-60,
          40},{-2,40}}, color={0,0,127}));
  connect(step_f.y, positiveSequence.u)
    annotation (Line(points={{-69,0},{-2,0}}, color={0,0,127}));
  connect(step_f.y, negativeSequence.u) annotation (Line(points={{-69,0},{-60,0},
          {-60,-40},{-2,-40}}, color={0,0,127}));
  connect(step_f.y, integrator.u) annotation (Line(points={{-69,0},{-60,0},{-60,
          -80},{-2,-80}},  color={0,0,127}));
  connect(gain.y, w)
    annotation (Line(points={{81,60},{110,60}},  color={0,0,127}));
  connect(step_phase.y, add.u1)
    annotation (Line(points={{-29,-60},{62,-60}},color={0,0,127}));
  connect(integrator.y, add.u2)
    annotation (Line(points={{21,-80},{70,-80},{70,-68}},  color={0,0,127}));
  connect(add.y, phi)
    annotation (Line(points={{79,-60},{110,-60}}, color={0,0,127}));
  connect(step_phase.y, negativeSequence.arg) annotation (Line(points={{-29,-60},
          {-10,-60},{-10,-48},{-2,-48}}, color={0,0,127}));
  connect(step_phase.y, positiveSequence.arg) annotation (Line(points={{-29,-60},
          {-10,-60},{-10,-8},{-2,-8}}, color={0,0,127}));
  connect(zeroComponent.y, add3.u1)
    annotation (Line(points={{21,40},{40,40},{40,8},{58,8}}, color={0,0,127}));
  connect(positiveSequence.y, add3.u2)
    annotation (Line(points={{21,0},{58,0}}, color={0,0,127}));
  connect(negativeSequence.y, add3.u3) annotation (Line(points={{21,-40},{40,
          -40},{40,-8},{58,-8}}, color={0,0,127}));
  connect(add3.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(step_phase.y, zeroComponent.arg) annotation (Line(points={{-29,-60},{
          -10,-60},{-10,32},{-2,32}}, color={0,0,127}));
  connect(step_A0.y, zeroComponent.abs) annotation (Line(points={{-29,60},{-20,
          60},{-20,48},{-2,48}}, color={0,0,127}));
  connect(step_A1.y, positiveSequence.abs) annotation (Line(points={{-29,20},{
          -20,20},{-20,8},{-2,8}}, color={0,0,127}));
  connect(step_A2.y, negativeSequence.abs) annotation (Line(points={{-27,-20},{
          -20,-20},{-20,-32},{-2,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      Interval=0.0001,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>
This block allows to apply disturbances (steps) in frequency, amplitude and phase as well as 
adding a negative sequence and/or a zero component to the three phase output signal <code>y[3]</code>.
</p>
</html>"));
end ThreephaseSource;
