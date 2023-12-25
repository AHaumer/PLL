within PLL.Components;
block Basic1phasePLL "Basic version of single phase phase-locked loop"
  extends Modelica.Blocks.Interfaces.SIMO(final nout=2);
  parameter Real A0=1 "Rated amplitude of input";
  parameter SI.Frequency f0=50 "Rated frequency";
  parameter SI.AngularVelocity wn=0.1*2*pi*f0 "Natural angular velocity";
  parameter Real zeta(min=0, max=1)=0.5 "Damping ratio";
  parameter Real kp=4*zeta*wn/A0 "Proportional gain";
  parameter Real ki=2*wn^2/A0 "Integral gain";
  parameter Boolean useAdaption=false "Use adaptive integrator";
  parameter Real constantAdaption=1 "Constant adaption factor"
    annotation(Dialog(enable=not useAdaption));
  Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
    "Estimated angular velocity"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput phi(unit="rad", start=0)
    "Estimated angle"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Math.Product product0
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,30})));
  Modelica.Blocks.Continuous.Integrator integrator1(
    k=ki,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.Blocks.Continuous.Integrator integrator2(
    k=1, initType=Modelica.Blocks.Types.Init.NoInit)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-60})));
  Modelica.Blocks.Math.Sin sin
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Math.Cos cos
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Math.Gain gain(k=kp)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Auxilliary.AddOffset
                 addOffset(offset=2*pi*f0)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Auxilliary.Add add2
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,40})));
  Modelica.Blocks.Interfaces.RealInput adaption if useAdaption
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Math.Gain neg(k=-1)
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));
protected
  Modelica.Blocks.Sources.Constant const1(k=constantAdaption) if not useAdaption
    annotation (Placement(transformation(extent={{-96,84},{-84,96}})));
  Modelica.Blocks.Interfaces.RealInput adaption1 annotation (Placement(
        transformation(extent={{-84,76},{-76,84}}), iconTransformation(extent={{
            -84,76},{-76,84}})));
equation
  connect(u,product0. u1) annotation (Line(points={{-120,0},{-86,0},{-86,18}},
                color={0,0,127}));
  connect(product0.y, integrator1.u)
    annotation (Line(points={{-80,41},{-80,60},{-52,60}},
                                                 color={0,0,127}));
  connect(product0.y, gain.u) annotation (Line(points={{-80,41},{-80,60},{-60,60},
          {-60,40},{18,40}},
                        color={0,0,127}));
  connect(addOffset.y, add2.u1)
    annotation (Line(points={{39,60},{60,60},{60,48}}, color={0,0,127}));
  connect(gain.y, add2.u2)
    annotation (Line(points={{41,40},{52,40}},         color={0,0,127}));
  connect(addOffset.y, w)
    annotation (Line(points={{39,60},{110,60}}, color={0,0,127}));
  connect(add2.y, integrator2.u)
    annotation (Line(points={{60,31},{60,20},{-30,20},{-30,-60},{-22,-60}},
                                                     color={0,0,127}));
  connect(integrator2.y, cos.u) annotation (Line(points={{1,-60},{10,-60},{10,
          -40},{18,-40}},
                   color={0,0,127}));
  connect(integrator2.y, phi)
    annotation (Line(points={{1,-60},{110,-60}}, color={0,0,127}));
  connect(integrator2.y, sin.u) annotation (Line(points={{1,-60},{10,-60},{10,0},
          {18,0}},        color={0,0,127}));
  connect(adaption, adaption1)
    annotation (Line(points={{-120,80},{-80,80}}, color={0,0,127}));
  connect(integrator1.y, product1.u2) annotation (Line(points={{-29,60},{-20,60},
          {-20,54},{-12,54}}, color={0,0,127}));
  connect(adaption1, product1.u1) annotation (Line(points={{-80,80},{-20,80},{-20,
          66},{-12,66}}, color={0,0,127}));
  connect(const1.y, adaption1)
    annotation (Line(points={{-83.4,90},{-80,90},{-80,80}}, color={0,0,127}));
  connect(product1.y, addOffset.u)
    annotation (Line(points={{11,60},{22,60}}, color={0,0,127}));
  connect(cos.y, y[1]) annotation (Line(points={{41,-40},{90,-40},{90,-2.5},{
          110,-2.5}}, color={0,0,127}));
  connect(sin.y, y[2]) annotation (Line(points={{41,0},{80,0},{80,2.5},{110,2.5}},
        color={0,0,127}));
  connect(sin.y, neg.u) annotation (Line(points={{41,0},{60,0},{60,-20},{-38,
          -20}}, color={0,0,127}));
  connect(neg.y, product0.u2)
    annotation (Line(points={{-61,-20},{-74,-20},{-74,18}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This is the basic version of the single phase PLL. 
Knowing the Amplitude of the input signal <code>u</code>, an adaptive PI-controller can be used 
(like in the <a href=\"modelica://PLL.Components.Enhanced1phasePLL\">enhanced version of the single phase PLL</a>.
</p>
<p>
The output <code>y[1]</code> is a cosine signal in phase with the input <code>u</code>, 
the output <code>y[2]</code> is a sine signal 90&deg; phase shifted to <code>y[1]</code>.
</p>
<p>
Problems: especially a double-frequency ripple on the estimated frequency resp. angular velocity &omega; = 2 &pi; f = <code>w</code>.
</p>
</html>"));
end Basic1phasePLL;
