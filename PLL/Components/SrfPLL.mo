within PLL.Components;
block SrfPLL "Synchronous reference frame phase locked loop"
  extends Modelica.Blocks.Interfaces.MIMO(final nin=2, final nout=2);
  extends Interfaces.w_theta;
  parameter Real A0=1 "Rated amplitude of input";
  parameter Real damping=1/sqrt(2) "Desired damping";
  parameter SI.Time T=1e-3 "Desired time constant";
  parameter SI.Frequency kp=2*damping/T "Proportional gain";
  parameter SI.Time Ti=2*damping*T "Integral time constant";
  parameter Real epsilon=1e-3 "Protection aginst division by zero";
  parameter Boolean useOmegaInput=false "Use input for estimated omega";
  parameter SI.AngularVelocity wE=0 "Constant estimated angular velocity"
    annotation(Dialog(enable=not useOmegaInput));
  Modelica.Electrical.Machines.SpacePhasors.Blocks.Rotator rotator
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Auxilliary.AddOffset addOffset(gain=1, offset=epsilon*A0)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-20})));
  Modelica.Blocks.Continuous.PI controller(
    k=kp,
    T=Ti,
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1, initType=Modelica.Blocks.Types.Init.NoInit)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,-30})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-60,-20})));
  Auxilliary.Add add
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Interfaces.RealInput we if useOmegaInput "estimated angular velocity"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Modelica.Blocks.Sources.Constant const(k=wE)
                                         if not useOmegaInput
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-90})));
equation
  connect(u, rotator.u) annotation (Line(points={{-120,0},{-92,0}},
                 color={0,0,127}));
  connect(addOffset.y, division.u2)
    annotation (Line(points={{-40,-11},{-40,-6},{-32,-6}}, color={0,0,127}));
  connect(rotator.y[2], division.u1) annotation (Line(points={{-69,0},{-60,0},{
          -60,6},{-32,6}},
                       color={0,0,127}));
  connect(division.y, controller.u)
    annotation (Line(points={{-9,0},{-2,0}},   color={0,0,127}));
  connect(integrator.y, rotator.angle) annotation (Line(points={{70,-41},{70,
          -60},{-80,-60},{-80,-12}}, color={0,0,127}));
  connect(rotator.y[1], abs1.u)
    annotation (Line(points={{-69,0},{-60,0},{-60,-8}}, color={0,0,127}));
  connect(abs1.y, addOffset.u) annotation (Line(points={{-60,-31},{-60,-40},{
          -40,-40},{-40,-28}}, color={0,0,127}));
  connect(rotator.y, y) annotation (Line(points={{-69,0},{-60,0},{-60,20},{80,
          20},{80,0},{110,0}}, color={0,0,127}));
  connect(controller.y, add.u1)
    annotation (Line(points={{21,0},{32,0}}, color={0,0,127}));
  connect(add.y, w) annotation (Line(points={{49,0},{70,0},{70,60},{110,60}},
        color={0,0,127}));
  connect(add.y, integrator.u)
    annotation (Line(points={{49,0},{70,0},{70,-18}}, color={0,0,127}));
  connect(const.y, add.u2)
    annotation (Line(points={{40,-79},{40,-8}}, color={0,0,127}));
  connect(we, add.u2) annotation (Line(points={{0,-120},{0,-20},{40,-20},{40,-8}},
        color={0,0,127}));
  connect(integrator.y, theta)
    annotation (Line(points={{70,-41},{70,-60},{110,-60}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This phase locked loop works in the synchronous reference frame, also with varying frequency. 
</p>
<p>
The input <code>u[1..2]</code> is the &alpha;-&beta;-representation of a threephase signal (after performing the Clarke-transformation), or the cosine and sine signal of an angle sensor. 
</p>
<p>
The output <code>y[1..2]</code> shows the d-q-representation of the input signal.  
</p>
</html>"));
end SrfPLL;
