within PLL.PowerElectronics;
block DoubleUnipolarPWM "Double Unipolar pulse width modulation"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(final samplePeriod=1/fsw);
  parameter SI.Frequency fsw "Switching frequency";
  parameter Boolean useVariableVdc=false "use variavle Vdc";
  parameter SI.Voltage constantVdc "Constant Vdc"
    annotation(Dialog(enable=not useVariableVdc));
  Modelica.Blocks.Interfaces.BooleanOutput fireL "Left leg"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput fireR "Right leg"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.RealInput vRef
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Logical.Greater greaterL
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Modelica.Blocks.Sources.Trapezoid carrier(
    rising=0.5/fsw,
    width=0,
    falling=0.5/fsw,
    period=1/fsw,
    startTime=startTime)
                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,0})));
  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=+1, uMin=-1)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Interfaces.RealInput vMax if useVariableVdc
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));
  Auxilliary.AddOffset addOffset(gain=0.5, offset=0.5) annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={20,30})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={80,-2})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold1(samplePeriod=
        samplePeriod, startTime=startTime)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold2(
    samplePeriod=samplePeriod,
    startTime=startTime,
    ySample(start=1e-3, fixed=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
protected
  Modelica.Blocks.Sources.Constant const(k=constantVdc) if not useVariableVdc
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  connect(greaterL.y, fireL)
    annotation (Line(points={{71,60},{110,60}}, color={255,0,255}));
  connect(carrier.y, greaterL.u2) annotation (Line(points={{40,11},{40,52},{48,
          52}},         color={0,0,127}));
  connect(division.y, limiter.u)
    annotation (Line(points={{-19,0},{-14,0}}, color={0,0,127}));
  connect(addOffset.y, greaterL.u1)
    annotation (Line(points={{20,39},{20,60},{48,60}},      color={0,0,127}));
  connect(limiter.y, addOffset.u)
    annotation (Line(points={{9,0},{20,0},{20,22}},
                                              color={0,0,127}));
  connect(greaterL.y, not1.u)
    annotation (Line(points={{71,60},{80,60},{80,10}}, color={255,0,255}));
  connect(not1.y, fireR)
    annotation (Line(points={{80,-13},{80,-60},{110,-60}}, color={255,0,255}));
  connect(vRef, zeroOrderHold1.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(zeroOrderHold1.y, division.u1) annotation (Line(points={{-59,0},{-50,
          0},{-50,6},{-42,6}}, color={0,0,127}));
  connect(vMax, zeroOrderHold2.u)
    annotation (Line(points={{0,-120},{0,-62}}, color={0,0,127}));
  connect(const.y, zeroOrderHold2.u)
    annotation (Line(points={{-19,-80},{0,-80},{0,-62}}, color={0,0,127}));
  connect(zeroOrderHold2.y, division.u2) annotation (Line(points={{0,-39},{0,
          -20},{-50,-20},{-50,-6},{-42,-6}}, color={0,0,127}));
end DoubleUnipolarPWM;
