within PLL.Examples;
model ThreephaseDistorsion
  "Test basic and enhanced three phase PLL with distorted signal"
  extends Modelica.Icons.Example;
  Sources.ThreephaseSource  threephaseSource( f0=60)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Components.Basic3phasePLL basic3phasePLL(
    A0=threephaseSource.A1,
    f0=threephaseSource.f0,
    phi(fixed=true))
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
equation
  connect(threephaseSource.y, basic3phasePLL.u)
    annotation (Line(points={{-9,0},{0,0},{0,20},{10,20}}, color={0,0,127}));
  annotation (experiment(
      Interval=0.0001,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end ThreephaseDistorsion;
