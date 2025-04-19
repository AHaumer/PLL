within PLL.Examples;
model VariableFrequency "Source with variable Frequency"
  extends Modelica.Icons.Example;
  parameter SI.Frequency fNominal=50 "Nominal frequency";
  parameter SI.Voltage VNominal=100 "Nominal rms voltage";
  Modelica.Blocks.Sources.Ramp ramp(
    height=fNominal,
    duration=1,
    offset=0,
    startTime=0.1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Electrical.Machines.Utilities.VfController vfController(VNominal=
        VNominal, fNominal=fNominal,
    BasePhase=pi/2)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasor
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Components.SrfPLL srfPLL(theta(fixed=true), A0=VNominal)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain gain(k=2*pi)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Components.SrfPLL srfPLL1(theta(fixed=true), useOmegaInput=true)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Components.SimpledqPLL simpledqPLL
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(ramp.y, vfController.u)
    annotation (Line(points={{-59,0},{-42,0}}, color={0,0,127}));
  connect(vfController.y, toSpacePhasor.u)
    annotation (Line(points={{-19,0},{-2,0}},  color={0,0,127}));
  connect(toSpacePhasor.y, srfPLL.u)
    annotation (Line(points={{21,0},{38,0}},
                                           color={0,0,127}));
  connect(ramp.y, gain.u) annotation (Line(points={{-59,0},{-50,0},{-50,-30},{
          -42,-30}}, color={0,0,127}));
  connect(gain.y, srfPLL1.we) annotation (Line(points={{-19,-30},{0,-30},{0,-52},
          {50,-52},{50,-42}}, color={0,0,127}));
  connect(toSpacePhasor.y, srfPLL1.u) annotation (Line(points={{21,0},{30,0},{
          30,-30},{38,-30}}, color={0,0,127}));
  connect(toSpacePhasor.y, simpledqPLL.u) annotation (Line(points={{21,0},{30,0},
          {30,-70},{38,-70}}, color={0,0,127}));
  annotation (experiment(
      StopTime=1.5,
      Interval=1e-05,
      Tolerance=1e-06), Documentation(info="<html>
<p>
Here the synchronous reference frame PLL is tested with a balanced three phase signal with varying frequency.
</p>
<p>
Since the <code>vfController</code> is formulated using the sine-function, the common phase shift ist set to <code>BasePhase = &pi;/2</code> to obtain a cosine.
</p>
</html>"));
end VariableFrequency;
