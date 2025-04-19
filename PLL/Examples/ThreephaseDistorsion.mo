within PLL.Examples;
model ThreephaseDistorsion
  "Test basic and enhanced three phase PLL with distorted signal"
  extends Modelica.Icons.Example;
  Sources.ThreephaseSource  threephaseSource( f0=60)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Components.Basic3phasePLL basic3phasePLL(
    theta(fixed=true),
    A0=threephaseSource.A1,
    f0=threephaseSource.f0)
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.ToSpacePhasor toSpacePhasor
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Components.SrfPLL srfPLL(theta(fixed=true), wE=2*pi*60)
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Components.SimpledqPLL simpledqPLL
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
equation
  connect(threephaseSource.y, toSpacePhasor.u)
    annotation (Line(points={{-9,0},{0,0},{0,20},{8,20}}, color={0,0,127}));
  connect(toSpacePhasor.y, basic3phasePLL.u)
    annotation (Line(points={{31,20},{48,20}}, color={0,0,127}));
  connect(toSpacePhasor.y, srfPLL.u) annotation (Line(points={{31,20},{40,20},{
          40,-10},{48,-10}}, color={0,0,127}));
  connect(toSpacePhasor.y, simpledqPLL.u) annotation (Line(points={{31,20},{40,
          20},{40,-40},{48,-40}}, color={0,0,127}));
  annotation (experiment(
      Interval=0.0001,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"), Documentation(info="<html>
<p>
This example tests the basic version of the three phase PLL acting on a distorted signal. 
Note that performance is satisfying as long as the input is balanced, 
i.e. as long as no negative sequence and/or zero component is added.
</p>
</html>"));
end ThreephaseDistorsion;
