within PLL.Examples;
model SinglephaseDistorsion
  "Test basic and enhanced single phase PLL with distorted signal"
  extends Modelica.Icons.Example;
  Sources.SinglephaseSource singlephaseSource(f0=60)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Components.Basic1phasePLL basic1phasePLL(
    A0=singlephaseSource.A0,
    f0=singlephaseSource.f0,
    phi(fixed=true))
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
  Components.Enhanced1phasePLL enhanced1phasePLL(
    A0=singlephaseSource.A0,
    f0=singlephaseSource.f0,
    phi(fixed=true))
    annotation (Placement(transformation(extent={{12,-30},{32,-10}})));
equation
  connect(singlephaseSource.y, basic1phasePLL.u)
    annotation (Line(points={{-9,0},{0,0},{0,20},{10,20}}, color={0,0,127}));
  connect(singlephaseSource.y, enhanced1phasePLL.u)
    annotation (Line(points={{-9,0},{0,0},{0,-20},{10,-20}}, color={0,0,127}));
  annotation (experiment(
      Interval=0.0001,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end SinglephaseDistorsion;
