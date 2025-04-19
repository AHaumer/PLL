within PLL.Components;
block MultiVariableFilter
  extends Modelica.Blocks.Interfaces.MIMO(final nin=2, final nout=2);
  parameter SI.Angle phi0=0 "Initial phase angle of voltage";
  parameter SI.Frequency fB=2.5 "Bandwidth";
  parameter Boolean useOmegaInput=false "Use an input for actual omega?";
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
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Interfaces.RealInput omega if useOmegaInput
    "Connector of Real input signals"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Sources.Constant const(k=2*pi*fN) if not useOmegaInput
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
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
  connect(replicator.y, product.u2) annotation (Line(points={{41,-80},{70,-80},{
          70,-36},{62,-36}},          color={0,0,127}));
  connect(const.y, replicator.u)
    annotation (Line(points={{-19,-80},{18,-80}}, color={0,0,127}));
  connect(omega, replicator.u)
    annotation (Line(points={{0,-120},{0,-80},{18,-80}}, color={0,0,127}));
  annotation (                   Documentation(info="<html>
<p>
This is a multi-variable band filter as described in <a href=\"modelica://PLL.UsersGuide.References\">[Oestrem2006]</a>, 
acting on &alpha;- and &beta;-components.
</html>"), Icon(graphics={
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80,90},{-88,68},{-72,68},{-80,90}}),
      Line(points={{-80,78},{-80,-90}},
        color={192,192,192}),
      Line(points={{-90,-80},{82,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-80},{68,-72},{68,-88},{90,-80}}),
      Line(origin={3.333,-8.667},   points = {{-83.333,34.667},{24.667,34.667},{42.667,-71.333}}, color = {0,0,127}, smooth = Smooth.Bezier),
      Rectangle(lineColor={160,160,164},
        fillColor={255,255,255},
        fillPattern=FillPattern.Backward,
        extent={{-80,-80},{22,8}})}));
end MultiVariableFilter;
