within PLL.Components;
block MultiVariableFilter
  extends Modelica.Blocks.Interfaces.MIMO(final nin=2, final nout=2);
  parameter SI.Angle phi0=0 "Initial phase angle of voltage";
  parameter SI.Frequency fB=2.5 "Bandwidth";
  parameter Boolean useOmegaInput=true "Use an input for actual omega?";
  parameter SI.Frequency fN=50 "Nominal frequency"
    annotation(Dialog(enable=not useOmegaInput));
  Modelica.Blocks.Math.Feedback feedback[2]
    annotation (Placement(transformation(extent={{-80,10},{-60,-10}})));
  Modelica.Blocks.Math.Gain gain[2](each final k=2*pi*fB)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.Add add[2](final k1={+1,+1}, final k2={-1,+1})
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Continuous.Integrator integrator[2](each final k=1,
    each final initType=Modelica.Blocks.Types.Init.InitialState,
    final y_start={cos(phi0 - pi/2),sin(phi0 - pi/2)})
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Product product[2]
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
  Modelica.Blocks.Routing.ExtractSignal extractSignal(
    final nin=2,
    final nout=2,
    final extract={2,1})
    annotation (Placement(transformation(extent={{20,-40},{0,-20}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=2)
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Interfaces.RealInput omega if useOmegaInput
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-100})));
  Modelica.Blocks.Sources.Constant const(k=2*pi*fN) if not useOmegaInput
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(u, feedback.u1) annotation (Line(
      points={{-120,0},{-78,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(feedback.y, gain.u) annotation (Line(
      points={{-61,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, add.u1) annotation (Line(
      points={{-19,0},{-12,0},{-12,6},{-2,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, integrator.u) annotation (Line(
      points={{21,0},{38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, y) annotation (Line(
      points={{61,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, feedback.u2) annotation (Line(
      points={{61,0},{70,0},{70,20},{-70,20},{-70,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, product.u1) annotation (Line(
      points={{61,0},{70,0},{70,-24},{62,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, extractSignal.u) annotation (Line(
      points={{39,-30},{22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(extractSignal.y, add.u2) annotation (Line(
      points={{-1,-30},{-10,-30},{-10,-6},{-2,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, product.u2) annotation (Line(points={{61,-60},{66,-60},{
          66,-44},{62,-44},{62,-36}}, color={0,0,127}));
  connect(const.y, replicator.u)
    annotation (Line(points={{-19,-60},{38,-60}}, color={0,0,127}));
  connect(omega, replicator.u)
    annotation (Line(points={{0,-100},{0,-60},{38,-60}}, color={0,0,127}));
  annotation (                   Documentation(info="<html>
<p>
This is a multi-variable band filter as described in <a href=\"modelica://PLL.UsersGuide.References\">[Oestrem2006]</a>, 
acting on &alpha;- and &beta;-components.
</html>"));
end MultiVariableFilter;
