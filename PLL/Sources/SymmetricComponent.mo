within PLL.Sources;
block SymmetricComponent "Symmetric component defined by phaseShift"
  extends Modelica.Blocks.Interfaces.SIMO(final nout=m, u(unit="Hz"));
  final parameter Integer m=3 "Number of phases";
  parameter SI.Angle phaseShift[m]=-symmetricOrientation(m) "Phase shift between phases";
  Modelica.Blocks.Interfaces.RealInput abs "Amplitude"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput arg(unit="rad", displayUnit="deg") "Argument (phase angle)"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Continuous.Integrator integrator(
    k=2*pi,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Auxilliary.Add add
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Routing.Replicator replicator1(nout=m)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Auxilliary.Add add1[m]
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant const[m](k=phaseShift) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-30})));
  Modelica.Blocks.Math.Cos cos[m]
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Math.Product product1[m]
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Routing.Replicator replicator2(nout=m)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
equation
  connect(u, integrator.u)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));
  connect(integrator.y, add.u1)
    annotation (Line(points={{-69,0},{-58,0}}, color={0,0,127}));
  connect(arg, add.u2)
    annotation (Line(points={{-120,-80},{-50,-80},{-50,-8}}, color={0,0,127}));
  connect(add.y, replicator1.u)
    annotation (Line(points={{-41,0},{-32,0}}, color={0,0,127}));
  connect(replicator1.y, add1.u1)
    annotation (Line(points={{-9,0},{2,0}}, color={0,0,127}));
  connect(const.y, add1.u2)
    annotation (Line(points={{10,-19},{10,-8}}, color={0,0,127}));
  connect(add1.y, cos.u)
    annotation (Line(points={{19,0},{28,0}}, color={0,0,127}));
  connect(cos.y, product1.u2)
    annotation (Line(points={{51,0},{60,0},{60,-6},{68,-6}}, color={0,0,127}));
  connect(product1.y, y)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(abs, replicator2.u)
    annotation (Line(points={{-120,80},{-92,80}}, color={0,0,127}));
  connect(replicator2.y, product1.u1) annotation (Line(points={{-69,80},{60,80},
          {60,6},{68,6}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block provides positive sequence, negative sequence or zero component at the output <code>y[3]</code> 
according to the theory of symmetrical components (<a href=\"modelica://PLL.UsersGuide.References\">[Fortescue1918]</a>),
given by the parameter <code>phaseShift[3]</code>.
</p>
</html>"));
end SymmetricComponent;
